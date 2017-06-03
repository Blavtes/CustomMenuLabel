//
//  SFArchiverRequestService.m
//  GjFax
//
//  Created by gjfax on 16/9/28.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFArchiverRequestService.h"

@implementation SFArchiverRequestService


- (void)setArchiverDataBlock:(SFArchiverDataBlock)archiverDataBlock
{
    _archiverDataBlock = archiverDataBlock;
}


/**
 *  保存 缓存数据， 数据从 archiverDataObject中取
 *
 *  @return String
 */
- (void)saveArchiverData
{
    if (_archiverDataBlock) {

        [SFArchiverFileManager saveDataWithFileName:[self archiverFileName]
                                         dataSource:[self archiverDataObject]];

        
    } else {
        DLog(@"未设置archiverDataBlock，不进行保存操作");
    }
}

/**
 *  获取 缓存数据
 *
 *  @return id
 */
- (id)fetchArchiverData
{
    if (_archiverDataBlock) {
        
        return [SFArchiverFileManager fetchDataWithFileName:[self archiverFileName]];

    } else {
        return nil;
    }
}

/**
 *  发起 请求
 */
- (void)startRequest
{
    //  请求前 先拿缓存
    if (_archiverDataBlock) {

        id dataObject = [self fetchArchiverData];
        if (dataObject && [dataObject isKindOfClass:[NSObject class]]) {
            
            _archiverDataBlock(dataObject);
        }
//        DLog(@"缓存数据 ＝ %@" , dataObject);

    }

    [super startRequest];
}

/**
 *  请求 成功 且 数据合法
 *
 *  @return id
 */
- (void)succeed:(id)response
{
    //  缓存数据
    [self saveArchiverData];
    
    [super succeed:response];
    
}

/**
 *  return 当前请求的 结果数据， 用于 归档保存 saveArchiverData
 */
- (id)archiverDataObject
{
    return nil;
}

/**
 *  归档文件名称，默认 apiUrl为fileName
 *  若该接口需保存多个数据  规则请遵守 【apiUrl + 特定标志】
 */
- (NSString *)archiverFileName
{
    return [self apiUrl];
}

@end
