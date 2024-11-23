//
//  My_LAppDefine.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//

#import "My_LAppDefine.h"

#import <Foundation/Foundation.h>

#import <CubismFramework.hpp>

// MARK: Objective-C Bridge Implementation
// Objective-C class implementation
@implementation MyLAppDefine

#pragma mark - View Scale Properties

+ (float)viewScale {
    return LAppDefine::ViewScale;
}

+ (float)viewMaxScale {
    return LAppDefine::ViewMaxScale;
}

+ (float)viewMinScale {
    return LAppDefine::ViewMinScale;
}

#pragma mark - Logical View Coordinates

+ (float)viewLogicalLeft {
    return LAppDefine::ViewLogicalLeft;
}

+ (float)viewLogicalRight {
    return LAppDefine::ViewLogicalRight;
}

+ (float)viewLogicalBottom {
    return LAppDefine::ViewLogicalBottom;
}

+ (float)viewLogicalTop {
    return LAppDefine::ViewLogicalTop;
}

#pragma mark - Maximum Logical View Coordinates

+ (float)viewLogicalMaxLeft {
    return LAppDefine::ViewLogicalMaxLeft;
}

+ (float)viewLogicalMaxRight {
    return LAppDefine::ViewLogicalMaxRight;
}

+ (float)viewLogicalMaxBottom {
    return LAppDefine::ViewLogicalMaxBottom;
}

+ (float)viewLogicalMaxTop {
    return LAppDefine::ViewLogicalMaxTop;
}

#pragma mark - Resource Paths

+ (NSString *)resourcesPath {
    return @(LAppDefine::ResourcesPath);
}

+ (NSString *)backImageName {
    return @(LAppDefine::BackImageName);
}

+ (NSString *)gearImageName {
    return @(LAppDefine::GearImageName);
}

+ (NSString *)powerImageName {
    return @(LAppDefine::PowerImageName);
}

#pragma mark - Motion Groups

+ (NSString *)motionGroupIdle {
    return @(LAppDefine::MotionGroupIdle);
}

+ (NSString *)motionGroupTapBody {
    return @(LAppDefine::MotionGroupTapBody);
}

#pragma mark - Hit Areas

+ (NSString *)hitAreaNameHead {
    return @(LAppDefine::HitAreaNameHead);
}

+ (NSString *)hitAreaNameBody {
    return @(LAppDefine::HitAreaNameBody);
}

#pragma mark - Motion Priorities

+ (NSInteger)priorityNone {
    return LAppDefine::PriorityNone;
}

+ (NSInteger)priorityIdle {
    return LAppDefine::PriorityIdle;
}

+ (NSInteger)priorityNormal {
    return LAppDefine::PriorityNormal;
}

+ (NSInteger)priorityForce {
    return LAppDefine::PriorityForce;
}

#pragma mark - Debug and Validation Flags

+ (BOOL)mocConsistencyValidationEnable {
    return LAppDefine::MocConsistencyValidationEnable;
}

+ (BOOL)debugLogEnable {
    return LAppDefine::DebugLogEnable;
}

+ (BOOL)debugTouchLogEnable {
    return LAppDefine::DebugTouchLogEnable;
}

#pragma mark - Logging Level

+ (NSInteger)cubismLoggingLevel {
    return static_cast<NSInteger>(LAppDefine::CubismLoggingLevel);
}
@end



#pragma mark C++ Implementation
namespace LAppDefine {

    using namespace Csm;

    // 画面
    const csmFloat32 ViewScale = 1.0f;
    const csmFloat32 ViewMaxScale = 2.0f;
    const csmFloat32 ViewMinScale = 0.8f;

    const csmFloat32 ViewLogicalLeft = -1.0f;
    const csmFloat32 ViewLogicalRight = 1.0f;
    const csmFloat32 ViewLogicalBottom = -1.0f;
    const csmFloat32 ViewLogicalTop = 1.0f;

    const csmFloat32 ViewLogicalMaxLeft = -2.0f;
    const csmFloat32 ViewLogicalMaxRight = 2.0f;
    const csmFloat32 ViewLogicalMaxBottom = -2.0f;
    const csmFloat32 ViewLogicalMaxTop = 2.0f;

    // 相対パス
#if !TARGET_OS_MACCATALYST
    const csmChar* ResourcesPath = "Res/Resources/";
#else
    const csmChar* ResourcesPath = "Resources/";
#endif

    // モデルの後ろにある背景の画像ファイル
    const csmChar* BackImageName = "back_class_normal.png";
    // 歯車
    const csmChar* GearImageName = "icon_gear.png";
    // 終了ボタン
    const csmChar* PowerImageName = "close.png";

    // モデル定義------------------------------------------
    // 外部定義ファイル(json)と合わせる
    const csmChar* MotionGroupIdle = "Idle"; // アイドリング
    const csmChar* MotionGroupTapBody = "TapBody"; // 体をタップしたとき

    // 外部定義ファイル(json)と合わせる
    const csmChar* HitAreaNameHead = "Head";
    const csmChar* HitAreaNameBody = "Body";

    // モーションの優先度定数
    const csmInt32 PriorityNone = 0;
    const csmInt32 PriorityIdle = 1;
    const csmInt32 PriorityNormal = 2;
    const csmInt32 PriorityForce = 3;

    // MOC3の整合性検証オプション
    const csmBool MocConsistencyValidationEnable = true;

    // デバッグ用ログの表示オプション
    const csmBool DebugLogEnable = true;
    const csmBool DebugTouchLogEnable = false;

    // Frameworkから出力するログのレベル設定
    const CubismFramework::Option::LogLevel CubismLoggingLevel = CubismFramework::Option::LogLevel_Verbose;
}
