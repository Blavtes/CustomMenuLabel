//
//  SFArchiverRequestService.h
//  GjFax
//
//  Created by gjfax on 16/9/28.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestService.h"
#import "SFArchiverFileManager.h"   // 归档类


/**
 *  归档文件block，若设置 且 本地存在数据，则返回缓存数据
 */
typedef void (^SFArchiverDataBlock) (id archiverData);



@interface SFArchiverRequestService : SFRequestService


@property (nonatomic, copy) SFArchiverDataBlock         archiverDataBlock;

#pragma mark - 需重写

/**
 *  归档文件名称，默认 apiUrl为fileName
 *  若该接口需保存多个数据  规则请遵守 【apiUrl + 特定标志】
 */
- (NSString *)archiverFileName;

/**
 *  return 当前请求的 结果数据， 用于 归档保存
 *  若 需要缓存，必须重写
 */
- (id)archiverDataObject;

#pragma mark - 缓存开关 并 返回
/**
 *  设置 归档文件block，若设置 且 本地存在数据，则返回dataSource
 *  同为是否 开启缓存的开关
 */
- (void)setArchiverDataBlock:(SFArchiverDataBlock)archiverDataBlock;


#pragma mark - 如果不必要，不需要理会
/**
 *  保存 缓存数据， 数据从 archiverDataObject中取
 *
 *  @return String
 */
- (void)saveArchiverData;

/**
 *  获取 缓存数据
 *
 *  @return id
 */
- (id)fetchArchiverData;

@end
