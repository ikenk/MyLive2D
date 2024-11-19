////
////  LBridge.m
////  MyLive2D-SwiftUI
////
////  Created by HT Zhang  on 2024/11/19.
////
//
//// Live2DLAppBridge.mm
//
//#import "LBridge.h"
//
//// 导入所有需要的C++头文件
//#import "LAppSprite.h"
//#import "LAppTextureManager.h"
//#import "LAppModel.h"
//#import "LAppLive2DManager.h"
//#import "LAppPal.h"
//#import "LAppDefine.h"
//#import <CubismFramework.hpp>
//
//using namespace Live2D::Cubism::Framework;
//using namespace LAppDefine;
//
//#pragma mark - BridgeTextureInfo Implementation
//
//@implementation BridgeTextureInfo
//@end
//
//#pragma mark - BridgeSprite Implementation
//
//@interface BridgeSprite() {
//    LAppSprite *_internalSprite;
//}
//@end
//
//@implementation BridgeSprite
//
//- (instancetype)initWithX:(float)x y:(float)y width:(float)width height:(float)height
//                maxWidth:(float)maxWidth maxHeight:(float)maxHeight texture:(id<MTLTexture>)texture {
//    self = [super init];
//    if (self) {
//        // 创建对应的LAppSprite实例
//        _internalSprite = [[LAppSprite alloc] initWithMyVar:x Y:y Width:width Height:height
//                                                  MaxWidth:maxWidth MaxHeight:maxHeight Texture:texture];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    if (_internalSprite) {
//        [_internalSprite release];
//        _internalSprite = nil;
//    }
//    [super dealloc];
//}
//
//- (id<MTLTexture>)texture {
//    return [_internalSprite GetTextureId];
//}
//
//- (void)setColorR:(float)r {
//    _internalSprite.spriteColorR = r;
//}
//
//- (float)colorR {
//    return _internalSprite.spriteColorR;
//}
//
//- (void)setColorG:(float)g {
//    _internalSprite.spriteColorG = g;
//}
//
//- (float)colorG {
//    return _internalSprite.spriteColorG;
//}
//
//- (void)setColorB:(float)b {
//    _internalSprite.spriteColorB = b;
//}
//
//- (float)colorB {
//    return _internalSprite.spriteColorB;
//}
//
//- (void)setColorA:(float)a {
//    _internalSprite.spriteColorA = a;
//}
//
//- (float)colorA {
//    return _internalSprite.spriteColorA;
//}
//
//- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
//    [_internalSprite renderImmidiate:renderEncoder];
//}
//
//- (void)resizeWithX:(float)x y:(float)y width:(float)width height:(float)height
//           maxWidth:(float)maxWidth maxHeight:(float)maxHeight {
//    [_internalSprite resizeImmidiate:x Y:y Width:width Height:height
//                           MaxWidth:maxWidth MaxHeight:maxHeight];
//}
//
//- (BOOL)isHitAtPoint:(CGPoint)point {
//    return [_internalSprite isHit:point.x PointY:point.y];
//}
//
//- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a {
//    [_internalSprite SetColor:r g:g b:b a:a];
//}
//
//@end
//
//#pragma mark - BridgeTextureManager Implementation
//
//@interface BridgeTextureManager() {
//    LAppTextureManager *_internalManager;
//}
//@end
//
//@implementation BridgeTextureManager
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _internalManager = [[LAppTextureManager alloc] init];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    if (_internalManager) {
//        [_internalManager release];
//        _internalManager = nil;
//    }
//    [super dealloc];
//}
//
//- (BridgeTextureInfo *)createTextureFromPNGFile:(NSString *)fileName {
//    TextureInfo* info = [_internalManager createTextureFromPngFile:std::string([fileName UTF8String])];
//    if (!info) return nil;
//    
//    BridgeTextureInfo *bridgeInfo = [[BridgeTextureInfo alloc] init];
//    bridgeInfo.textureId = info->id;
//    bridgeInfo.width = info->width;
//    bridgeInfo.height = info->height;
//    bridgeInfo.fileName = [NSString stringWithUTF8String:info->fileName.c_str()];
//    return [bridgeInfo autorelease];
//}
//
//- (void)releaseAllTextures {
//    [_internalManager releaseTextures];
//}
//
//- (void)releaseTextureByName:(NSString *)fileName {
//    [_internalManager releaseTextureByName:std::string([fileName UTF8String])];
//}
//
//- (void)releaseTexture:(id<MTLTexture>)textureId {
//    [_internalManager releaseTextureWithId:textureId];
//}
//
//@end
//
//#pragma mark - BridgeModel Implementation
//
//@interface BridgeModel() {
//    LAppModel *_internalModel;
//}
//@end
//
//@implementation BridgeModel
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _internalModel = new LAppModel();
//    }
//    return self;
//}
//
//- (void)dealloc {
//    if (_internalModel) {
//        delete _internalModel;
//        _internalModel = nullptr;
//    }
//    [super dealloc];
//}
//
//- (float)canvasWidth {
//    return _internalModel->GetModel()->GetCanvasWidth();
//}
//
//- (float)opacity {
//    return _internalModel->GetOpacity();
//}
//
//- (void)setOpacity:(float)opacity {
//    _internalModel->GetModel()->SetModelOpacity(opacity);
//}
//
//- (void)loadAssets:(NSString *)dir fileName:(NSString *)fileName {
//    _internalModel->LoadAssets([dir UTF8String], [fileName UTF8String]);
//}
//
//- (void)update {
//    _internalModel->Update();
//}
//
//- (void)draw:(CGAffineTransform)matrix {
//    float fMatrix[] = {
//        matrix.a, matrix.b, 0.0f, matrix.tx,
//        matrix.c, matrix.d, 0.0f, matrix.ty,
//        0.0f, 0.0f, 1.0f, 0.0f,
//        0.0f, 0.0f, 0.0f, 1.0f
//    };
//    // 转换CGAffineTransform为CubismMatrix44
//    Csm::CubismMatrix44 cubismMatrix;
//    cubismMatrix.SetMatrix(fMatrix);
//    _internalModel->Draw(cubismMatrix);
//}
//
//- (BOOL)hitTest:(NSString *)hitAreaName point:(CGPoint)point {
//    return _internalModel->HitTest([hitAreaName UTF8String], point.x, point.y);
//}
//
//- (void)startMotion:(NSString *)group index:(NSInteger)no priority:(NSInteger)priority {
//    _internalModel->StartMotion([group UTF8String], (Csm::csmInt32)no, (Csm::csmInt32)priority);
//}
//
//- (void)startRandomMotion:(NSString *)group priority:(NSInteger)priority {
//    _internalModel->StartRandomMotion([group UTF8String], (Csm::csmInt32)priority);
//}
//
//- (void)setExpression:(NSString *)expressionId {
//    _internalModel->SetExpression([expressionId UTF8String]);
//}
//
//- (void)setRandomExpression {
//    _internalModel->SetRandomExpression();
//}
//
//- (void)setDragging:(CGPoint)point {
//    _internalModel->SetDragging(point.x, point.y);
//}
//
//- (NSArray<NSString *> *)motionGroups {
//    // 此处需要从modelSetting中获取所有动作组名称
//    NSMutableArray *groups = [NSMutableArray array];
//    // 添加默认的动作组
//    [groups addObject:@"Idle"];
//    [groups addObject:@"TapBody"];
//    return groups;
//}
//
//- (NSArray<NSString *> *)expressionNames {
//    // 此处需要从modelSetting中获取所有表情名称
//    NSMutableArray *expressions = [NSMutableArray array];
//    // 实际应该从modelSetting中读取
//    return expressions;
//}
//
//@end
//
//
//#pragma mark - BridgeLive2DManager Implementation
//
//@interface BridgeLive2DManager() {
//    LAppLive2DManager *_internalManager;
//}
//@end
//
//@implementation BridgeLive2DManager
//
//static BridgeLive2DManager *sharedInstance = nil;
//
//+ (instancetype)sharedManager {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[BridgeLive2DManager alloc] init];
//    });
//    return sharedInstance;
//}
//
//+ (void)releaseManager {
//    if (sharedInstance) {
//        [sharedInstance release];
//        sharedInstance = nil;
//        [LAppLive2DManager releaseInstance];
//    }
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _internalManager = [LAppLive2DManager getInstance];
//        _renderPassDescriptor = [[MTLRenderPassDescriptor alloc] init];
//        _renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
//        _renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0f, 0.0f, 0.0f, 0.0f);
//        _renderPassDescriptor.depthAttachment.loadAction = MTLLoadActionClear;
//        _renderPassDescriptor.depthAttachment.storeAction = MTLStoreActionDontCare;
//        _renderPassDescriptor.depthAttachment.clearDepth = 1.0;
//        
//        // 初始化时设置模型
//        [self setUpModel];
//        // 默认切换到第一个场景
//        [self changeScene:0];
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [self releaseAllModels];
//    
//    if (_renderPassDescriptor) {
//        [_renderPassDescriptor release];
//        _renderPassDescriptor = nil;
//    }
//    
//    if (_sprite) {
//        [_sprite release];
//        _sprite = nil;
//    }
//    
//    [super dealloc];
//}
//
//#pragma mark - Model Management
//
//- (BridgeModel *)getModelAtIndex:(NSUInteger)index {
//    LAppModel* model = [_internalManager getModel:(Csm::csmUint32)index];
//    if (!model) return nil;
//    
//    BridgeModel *bridgeModel = [[BridgeModel alloc] init];
//    // 这里应该设置bridgeModel的内部model为获取到的model
//    // 注意：这里需要适当的内存管理
//    return [bridgeModel autorelease];
//}
//
//- (void)releaseAllModels {
//    [_internalManager releaseAllModel];
//}
//
//- (void)setUpModel {
//    [_internalManager setUpModel];
//}
//
//- (NSUInteger)getModelCount {
//    return [_internalManager GetModelNum];
//}
//
//#pragma mark - Scene Management
//
//- (void)nextScene {
//    [_internalManager nextScene];
//}
//
//- (void)changeScene:(NSInteger)index {
//    [_internalManager changeScene:(Csm::csmInt32)index];
//}
//
//- (void)setViewMatrix:(CGAffineTransform)matrix {
//    // 将 CGAffineTransform 转换为 CubismMatrix44
//    Csm::CubismMatrix44* cubismMatrix = new Csm::CubismMatrix44();
//    // 注意Metal中的矩阵是列主序的，而CGAffineTransform是行主序的
//    cubismMatrix->Set(
//        matrix.a, matrix.b, 0.0f, matrix.tx,
//        matrix.c, matrix.d, 0.0f, matrix.ty,
//        0.0f, 0.0f, 1.0f, 0.0f,
//        0.0f, 0.0f, 0.0f, 1.0f
//    );
//    
//    [_internalManager SetViewMatrix:cubismMatrix];
//    delete cubismMatrix;
//}
//
//#pragma mark - Interaction Handling
//
//- (void)onDrag:(CGPoint)point {
//    [_internalManager onDrag:point.x floatY:point.y];
//}
//
//- (void)onTap:(CGPoint)point {
//    [_internalManager onTap:point.x floatY:point.y];
//}
//
//- (void)onUpdate:(id<MTLCommandBuffer>)commandBuffer
//  currentDrawable:(id<CAMetalDrawable>)drawable
//     depthTexture:(id<MTLTexture>)depthTarget {
//    // 更新前确保所有参数都有效
//    if (!commandBuffer || !drawable || !depthTarget) {
//        NSLog(@"Invalid parameters for onUpdate");
//        return;
//    }
//    
//    [_internalManager onUpdate:commandBuffer currentDrawable:drawable depthTexture:depthTarget];
//}
//
//#pragma mark - Rendering Configuration
//
//- (void)switchRenderingTarget:(BridgeRenderTarget)target {
//    SelectTarget internalTarget;
//    switch (target) {
//        case BridgeRenderTarget_None:
//            internalTarget = SelectTarget_None;
//            break;
//        case BridgeRenderTarget_ModelFrameBuffer:
//            internalTarget = SelectTarget_ModelFrameBuffer;
//            break;
//        case BridgeRenderTarget_ViewFrameBuffer:
//            internalTarget = SelectTarget_ViewFrameBuffer;
//            break;
//    }
//    [_internalManager SwitchRenderingTarget:internalTarget];
//}
//
//- (void)setRenderTargetClearColor:(float)r g:(float)g b:(float)b {
//    // 确保颜色值在有效范围内
//    r = fmin(fmax(r, 0.0f), 1.0f);
//    g = fmin(fmax(g, 0.0f), 1.0f);
//    b = fmin(fmax(b, 0.0f), 1.0f);
//    
//    [_internalManager SetRenderTargetClearColor:r g:g b:b];
//}
//
//#pragma mark - Properties
//
//- (BridgeSprite *)sprite {
//    if (!_sprite) {
//        LAppSprite *internalSprite = [_internalManager sprite];
//        if (internalSprite) {
//            // 创建一个新的BridgeSprite来包装内部的LAppSprite
//            // 注意：这里需要根据实际的BridgeSprite初始化方法来调整
//            float width = 0.0f;  // 需要从internalSprite获取实际值
//            float height = 0.0f; // 需要从internalSprite获取实际值
//            _sprite = [[BridgeSprite alloc] initWithX:0.0f
//                                                   y:0.0f
//                                               width:width
//                                              height:height
//                                            maxWidth:width
//                                           maxHeight:height
//                                            texture:[internalSprite texture]];
//        }
//    }
//    return _sprite;
//}
//
//- (void)setSprite:(BridgeSprite *)sprite {
//    if (_sprite != sprite) {
//        [_sprite release];
//        _sprite = [sprite retain];
//    }
//}
//
//- (MTLRenderPassDescriptor *)renderPassDescriptor {
//    return _renderPassDescriptor;
//}
//
//- (void)setRenderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor {
//    if (_renderPassDescriptor != renderPassDescriptor) {
//        [_renderPassDescriptor release];
//        _renderPassDescriptor = [renderPassDescriptor retain];
//    }
//}
//
//#pragma mark - Memory Management
//
//- (void)didReceiveMemoryWarning {
//    // 在内存警告时释放非必要资源
//    [self releaseAllModels];
//    if (_sprite) {
//        [_sprite release];
//        _sprite = nil;
//    }
//}
//
//#pragma mark - Internal Helpers
//
//- (LAppLive2DManager *)internalManager {
//    return _internalManager;
//}
//
//@end
