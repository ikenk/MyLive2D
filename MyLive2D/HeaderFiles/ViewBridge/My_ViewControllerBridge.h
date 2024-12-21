//
//  My_ViewController.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/24.
//

#ifndef My_ViewController_h
#define My_ViewController_h

#import <UIKit/UIKit.h>
#import "Metal/Metal.h"
#import "MetalView.h"



@interface My_ViewControllerBridge : NSObject
@property (strong, nonatomic) UIViewController<MetalViewDelegate>* viewController;

@property (nonatomic) bool anotherTarget;
@property (nonatomic) float spriteColorR;
@property (nonatomic) float spriteColorG;
@property (nonatomic) float spriteColorB;
@property (nonatomic) float spriteColorA;
@property (nonatomic) float clearColorR;
@property (nonatomic) float clearColorG;
@property (nonatomic) float clearColorB;
@property (nonatomic) float clearColorA;
@property (strong, nonatomic) id<MTLCommandQueue> commandQueue;
@property (strong, nonatomic) id<MTLTexture> depthTexture;


+ (instancetype)shared;
- (void)setToViewController:(UIViewController <MetalViewDelegate>*)viewController NS_SWIFT_NAME(setToViewController(_:));
- (void)setToCommandQueue:(id<MTLCommandQueue>)commandQueue NS_SWIFT_NAME(setToCommandQueue(_:));
- (void)setToDepthTexture:(id<MTLTexture>)depthTexture;

- (void)loadView;

- (void)viewDidLoad;

- (void)drawableResize:(CGSize)size;

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer NS_SWIFT_NAME(renderToMetalLayer(_:));

- (void)touchesBeganAt:(CGFloat)x Y:(CGFloat)y NS_SWIFT_NAME(touchesBeganAt(x:y:));

- (void)touchesMovedAt:(CGFloat)x Y:(CGFloat)y NS_SWIFT_NAME(touchesMovedAt(x:y:));

- (void)touchesEndedAt:(CGFloat)x Y:(CGFloat)y NS_SWIFT_NAME(touchesEndedAt(x:y:));

- (void)setBackgroundImage;

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
- (void)initializeSprite;

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

#endif /* My_ViewController_h */
