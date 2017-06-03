//
//  RMTFileUtils.h
//  RemoteControl
//
//  Created by xbmac on 9/1/15.
//  Copyright (c) 2015 runmit.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PATH_OF_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface RMTFileUtils : NSObject

+ (void)createGameConfigDirectoryIfNeeded;

+ (void)createDatabaseDirectoryIfNeeded;

+ (BOOL)fileISExist:(NSString *)fileString;

+ (BOOL)dirIsExist:(NSString *)dirString;

+ (BOOL)createItem:(NSString *)dirString;

+ (BOOL)deleteItem:(NSString *)dirString;

+ (NSString*)getGameConfigsDirectory;

+ (NSString*)getDatabaseDirectory;

+ (NSString*)gameConfigsFilePathFromPackage:(NSString*)package;

@end
