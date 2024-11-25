//
//  My_LAppDefine.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//

#ifndef My_LAppDefine_h
#define My_LAppDefine_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "CubismFramework.hpp"
#endif

NS_ASSUME_NONNULL_BEGIN
/**
 * @brief Sample App constants wrapper for Swift bridging
 */
@interface MyLAppDefine : NSObject

// View scale constants
@property (class, nonatomic, readonly) float viewScale;
@property (class, nonatomic, readonly) float viewMaxScale;
@property (class, nonatomic, readonly) float viewMinScale;

// Logical view coordinates
@property (class, nonatomic, readonly) float viewLogicalLeft;
@property (class, nonatomic, readonly) float viewLogicalRight;
@property (class, nonatomic, readonly) float viewLogicalBottom;
@property (class, nonatomic, readonly) float viewLogicalTop;

// Maximum logical view coordinates
@property (class, nonatomic, readonly) float viewLogicalMaxLeft;
@property (class, nonatomic, readonly) float viewLogicalMaxRight;
@property (class, nonatomic, readonly) float viewLogicalMaxBottom;
@property (class, nonatomic, readonly) float viewLogicalMaxTop;

// Resource paths
@property (class, nonatomic, readonly) NSString *resourcesPath;
@property (class, nonatomic, readonly) NSString *backImageName;
@property (class, nonatomic, readonly) NSString *gearImageName;
@property (class, nonatomic, readonly) NSString *powerImageName;

// Motion group definitions
@property (class, nonatomic, readonly) NSString *motionGroupIdle;
@property (class, nonatomic, readonly) NSString *motionGroupTapBody;

// Hit area definitions
@property (class, nonatomic, readonly) NSString *hitAreaNameHead;
@property (class, nonatomic, readonly) NSString *hitAreaNameBody;

// Motion priority constants
@property (class, nonatomic, readonly) NSInteger priorityNone;
@property (class, nonatomic, readonly) NSInteger priorityIdle;
@property (class, nonatomic, readonly) NSInteger priorityNormal;
@property (class, nonatomic, readonly) NSInteger priorityForce;

// Debug and validation flags
@property (class, nonatomic, readonly) BOOL mocConsistencyValidationEnable;
@property (class, nonatomic, readonly) BOOL debugLogEnable;
@property (class, nonatomic, readonly) BOOL debugTouchLogEnable;

// Logging level
@property (class, nonatomic, readonly) NSInteger cubismLoggingLevel;

@end

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
// Original C++ namespace definitions for C++ code
namespace LAppDefine {

    using namespace Csm;

    extern const csmFloat32 ViewScale;              ///< 拡大縮小率
    extern const csmFloat32 ViewMaxScale;           ///< 拡大縮小率の最大値
    extern const csmFloat32 ViewMinScale;           ///< 拡大縮小率の最小値

    extern const csmFloat32 ViewLogicalLeft;        ///< 論理的なビュー座標系の左端の値
    extern const csmFloat32 ViewLogicalRight;       ///< 論理的なビュー座標系の右端の値
    extern const csmFloat32 ViewLogicalBottom;      ///< 論理的なビュー座標系の下端の値
    extern const csmFloat32 ViewLogicalTop;         ///< 論理的なビュー座標系の上端の値

    extern const csmFloat32 ViewLogicalMaxLeft;     ///< 論理的なビュー座標系の左端の最大値
    extern const csmFloat32 ViewLogicalMaxRight;    ///< 論理的なビュー座標系の右端の最大値
    extern const csmFloat32 ViewLogicalMaxBottom;   ///< 論理的なビュー座標系の下端の最大値
    extern const csmFloat32 ViewLogicalMaxTop;      ///< 論理的なビュー座標系の上端の最大値

    extern const csmChar* ResourcesPath;            ///< 素材パス
    extern const csmChar* BackImageName;         ///< 背景画像ファイル
    extern const csmChar* GearImageName;         ///< 歯車画像ファイル
    extern const csmChar* PowerImageName;        ///< 終了ボタン画像ファイル

    // モデル定義--------------------------------------------
    // 外部定義ファイル(json)と合わせる
    extern const csmChar* MotionGroupIdle;          ///< アイドリング時に再生するモーションのリスト
    extern const csmChar* MotionGroupTapBody;       ///< 体をタップした時に再生するモーションのリスト

    // 外部定義ファイル(json)と合わせる
    extern const csmChar* HitAreaNameHead;          ///< 当たり判定の[Head]タグ
    extern const csmChar* HitAreaNameBody;          ///< 当たり判定の[Body]タグ

    // モーションの優先度定数
    extern const csmInt32 PriorityNone;             ///< モーションの優先度定数: 0
    extern const csmInt32 PriorityIdle;             ///< モーションの優先度定数: 1
    extern const csmInt32 PriorityNormal;           ///< モーションの優先度定数: 2
    extern const csmInt32 PriorityForce;            ///< モーションの優先度定数: 3

    extern const csmBool MocConsistencyValidationEnable; ///< MOC3の整合性検証機能の有効・無効

    // デバッグ用ログの表示
    extern const csmBool DebugLogEnable;            ///< デバッグ用ログ表示の有効・無効
    extern const csmBool DebugTouchLogEnable;       ///< タッチ処理のデバッグ用ログ表示の有効・無効

    // Frameworkから出力するログのレベル設定
    extern const CubismFramework::Option::LogLevel CubismLoggingLevel;
}
#endif

#endif /* My_LAppDefine_h */
