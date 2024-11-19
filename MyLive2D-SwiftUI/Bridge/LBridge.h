//
//  LBridge.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/19.
//

#ifndef LBridge_h
#define LBridge_h

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAMetalLayer.h>

// 对应 LAppModel 中的渲染目标枚举
typedef NS_ENUM(NSUInteger, BridgeRenderTarget) {
    BridgeRenderTarget_None,                // 对应 SelectTarget_None
    BridgeRenderTarget_ModelFrameBuffer,    // 对应 SelectTarget_ModelFrameBuffer
    BridgeRenderTarget_ViewFrameBuffer      // 对应 SelectTarget_ViewFrameBuffer
};

// 对应 LAppSprite 中的 SpriteRect 结构
typedef struct {
    float left;
    float right;
    float up;
    float down;
} BridgeSpriteRect;

// 纹理信息结构体 - 对应 LAppTextureManager 中的 TextureInfo
@interface BridgeTextureInfo : NSObject
@property (nonatomic, strong) id<MTLTexture> textureId;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, copy) NSString *fileName;
@end

// 精灵管理 - 对应 LAppSprite
@interface BridgeSprite : NSObject

// 对应 LAppSprite 的属性和方法
@property (nonatomic, readonly) id<MTLTexture> texture;
@property (nonatomic, assign) float colorR;
@property (nonatomic, assign) float colorG;
@property (nonatomic, assign) float colorB;
@property (nonatomic, assign) float colorA;

- (instancetype)initWithX:(float)x y:(float)y width:(float)width height:(float)height
                maxWidth:(float)maxWidth maxHeight:(float)maxHeight texture:(id<MTLTexture>)texture;
- (void)renderWithEncoder:(id<MTLRenderCommandEncoder>)renderEncoder;
- (void)resizeWithX:(float)x y:(float)y width:(float)width height:(float)height
           maxWidth:(float)maxWidth maxHeight:(float)maxHeight;
- (BOOL)isHitAtPoint:(CGPoint)point;
- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a;

@end

// 纹理管理 - 对应 LAppTextureManager
@interface BridgeTextureManager : NSObject

- (BridgeTextureInfo *)createTextureFromPNGFile:(NSString *)fileName;
- (void)releaseAllTextures;
- (void)releaseTextureByName:(NSString *)fileName;
- (void)releaseTexture:(id<MTLTexture>)textureId;

@end

// 模型管理 - 对应 LAppModel
@interface BridgeModel : NSObject

@property (nonatomic, readonly) float canvasWidth;
@property (nonatomic, assign) float opacity;
@property (nonatomic, readonly) NSArray<NSString *> *motionGroups;
@property (nonatomic, readonly) NSArray<NSString *> *expressionNames;

- (void)loadAssets:(NSString *)dir fileName:(NSString *)fileName;
- (void)update;
- (void)draw:(CGAffineTransform)matrix;
- (BOOL)hitTest:(NSString *)hitAreaName point:(CGPoint)point;
- (void)startMotion:(NSString *)group index:(NSInteger)no priority:(NSInteger)priority;
- (void)startRandomMotion:(NSString *)group priority:(NSInteger)priority;
- (void)setExpression:(NSString *)expressionId;
- (void)setRandomExpression;
- (void)setDragging:(CGPoint)point;
- (void)setAcceleration:(CGPoint)acceleration;

@end

// Live2D管理器 - 对应 LAppLive2DManager
@interface BridgeLive2DManager : NSObject

+ (instancetype)sharedManager;
+ (void)releaseManager;

// 模型管理
- (BridgeModel *)getModelAtIndex:(NSUInteger)index;
- (void)releaseAllModels;
- (void)setUpModel;
- (NSUInteger)getModelCount;

// 场景管理
- (void)nextScene;
- (void)changeScene:(NSInteger)index;
- (void)setViewMatrix:(CGAffineTransform)matrix;

// 交互处理
- (void)onDrag:(CGPoint)point;
- (void)onTap:(CGPoint)point;
- (void)onUpdate:(id<MTLCommandBuffer>)commandBuffer
 currentDrawable:(id<CAMetalDrawable>)drawable
    depthTexture:(id<MTLTexture>)depthTarget;

// 渲染设置
- (void)switchRenderingTarget:(BridgeRenderTarget)target;
- (void)setRenderTargetClearColor:(float)r g:(float)g b:(float)b;

@property (nonatomic, strong) BridgeSprite *sprite;
@property (nonatomic, strong) MTLRenderPassDescriptor *renderPassDescriptor;

@end

#endif /* LBridge_h */
