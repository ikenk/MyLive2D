//
//  My_LAppTextureManager.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/24.
//

#ifndef My_LAppTextureManager_h
#define My_LAppTextureManager_h

// Apple
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

#ifdef __cplusplus
#import <string>
#import <MetalKit/MetalKit.h>
#import <Type/csmVector.hpp>
#endif



// MARK: Objective-C Interface
NS_ASSUME_NONNULL_BEGIN
/**
 * @brief Texture info wrapper for Swift bridging
 */
@interface My_LAppTextureInfo : NSObject

@property (nonatomic, strong) id<MTLTexture> textureId;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, copy) NSString *fileName;

@end

/**
 * @brief Texture manager with Swift compatibility
 */
@interface My_LAppTextureManager : NSObject

/**
 * @brief Create texture from PNG file
 *
 * @param fileName File path of the image to load
 * @return Texture info. Returns nil if loading fails
 */
- (nullable My_LAppTextureInfo *)createTextureFromPngFile:(NSString *)fileName;

/**
 * @brief Release all textures
 */
- (void)releaseTextures;

/**
 * @brief Release texture with specific ID
 *
 * @param textureId ID of texture to release
 */
- (void)releaseTextureWithId:(id<MTLTexture>)textureId;

/**
 * @brief Release texture with specific file name
 *
 * @param fileName File name of texture to release
 */
- (void)releaseTextureByName:(NSString *)fileName;

/**
 * @brief Premultiply color values
 *
 * @param red Red value
 * @param green Green value
 * @param blue Blue value
 * @param alpha Alpha value
 * @return Premultiplied color value
 */
- (unsigned int)premultiplyWithRed:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue alpha:(unsigned char)alpha;

@end
NS_ASSUME_NONNULL_END



// MARK: C++ Class
#ifdef __cplusplus
@interface LAppTextureManager : NSObject

/**
 * @brief 画像情報構造体
 */
typedef struct
{
    id <MTLTexture> id;              ///< テクスチャID
    int width;              ///< 横幅
    int height;             ///< 高さ
    std::string fileName;       ///< ファイル名
}TextureInfo;

/**
 * @brief 初期化
 */
- (id)init;

/**
 * @brief 解放処理
 *
 */
- (void)dealloc;


/**
 * @brief プリマルチプライ処理
 *
 * @param[in] red  画像のRed値
 * @param[in] green  画像のGreen値
 * @param[in] blue  画像のBlue値
 * @param[in] alpha  画像のAlpha値
 *
 * @return プリマルチプライ処理後のカラー値
 */
- (unsigned int)premultiply:(unsigned char)red Green:(unsigned char)green Blue:(unsigned char)blue Alpha:(unsigned char) alpha;


/**
 * @brief 画像読み込み
 *
 * @param[in] fileName  読み込む画像ファイルパス名
 * @return 画像情報。読み込み失敗時はNULLを返す
 */
- (TextureInfo*)createTextureFromPngFile:(std::string)fileName;

/**
 * @brief 画像の解放
 *
 * 配列に存在する画像全てを解放する
 */
- (void)releaseTextures;

/**
 * @brief 画像の解放
 *
 * 指定したテクスチャIDの画像を解放する
 * @param[in] textureId  解放するテクスチャID
 **/
- (void)releaseTextureWithId:(id <MTLTexture>)textureId;

/**
 * @brief 画像の解放
 *
 * 指定した名前の画像を解放する
 * @param[in] fileName  解放する画像ファイルパス名
 **/
- (void)releaseTextureByName:(std::string)fileName;

@end
#endif

#endif /* My_LAppTextureManager_h */
