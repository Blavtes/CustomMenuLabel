//
//  RMTFileUtils.m
//  RemoteControl
//
//  Created by xbmac on 9/1/15.
//  Copyright (c) 2015 runmit.com. All rights reserved.
//

#import "RMTFileUtils.h"
#import <sys/xattr.h>

#define GAME_CONFIGS_PREFIX @"./DB"
#define DATABASE_PREFIX @""

@implementation RMTFileUtils

+ (void)createGameConfigDirectoryIfNeeded {
    NSString *gameConfigsPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:GAME_CONFIGS_PREFIX];
    if ([self dirIsExist:gameConfigsPath]) {
        return ;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:gameConfigsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:gameConfigsPath]];
}

+ (void)createDatabaseDirectoryIfNeeded {
    NSString *databasePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:DATABASE_PREFIX];
    if ([self dirIsExist:databasePath]) {
        return ;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:databasePath withIntermediateDirectories:YES attributes:nil error:nil];
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:databasePath]];
}

+ (BOOL)fileISExist:(NSString *)fileString {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileString];
}

+ (BOOL)dirIsExist:(NSString *)dirString {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:dirString isDirectory:&isDir];
    if ((isDirExist && isDir)) {
        return TRUE;
    }
    return FALSE;
}

+ (BOOL)createItem:(NSString *)dirString {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)deleteItem:(NSString *)dirString {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:dirString error:nil];
}

+ (NSString*)getGameConfigsDirectory {
    return [PATH_OF_DOCUMENT stringByAppendingPathComponent:GAME_CONFIGS_PREFIX];
}

+ (NSString*)gameConfigsFilePathFromPackage:(NSString*)package {
    NSString* gameConfigsDir = [self getGameConfigsDirectory];
    NSString* configsFileFromPackage = [gameConfigsDir stringByAppendingPathComponent:package];
    if ([self dirIsExist:configsFileFromPackage]) {
        return configsFileFromPackage;
    }
    
    //If created from package file
    [self createItem:configsFileFromPackage];
    
    return configsFileFromPackage;
}

+ (NSString*)getDatabaseDirectory {
    return [PATH_OF_DOCUMENT stringByAppendingPathComponent:DATABASE_PREFIX];
}

//增加使用云备份属性
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL {
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
