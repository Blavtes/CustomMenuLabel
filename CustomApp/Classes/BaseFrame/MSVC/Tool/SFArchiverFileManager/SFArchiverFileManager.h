//
//  SFArchiverFileManager.h
//  GjFax
//
//  Created by gjfax on 16/9/29.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFArchiverFileManager : NSObject

/**
 *  根据 文件名 ，获取完整文件路径
 *  完整路径在外层基本不需要获取，只需要使用 文件名 fileName来保存、获取即可
 *  fileName规则请遵守 【apiUrl + 特定标志】
 */
+ (NSString *)fileFullPath:(NSString *)fileName;

#pragma mark - 保存
/**
 *  根据 文件名 缓存数据到本地
 *  完整路径在外层基本不需要获取，只需要使用 文件名 fileName来保存、获取即可
 *  fileName规则请遵守 【apiUrl + 特定标志】
 */
+ (void)saveDataWithFileName:(NSString *)fileName dataSource:(id)dataSource;

#pragma mark - 获取
/**
 *  根据 文件名 获取数据
 *  完整路径在外层基本不需要获取，只需要使用 文件名 fileName来保存、获取即可
 *  fileName规则请遵守 【apiUrl + 特定标志】
 *  @return data
 */
+ (id)fetchDataWithFileName:(NSString *)fileName;

#pragma mark - 删除归档文件
/**
 *  根据 文件名 删除文件
 *  fileName规则请遵守 【apiUrl + 特定标志】
 *  @return
 */
+ (BOOL)deleteArchiverFileWithfileName:(NSString *)fileName;
@end
