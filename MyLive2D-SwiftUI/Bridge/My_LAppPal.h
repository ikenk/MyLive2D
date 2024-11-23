//
//  MyLAppPal.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//

#ifndef MyLAppPal_h
#define MyLAppPal_h

#ifdef __cplusplus
#import <string>
#import <CubismFramework.hpp>
#endif

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * @brief Platform abstraction layer for Cubism functionality that bridges to Swift
 */
@interface MyLAppPal : NSObject

/**
 * @brief Load file as bytes data
 *
 * @param filePath Path to the target file
 * @param outSize Pointer to store the file size
 * @return Byte data as csmByte array, NULL if failed
 */
+ (nullable unsigned char *)loadFileAsBytes:(NSString *)filePath outSize:(uint32_t *)outSize;

/**
 * @brief Release the byte data
 *
 * @param byteData The byte data to release
 */
+ (void)releaseBytes:(unsigned char *)byteData;

/**
 * @brief Get delta time (difference from previous frame)
 *
 * @return Delta time in milliseconds
 */
+ (double)getDeltaTime;

/**
 * @brief Update the time
 */
+ (void)updateTime;

/**
 * @brief Print log with format and arguments
 *
 * @param format Format string
 * @param ... Variable arguments
 */
+ (void)printLogLn:(const char*)format, ...;

/**
 * @brief Print message with newline
 *
 * @param message The message to print
 */
+ (void)printMessageLn:(const char*)message;

@end
NS_ASSUME_NONNULL_END

#ifdef __cplusplus
/**
 * @brief プラットフォーム依存機能を抽象化する Cubism Platform Abstraction Layer.
 *
 * ファイル読み込みや時刻取得等のプラットフォームに依存する関数をまとめる
 *
 */
class LAppPal
{
public:
    /**
     * @brief ファイルをバイトデータとして読み込む
     *
     * ファイルをバイトデータとして読み込む
     *
     * @param[in]   filePath    読み込み対象ファイルのパス
     * @param[out]  outSize     ファイルサイズ
     * @return                  バイトデータ
     */
    static Csm::csmByte* LoadFileAsBytes(const std::string filePath, Csm::csmSizeInt* outSize);


    /**
     * @brief バイトデータを解放する
     *
     * バイトデータを解放する
     *
     * @param[in]   byteData    解放したいバイトデータ
     */
    static void ReleaseBytes(Csm::csmByte* byteData);

    /**
     * @biref   デルタ時間（前回フレームとの差分）を取得する
     *
     * @return  デルタ時間[ms]
     *
     */
    static double GetDeltaTime() {return s_deltaTime;}

    /**
     * @brief 時間を更新する。
     */
    static void UpdateTime();

    /**
     * @brief ログを出力し最後に改行する
     *
     * ログを出力し最後に改行する
     *
     * @param[in]   format  書式付文字列
     * @param[in]   ...     (可変長引数)文字列
     *
     */
    static void PrintLogLn(const Csm::csmChar* format, ...);

    /**
     * @brief メッセージを出力し最後に改行する
     *
     * メッセージを出力し最後に改行する
     *
     * @param[in]   message  文字列
     *
     */
    static void PrintMessageLn(const Csm::csmChar* message);

private:
    static double s_currentFrame;
    static double s_lastFrame;
    static double s_deltaTime;
};
#endif

#endif /* MyLAppPal_h */
