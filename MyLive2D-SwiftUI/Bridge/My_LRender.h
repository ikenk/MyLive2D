//
//  My_LRender.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/21.
//

#ifndef My_LRender_h
#define My_LRender_h

#import "MetalView.h"
#import "MetalUIView.h"

@interface Live2DCubism : NSObject
+ (void)initializeCubism;
+ (void)deinitializeCubism;
+ (void)initializeTextureManager;
+ (void)deinitializeTextureManager;
+ (NSString *)live2DVersion;
@end


@interface My_ModelRender: NSObject

@property (nonatomic) bool anotherTarget;
@property (nonatomic) float spriteColorR;
@property (nonatomic) float spriteColorG;
@property (nonatomic) float spriteColorB;
@property (nonatomic) float spriteColorA;
@property (nonatomic) float clearColorR;
@property (nonatomic) float clearColorG;
@property (nonatomic) float clearColorB;
@property (nonatomic) float clearColorA;
@property (nonatomic) id<MTLCommandQueue> commandQueue;
@property (nonatomic) id<MTLTexture> depthTexture;


// 1. 声明不可用的默认初始化方法
- (instancetype)init NS_UNAVAILABLE;

// 2. 声明我们的指定初始化方法
- (instancetype)initWithViewController:(UIViewController<MetalViewDelegate> *)viewController NS_DESIGNATED_INITIALIZER;

- (void)loadView;

/**
 * @brief 解放処理
 */
- (void)dealloc;

/**
 * @brief 解放する。
 */
- (void)releaseView;

/**
 * @brief 画面リサイズ処理
 */
- (void)resizeScreen;

/**
 * @brief 画像の初期化を行う。
 */
//- (void)initializeSprite;

/**
 * @brief X座標をView座標に変換する。
 *
 * @param[in]       deviceX            デバイスX座標
 */
- (float)transformViewX:(float)deviceX;

/**
 * @brief Y座標をView座標に変換する。
 *
 * @param[in]       deviceY            デバイスY座標
 */
- (float)transformViewY:(float)deviceY;

/**
 * @brief X座標をScreen座標に変換する。
 *
 * @param[in]       deviceX            デバイスX座標
 */
- (float)transformScreenX:(float)deviceX;

/**
 * @brief Y座標をScreen座標に変換する。
 *
 * @param[in]       deviceY            デバイスY座標
 */
- (float)transformScreenY:(float)deviceY;

@end

#endif /* My_LRender_h */
