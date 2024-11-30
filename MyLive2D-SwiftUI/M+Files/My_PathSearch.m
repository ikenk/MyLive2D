//
//  My_PathSearch.m
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/30.
//

#import "My_PathSearch.h"

// Apple
#import <Foundation/Foundation.h>

// Custom
#import "My_LAppDefine.h"

@implementation My_PathSearch

+ (NSURL *)searchResourcesFileURL {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* fileURL = [[fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil] URLByAppendingPathComponent:MyLAppDefine.filesAppResourcesPath isDirectory:true];
    
    return  fileURL;
}

+ (NSString *)searchResourcesFilePath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSURL* fileURL = [[fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil] URLByAppendingPathComponent:MyLAppDefine.filesAppResourcesPath isDirectory:true];
    NSString* filePath = [[fileURL path] stringByAppendingString:@"/"];
    
    NSLog(@"[MyLog]My_PathSearch filePath: %@",filePath);
    
    return  filePath;
}

@end
