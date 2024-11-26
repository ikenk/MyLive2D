//
//  My_ViewController.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/24.
//

#import "My_ViewControllerBridge.h"

// Apple
#import <Foundation/Foundation.h>

// Cpp
#import <string>
#import "CubismFramework.hpp"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"

// Custom
#import "My_LAppPal.h"
#import "My_LAppDefine.h"
#import "My_LAppLive2DManager.h"
#import "My_AppDelegateBridge.h"
#import "My_LAppTextureManager.h"
#import "My_LAppSprite.h"
#import "MetalUIView.h"
#import "MetalView.h"

using namespace std;
using namespace Live2D::Cubism::Framework;
using namespace Live2D::Cubism::Core;
using namespace LAppDefine;


@interface My_ViewControllerBridge()

@property (nonatomic) LAppSprite *back; //背景画像
//@property (nonatomic) LAppSprite *gear; //歯車画像
//@property (nonatomic) LAppSprite *power; //電源画像
@property (nonatomic) LAppSprite *renderSprite; //レンダリングターゲット描画用
//@property (nonatomic) TouchManager *touchManager; ///< タッチマネージャー
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;///< デバイスからスクリーンへの行列
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;

@end

@implementation My_ViewControllerBridge

+ (instancetype)shared {
    static My_ViewControllerBridge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[My_ViewControllerBridge alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _commandQueue = nil;
        _depthTexture = nil;
        _viewController = nil;
    }
    return self;
}

- (void)setToViewController:(UIViewController <MetalViewDelegate>*)viewController{
    self.viewController = viewController;
}

- (void)setToCommandQueue:(id<MTLCommandQueue>)commandQueue{
    self.commandQueue = commandQueue;
}

- (void)setToDepthTexture:(id<MTLTexture>)depthTexture{
    self.depthTexture = depthTexture;
}




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    MetalUIView *metalUiView = [[MetalUIView alloc] init];
//    [_viewController setView:metalUiView];
    [self.viewController setView:metalUiView];
}

- (void)viewDidLoad
{
#if TARGET_OS_MACCATALYST
    if (AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate])
    {
        appDelegate.window.windowScene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
    }
#endif

    //Fremework層でもMTLDeviceを参照するためシングルトンオブジェクトに登録
    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    [single setMTLDevice:device];

//    MetalUIView *view = (MetalUIView*)_viewController.view;
    MetalUIView *view = (MetalUIView*)self.viewController.view;

    // Set the device for the layer so the layer can create drawable textures that can be rendered to
    // on this device.
    view.metalLayer.device = device;

    // Set this class as the delegate to receive resize and render callbacks.
//    view.delegate = _viewController;
    view.delegate = self.viewController;

    view.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    [single setMetalLayer:view.metalLayer];

//    _commandQueue = [device newCommandQueue];
    self.commandQueue = [device newCommandQueue];

    _anotherTarget = false;
    _clearColorR = _clearColorG = _clearColorB = 1.0f;
    _clearColorA = .0f;

    // タッチ関係のイベント管理
//    _touchManager = [[TouchManager alloc]init];

    // デバイス座標からスクリーン座標に変換するための
    _deviceToScreen = new CubismMatrix44();

    // 画面の表示の拡大縮小や移動の変換を行う行列
    _viewMatrix = new CubismViewMatrix();

    [self initializeScreen];
}

- (void)initializeScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int width = screenRect.size.width;
    int height = screenRect.size.height;

    // 縦サイズを基準とする
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;

    // デバイスに対応する画面の範囲。 Xの左端, Xの右端, Yの下端, Yの上端
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    _viewMatrix->Scale(ViewScale, ViewScale);

    _deviceToScreen->LoadIdentity(); // サイズが変わった際などリセット必須
    if (width > height)
    {
        float screenW = fabsf(right - left);
        _deviceToScreen->ScaleRelative(screenW / width, -screenW / width);
    }
    else
    {
        float screenH = fabsf(top - bottom);
        _deviceToScreen->ScaleRelative(screenH / height, -screenH / height);
    }
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);

    // 表示範囲の設定
    _viewMatrix->SetMaxScale(ViewMaxScale); // 限界拡大率
    _viewMatrix->SetMinScale(ViewMinScale); // 限界縮小率

    // 表示できる最大範囲
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );
}

- (void)resizeScreen
{
//    AppDelegate* delegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//    ViewController* view = [delegate viewController];
//    int width = view.view.frame.size.width;
//    int height = view.view.frame.size.height;
//    int width = _viewController.view.frame.size.width;
//    int height = _viewController.view.frame.size.height;
    int width = self.viewController.view.frame.size.width;
    int height = self.viewController.view.frame.size.height;

    // 縦サイズを基準とする
    float ratio = static_cast<float>(width) / static_cast<float>(height);
    float left = -ratio;
    float right = ratio;
    float bottom = ViewLogicalLeft;
    float top = ViewLogicalRight;

    // デバイスに対応する画面の範囲。 Xの左端, Xの右端, Yの下端, Yの上端
    _viewMatrix->SetScreenRect(left, right, bottom, top);
    _viewMatrix->Scale(ViewScale, ViewScale);

    _deviceToScreen->LoadIdentity(); // サイズが変わった際などリセット必須
    if (width > height)
    {
        float screenW = fabsf(right - left);
        _deviceToScreen->ScaleRelative(screenW / width, -screenW / width);
    }
    else
    {
        float screenH = fabsf(top - bottom);
        _deviceToScreen->ScaleRelative(screenH / height, -screenH / height);
    }
    _deviceToScreen->TranslateRelative(-width * 0.5f, -height * 0.5f);

    // 表示範囲の設定
    _viewMatrix->SetMaxScale(ViewMaxScale); // 限界拡大率
    _viewMatrix->SetMinScale(ViewMinScale); // 限界縮小率

    // 表示できる最大範囲
    _viewMatrix->SetMaxScreenRect(
                                  ViewLogicalMaxLeft,
                                  ViewLogicalMaxRight,
                                  ViewLogicalMaxBottom,
                                  ViewLogicalMaxTop
                                  );

#if TARGET_OS_MACCATALYST
    [self resizeSprite:width Height:height];
#endif

}

- (void)initializeSprite
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    ViewController* view = [delegate viewController];
//    float width = view.view.frame.size.width;
//    float height = view.view.frame.size.height;
    
    float width = My_ViewControllerBridge.shared.viewController.view.frame.size.width;
    float height = My_ViewControllerBridge.shared.viewController.view.frame.size.height;

//    LAppTextureManager* textureManager = [delegate getTextureManager];
    My_LAppTextureManager* textureManager = My_AppDelegateBridge.shared.textureManager;
    const string resourcesPath = ResourcesPath;

    //背景
    string imageName = BackImageName;
//    TextureInfo* backgroundTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
    NSString *filePath = @((resourcesPath + imageName).c_str());
    My_LAppTextureInfo* backgroundTexture = [textureManager createTextureFromPngFile:filePath];
    float x = width * 0.5f;
    float y = height * 0.5f;
//    float fWidth = static_cast<float>(backgroundTexture->width * 2.0f);
    float fWidth = static_cast<float>(backgroundTexture.width * 2.0f);
    float fHeight = static_cast<float>(height) * 0.95f;
//    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight MaxWidth:width MaxHeight:height Texture:backgroundTexture->id];
    _back = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight MaxWidth:width MaxHeight:height Texture:backgroundTexture.textureId];

//    //モデル変更ボタン
//    imageName = GearImageName;
//    TextureInfo* gearTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
//    x = static_cast<float>(width - gearTexture->width * 0.5f);
//    y = static_cast<float>(height - gearTexture->height * 0.5f);
//    fWidth = static_cast<float>(gearTexture->width);
//    fHeight = static_cast<float>(gearTexture->height);
//    _gear = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight MaxWidth:width MaxHeight:height Texture:gearTexture->id];
//
//    //電源ボタン
//    imageName = PowerImageName;
//    TextureInfo* powerTexture = [textureManager createTextureFromPngFile:resourcesPath+imageName];
//    x = static_cast<float>(width - powerTexture->width * 0.5f);
//    y = static_cast<float>(powerTexture->height * 0.5f);
//    fWidth = static_cast<float>(powerTexture->width);
//    fHeight = static_cast<float>(powerTexture->height);
//    _power = [[LAppSprite alloc] initWithMyVar:x Y:y Width:fWidth Height:fHeight MaxWidth:width MaxHeight:height Texture:powerTexture->id];
}

- (void)resizeSprite:(float)width Height:(float)height
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    ViewController* view = [delegate viewController];
//    float maxWidth = view.view.frame.size.width;
//    float maxHeight = view.view.frame.size.height;
    
    float maxWidth = My_ViewControllerBridge.shared.viewController.view.frame.size.width;
    float maxHeight = My_ViewControllerBridge.shared.viewController.view.frame.size.height;

    //背景
    float x = width * 0.5f;
    float y = height * 0.5f;
    float fWidth = static_cast<float>(_back.GetTextureId.width * 2.0f);
    float fHeight = static_cast<float>(height) * 0.95f;
    [_back resizeImmidiate:x Y:y Width:fWidth Height:fHeight MaxWidth:maxWidth MaxHeight:maxHeight];

//    //モデル変更ボタン
//    x = static_cast<float>(width - _gear.GetTextureId.width * 0.5f);
//    y = static_cast<float>(height - _gear.GetTextureId.height * 0.5f);
//    fWidth = static_cast<float>(_gear.GetTextureId.width);
//    fHeight = static_cast<float>(_gear.GetTextureId.height);
//    [_gear resizeImmidiate:x Y:y Width:fWidth Height:fHeight MaxWidth:maxWidth MaxHeight:maxHeight];
//
//    //電源ボタン
//    x = static_cast<float>(width - _power.GetTextureId.width * 0.5f);
//    y = static_cast<float>(_power.GetTextureId.height * 0.5f);
//    fWidth = static_cast<float>(_power.GetTextureId.width);
//    fHeight = static_cast<float>(_power.GetTextureId.height);
//    [_power resizeImmidiate:x Y:y Width:fWidth Height:fHeight MaxWidth:maxWidth MaxHeight:maxHeight];
}

- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder
{
    [_back renderImmidiate:renderEncoder];

//    [_gear renderImmidiate:renderEncoder];
//
//    [_power renderImmidiate:renderEncoder];
}

- (float)transformViewX:(float)deviceX
{
    float screenX = _deviceToScreen->TransformX(deviceX); // 論理座標変換した座標を取得。
    return _viewMatrix->InvertTransformX(screenX); // 拡大、縮小、移動後の値。
}

- (float)transformViewY:(float)deviceY
{
    float screenY = _deviceToScreen->TransformY(deviceY); // 論理座標変換した座標を取得。
    return _viewMatrix->InvertTransformY(screenY); // 拡大、縮小、移動後の値。
}

- (float)transformScreenX:(float)deviceX
{
    return _deviceToScreen->TransformX(deviceX);
}

- (float)transformScreenY:(float)deviceY
{
    return _deviceToScreen->TransformY(deviceY);
}

- (void)drawableResize:(CGSize)size
{
    MTLTextureDescriptor* depthTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatDepth32Float width:size.width height:size.height mipmapped:false];
    depthTextureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
    depthTextureDescriptor.storageMode = MTLStorageModePrivate;

    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id <MTLDevice> device = [single getMTLDevice];
//    _depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];
    self.depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];

    [self resizeScreen];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    LAppPal::UpdateTime();

//    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    id <MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<CAMetalDrawable> currentDrawable = [layer nextDrawable];

    MTLRenderPassDescriptor *renderPassDescriptor = [[[MTLRenderPassDescriptor alloc] init] autorelease];
    renderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);

    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    //モデル以外の描画
    [self renderSprite:renderEncoder];

    [renderEncoder endEncoding];

    LAppLive2DManager* Live2DManager = [LAppLive2DManager getInstance];
    [Live2DManager SetViewMatrix:_viewMatrix];
//    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:_depthTexture];
    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:self.depthTexture];

    [commandBuffer presentDrawable:currentDrawable];
    [commandBuffer commit];
}

- (void)releaseView
{
//    _renderSprite = nil;
//    [_gear release];
//    [_back release];
//    [_power release];
//    _gear = nil;
//    _back = nil;
//    _power = nil;

//    MetalUIView *view = (MetalUIView*)self.view;
//    MetalUIView *view = (MetalUIView*)_viewController.view;
    MetalUIView *view = (MetalUIView*)self.viewController.view;

    view = nil;

    delete(_viewMatrix);
    _viewMatrix = nil;
    delete(_deviceToScreen);
    _deviceToScreen = nil;
//    _touchManager = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
