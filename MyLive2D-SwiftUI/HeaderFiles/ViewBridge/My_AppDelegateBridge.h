//
//  My_AppDelegateBridge.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/23.
//

#ifndef My_AppDelegateBridge_h
#define My_AppDelegateBridge_h

// Apple
#import <UIKit/UIKit.h>
#import "MetalView.h"

// Custom
#import "My_LAppTextureManager.h"
#import "My_ViewControllerBridge.h"



@interface My_AppDelegateBridge : NSObject

//@property (nonatomic, weak) UIViewController<MetalViewDelegate> *viewController;
@property (nonatomic, weak) My_ViewControllerBridge *viewController;
@property (weak, nonatomic) UIResponder<UIApplicationDelegate> *appDelegate;
//@property (nonatomic, readonly, getter=getTextureManager) LAppTextureManager *textureManager; // テクスチャマネージャー
@property (weak, nonatomic) My_LAppTextureManager* textureManager;

+ (instancetype)shared;
- (void)setToAppDelegate:(UIResponder<UIApplicationDelegate>*)appDelegate;
//- (void)setToViewController:(UIViewController<MetalViewDelegate>*)viewController NS_SWIFT_NAME(setToViewController(_:));
- (void)setToViewController:(My_ViewControllerBridge *)viewController NS_SWIFT_NAME(setToViewController(_:));
- (void)setToTextureManager:(My_LAppTextureManager*)textureManager NS_SWIFT_NAME(setToTextureManager(_:));
//- (UIWindow *)currentWindow;

@end

#endif /* My_AppDelegateBridge_h */
