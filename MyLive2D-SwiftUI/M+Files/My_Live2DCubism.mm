//
//  My_Live2DCubism.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/25.
//

#import "My_Live2DCubism.h"

// Cpp
#import <math.h>
#import <string>

// Cubism
#import "CubismFramework.hpp"
#import <Math/CubismMatrix44.hpp>
#import <Math/CubismViewMatrix.hpp>

// Custom
#import "My_LAppAllocator.h"
#import "My_LAppPal.h"
#import "My_LAppDefine.h"
#import "My_LAppLive2DManager.h"
#import "My_LAppTextureManager.h"

using namespace Live2D::Cubism::Framework;
using namespace Live2D::Cubism::Core;


// MARK: Objective-C Bridge Implementation
// Objective-C class implementation
@implementation Live2DCubism
static Csm::CubismFramework::Option _cubismOption;
static LAppAllocator _cubismAllocator;

+ (void)initializeCubism {
    _cubismOption.LogFunction = LAppPal::PrintMessageLn;
    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;

    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);

    Csm::CubismFramework::Initialize();

    [LAppLive2DManager getInstance];

    Csm::CubismMatrix44 projection;

    LAppPal::UpdateTime();
}

+ (void)deinitializeCubism {
    [LAppLive2DManager releaseInstance];

    Csm::CubismFramework::Dispose();

//    exit(0);
}

+ (NSString *)live2DVersion {
    unsigned int version = csmGetVersion();
    unsigned int major = (version >> 24) & 0xff;
    unsigned int minor = (version >> 16) & 0xff;
    unsigned int patch = version & 0xffff;

    return [NSString stringWithFormat:@"v%1$d.%2$d.%3$d", major, minor, patch];
}
@end
