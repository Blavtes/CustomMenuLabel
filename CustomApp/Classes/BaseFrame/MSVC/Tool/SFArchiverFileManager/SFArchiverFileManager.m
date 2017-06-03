//
//  SFArchiverFileManager.m
//  GjFax
//
//  Created by gjfax on 16/9/29.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFArchiverFileManager.h"



@implementation SFArchiverFileManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


/**
 *  获取文件 根路径
 */
+ (NSString *)rootFilePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

}

/**
 *  根据 文件名 ，获取完整文件路径
 */
+ (NSString *)fileFullPath:(NSString *)fileName
{
    NSString *path = [self rootFilePath];
    //  文件名称采用MD5保证名称正常
    fileName = [fileName MD5Sum];
    NSString *fileFullPath = [path stringByAppendingString:FMT_STR(@"/%@.archiver", fileName)];
    return fileFullPath;
}

/**
 *  根据 文件名 缓存数据到本地
 */
+ (void)saveDataWithFileName:(NSString *)fileName dataSource:(id)dataSource
{
    if (!fileName || [fileName isNullStr]) {
        DLog(@"fileName is nil");
        
    } else if (!dataSource || ![dataSource isKindOfClass:[NSObject class]]) {
        DLog(@"dataSource is illegal");
        
    } else {
        //  保存数据到文件
        NSString *filePath = [[self class] fileFullPath:fileName];
        BOOL success = [NSKeyedArchiver archiveRootObject:dataSource toFile:filePath];
        if (!success) {
            DLog(@"保存缓存到文件 失败");
        }
    }

}


/**
 *  根据 文件名 获取数据
 *  @return data
 */
+ (id)fetchDataWithFileName:(NSString *)fileName
{
    if (!fileName || [fileName isNullStr]) {
        DLog(@"fileName is nil");
        return nil;
        
    } else {
        NSString *filePath = [self fileFullPath:fileName];

        id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//        DLog(@"缓存data = %@", obj);

        return obj;
    }
    return @"";
}


#pragma mark - 删除归档文件

/**
 *  根据 文件名 删除文件
 *  @return
 */
+ (BOOL)deleteArchiverFileWithfileName:(NSString *)fileName
{
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *filePath = [self fileFullPath:fileName];
    
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        [defaultManager removeItemAtPath:filePath error:nil];
        DLog(@"删除文件 成功，path= %@", filePath);
        return YES;

    } else {
        DLog(@"删除文件 失败，path= %@", filePath);

        return NO;
    }
}

@end
