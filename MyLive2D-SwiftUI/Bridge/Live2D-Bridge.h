//
//  Live2D-Bridge.h
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/18.
//

#ifndef Live2D_Bridge_h
#define Live2D_Bridge_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
//#import <SceneKit/SceneKit.h>
#import <simd/simd.h>
#import <Metal/Metal.h>


@interface Live2DCubism : NSObject
+ (void)initL2D;
+ (void)dispose;
+ (NSString *)live2DVersion;
@end

@interface Live2DModelMetal : NSObject

- (instancetype)initWithJsonPath:(NSString *)jsonPath;

- (int)getNumberOfTextures;
- (NSString *)getFileNameOfTexture:(int)number;
- (void)setTexture:(unsigned int)textureNo to:(id<MTLTexture>)texture;
- (void)setPremultipliedAlpha:(bool)enable;

- (float)getCanvasWidth;
- (void)setMatrix:(matrix_float4x4)matrix;
- (void)setParam:(NSString *)paramId value:(Float32)value;
- (void)setPartsOpacity:(NSString *)paramId opacity:(Float32)value;

- (void)updatePhysics:(Float32)delta;
- (void)update;
- (void)draw;

@property (nonatomic, copy) NSString *modelPath;
@property (nonatomic, strong) NSArray<NSString *> *texturePaths;
@property (nonatomic, strong) NSArray<NSString *> *parts;

@end

#endif /* Live2D_Bridge_h */
