//
//  My_LRender.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/21.
//

#import "My_LRender.h"

// Apple
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAMetalLayer.h>
#import <Metal/Metal.h>
#import <UIKit/UIKit.h>

// Cpp
#import <string>
#import "CubismFramework.hpp"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>
#import "Rendering/Metal/CubismRenderingInstanceSingleton_Metal.h"

#import "LAppTextureManager.h"

// Custom
#import "My_LAppAllocator.h"
#import "My_LAppPal.h"
#import "My_LAppDefine.h"
#import "My_LAppLive2DManager.h"
#import "My_ViewController.h"
#import "My_AppDelegateBridge.h"
#import "My_LAppTextureManager.h"

#import "MetalUIView.h"
#import "MetalView.h"

//#define BUFFER_OFFSET(bytes) ((GLubyte *)NULL + (bytes))

using namespace std;
using namespace Live2D::Cubism::Framework;
using namespace Live2D::Cubism::Core;
using namespace LAppDefine;


//static LAppTextureManager* _textureManager;

//@implementation Live2DCubism
//static Csm::CubismFramework::Option _cubismOption;
//static LAppAllocator _cubismAllocator;
//
//+ (void)initializeCubism {
//    _cubismOption.LogFunction = LAppPal::PrintMessageLn;
//    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;
//
//    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);
//
//    Csm::CubismFramework::Initialize();
//
//    [LAppLive2DManager getInstance];
//
//    Csm::CubismMatrix44 projection;
//
//    LAppPal::UpdateTime();
//}
//
////+ (void)initializeTextureManager {
////    _textureManager = [[LAppTextureManager alloc]init];
////}
////
////+ (void)deinitializeTextureManager{
////    _textureManager = nil;
////}
//
//+ (void)deinitializeCubism {
//
//    [LAppLive2DManager releaseInstance];
//
//    Csm::CubismFramework::Dispose();
//
//    exit(0);
//}
//
//+ (NSString *)live2DVersion {
//    unsigned int version = csmGetVersion();
//    unsigned int major = (version >> 24) & 0xff;
//    unsigned int minor = (version >> 16) & 0xff;
//    unsigned int patch = version & 0xffff;
//
//    return [NSString stringWithFormat:@"v%1$d.%2$d.%3$d", major, minor, patch];
//}
//@end

//@interface My_ModelRender (){
////   __weak UIViewController<MetalViewDelegate>* _viewController;
//    My_ViewController* _My_ViewController;
//}

@interface My_ModelRender()
@property (nonatomic,weak) My_ViewController* My_ViewController;


@property (nonatomic) LAppSprite *back; //背景画像
//@property (nonatomic) LAppSprite *gear; //歯車画像
//@property (nonatomic) LAppSprite *power; //電源画像
@property (nonatomic) LAppSprite *renderSprite; //レンダリングターゲット描画用
//@property (nonatomic) TouchManager *touchManager; ///< タッチマネージャー
@property (nonatomic) Csm::CubismMatrix44 *deviceToScreen;///< デバイスからスクリーンへの行列
@property (nonatomic) Csm::CubismViewMatrix *viewMatrix;

@end

@implementation My_ModelRender

//- (instancetype)initWithViewController:(UIViewController<MetalViewDelegate> *)viewController {
//    if (self = [super init]) {
//        _viewController = viewController;
//    }
//    return self;
//}

- (instancetype)initWithViewController:(UIViewController<MetalViewDelegate> *)viewController commandQueue:(id<MTLCommandQueue>)commandQueue depthTexture:(id<MTLTexture>)depthTexture {
    if (self = [super init]) {
        _My_ViewController = My_ViewController.shared;
        [_My_ViewController setToViewController:viewController];
        [_My_ViewController setCommandQueue:commandQueue];
        [_My_ViewController setDepthTexture:depthTexture];
    }
    
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    MetalUIView *metalUiView = [[MetalUIView alloc] init];
//    [_viewController setView:metalUiView];
    [self.My_ViewController.viewController setView:metalUiView];
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
    MetalUIView *view = (MetalUIView*)self.My_ViewController.viewController.view;

    // Set the device for the layer so the layer can create drawable textures that can be rendered to
    // on this device.
    view.metalLayer.device = device;

    // Set this class as the delegate to receive resize and render callbacks.
//    view.delegate = _viewController;
    view.delegate = self.My_ViewController.viewController;

    view.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    [single setMetalLayer:view.metalLayer];

//    _commandQueue = [device newCommandQueue];
    self.My_ViewController.commandQueue = [device newCommandQueue];

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
    int width = self.My_ViewController.viewController.view.frame.size.width;
    int height = self.My_ViewController.viewController.view.frame.size.height;

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
    
    float width = My_ViewController.shared.viewController.view.frame.size.width;
    float height = My_ViewController.shared.viewController.view.frame.size.height;

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
    
    float maxWidth = My_ViewController.shared.viewController.view.frame.size.width;
    float maxHeight = My_ViewController.shared.viewController.view.frame.size.height;

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
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//
//    [_touchManager touchesBegan:point.x DeciveY:point.y];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.view];
//
//    float viewX = [self transformViewX:[_touchManager getX]];
//    float viewY = [self transformViewY:[_touchManager getY]];
//
//    [_touchManager touchesMoved:point.x DeviceY:point.y];
//    [[LAppLive2DManager getInstance] onDrag:viewX floatY:viewY];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    NSLog(@"%@", touch.view);
//
//    CGPoint point = [touch locationInView:self.view];
//    float pointY = [self transformTapY:point.y];
//
//    // タッチ終了
//    LAppLive2DManager* live2DManager = [LAppLive2DManager getInstance];
//    [live2DManager onDrag:0.0f floatY:0.0f];
//    {
//        // シングルタップ
//        float getX = [_touchManager getX];// 論理座標変換した座標を取得。
//        float getY = [_touchManager getY]; // 論理座標変換した座標を取得。
//        float x = _deviceToScreen->TransformX(getX);
//        float y = _deviceToScreen->TransformY(getY);
//
//        if (DebugTouchLogEnable)
//        {
//            LAppPal::PrintLogLn("[APP]touchesEnded x:%.2f y:%.2f", x, y);
//        }
//
//        [live2DManager onTap:x floatY:y];
//
//        // 歯車にタップしたか
//        if ([_gear isHit:point.x PointY:pointY])
//        {
//            [live2DManager nextScene];
//        }
//
//        // 電源ボタンにタップしたか
//        if ([_power isHit:point.x PointY:pointY])
//        {
//            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//            [delegate finishApplication];
//        }
//    }
//}
//
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

//- (float)transformTapY:(float)deviceY
//{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    ViewController* view = [delegate viewController];
//    float height = view.view.frame.size.height;
//    return deviceY * -1 + height;
//}

- (void)drawableResize:(CGSize)size
{
    MTLTextureDescriptor* depthTextureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatDepth32Float width:size.width height:size.height mipmapped:false];
    depthTextureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;
    depthTextureDescriptor.storageMode = MTLStorageModePrivate;

    CubismRenderingInstanceSingleton_Metal *single = [CubismRenderingInstanceSingleton_Metal sharedManager];
    id <MTLDevice> device = [single getMTLDevice];
//    _depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];
    self.My_ViewController.depthTexture = [device newTextureWithDescriptor:depthTextureDescriptor];

    [self resizeScreen];
}


- (void)renderSprite:(id<MTLRenderCommandEncoder>)renderEncoder
{
    [_back renderImmidiate:renderEncoder];

//    [_gear renderImmidiate:renderEncoder];
//
//    [_power renderImmidiate:renderEncoder];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    LAppPal::UpdateTime();

//    id <MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    id <MTLCommandBuffer> commandBuffer = [self.My_ViewController.commandQueue commandBuffer];
    id<CAMetalDrawable> currentDrawable = [layer nextDrawable];

    MTLRenderPassDescriptor *renderPassDescriptor = [[[MTLRenderPassDescriptor alloc] init] autorelease];
    renderPassDescriptor.colorAttachments[0].texture = currentDrawable.texture;
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);

    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];

    //モデル以外の描画
//    [self renderSprite:renderEncoder];

    [renderEncoder endEncoding];

    LAppLive2DManager* Live2DManager = [LAppLive2DManager getInstance];
    
    [Live2DManager SetViewMatrix:_viewMatrix];
    
    
//    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:_depthTexture];
    [Live2DManager onUpdate:commandBuffer currentDrawable:currentDrawable depthTexture:self.My_ViewController.depthTexture];

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
    MetalUIView *view = (MetalUIView*)self.My_ViewController.viewController.view;

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

