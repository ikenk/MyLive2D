//
//  My_LAppPal.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/20.
//

#import "My_LAppPal.h"

#import <Foundation/Foundation.h>

#import <CubismFramework.hpp>
#import <string>

#import "My_LAppDefine.h"
#import <fstream>
#import <iostream>
#import <stdarg.h>
#import <stdio.h>
#import <stdlib.h>
#import <sys/stat.h>

// OC
using namespace Csm;
// C++
using namespace std;
using namespace LAppDefine;

// MARK: Objective-C Bridge Implementation
// Objective-C class implementation

@implementation MyLAppPal {
}

+ (nullable Csm::csmByte *)loadFileAsBytes:(NSString *)filePath outSize:(uint32_t *)outSize {
    return LAppPal::LoadFileAsBytes(std::string([filePath UTF8String]), outSize);
}

+ (void)releaseBytes:(unsigned char *)byteData {
    //    if (byteData != NULL) {
    //        free(byteData);
    //    }
    LAppPal::ReleaseBytes(byteData);
}

+ (double)getDeltaTime {
    //    return s_deltaTime;
    return LAppPal::GetDeltaTime();
}

+ (void)updateTime {
    LAppPal::UpdateTime();
}

+ (void)printLogLn:(const char *)format, ... {
    LAppPal::PrintLogLn(format);
}

+ (void)printMessageLn:(const char *)message {
    LAppPal::PrintMessageLn(message);
}

@end

#pragma mark C++ Implementation
using namespace std;

double LAppPal::s_currentFrame = 0.0;
double LAppPal::s_lastFrame = 0.0;
double LAppPal::s_deltaTime = 0.0;

csmByte *LAppPal::LoadFileAsBytes(const string filePath, csmSizeInt *outSize) {
    int path_i = static_cast<int>(filePath.find_last_of("/") + 1);
    int ext_i = static_cast<int>(filePath.find_last_of("."));
    std::string pathname = filePath.substr(0, path_i);
    std::string extname = filePath.substr(ext_i, filePath.size() - ext_i);
    std::string filename = filePath.substr(path_i, ext_i - path_i);
    NSString *castFilePath = [[NSBundle mainBundle]
        pathForResource:[NSString stringWithUTF8String:filename.c_str()]
                 ofType:[NSString stringWithUTF8String:extname.c_str()]
            inDirectory:[NSString stringWithUTF8String:pathname.c_str()]];

    NSData *data = [NSData dataWithContentsOfFile:castFilePath];

    if (data == nil) {
        PrintLogLn("File load failed : %s", filePath.c_str());
        return NULL;
    } else if (data.length == 0) {
        PrintLogLn("File is loaded but file size is zero : %s", filePath.c_str());
        return NULL;
    }

    NSUInteger len = [data length];
    Byte *byteData = (Byte *)malloc(len);
    memcpy(byteData, [data bytes], len);

    *outSize = static_cast<Csm::csmSizeInt>(len);
    return static_cast<Csm::csmByte *>(byteData);
}

void LAppPal::ReleaseBytes(csmByte *byteData) {
    free(byteData);
}

void LAppPal::UpdateTime() {
    NSDate *now = [NSDate date];
    double unixtime = [now timeIntervalSince1970];
    s_currentFrame = unixtime;
    s_deltaTime = s_currentFrame - s_lastFrame;
    s_lastFrame = s_currentFrame;
}

void LAppPal::PrintLogLn(const csmChar *format, ...) {
    va_list args;
    Csm::csmChar buf[256];
    va_start(args, format);
    vsnprintf(buf, sizeof(buf), format, args); // 標準出力でレンダリング;
    NSLog(@"%@", [NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
    va_end(args);
}

void LAppPal::PrintMessageLn(const csmChar *message) {
    PrintLogLn("%s", message);
}
