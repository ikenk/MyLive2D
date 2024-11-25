//
//  My_AppDelegateBridge.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/24.
//

#import "My_AppDelegateBridge.h"

#import <Foundation/Foundation.h>

@interface My_AppDelegateBridge()

@end

@implementation My_AppDelegateBridge

+ (instancetype)shared {
    static My_AppDelegateBridge *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[My_AppDelegateBridge alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appDelegate = nil;
        _viewController = nil;
        _textureManager = nil;
    }
    return self;
}

- (void)setToAppDelegate:(UIResponder<UIApplicationDelegate> *)appDelegate{
    self.appDelegate = appDelegate;
}

//- (void)setToViewController:(UIViewController<MetalViewDelegate> *)viewController{
//    self.viewController = viewController;
//}
- (void)setToViewController:(My_ViewControllerBridge *)viewController{
    self.viewController = viewController;
}

- (void)setToTextureManager:(My_LAppTextureManager*)textureManager{
    self.textureManager = textureManager;
}

@end
