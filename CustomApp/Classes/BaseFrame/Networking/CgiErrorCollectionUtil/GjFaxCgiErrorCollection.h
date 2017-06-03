//
//  GjFaxCgiErrorCollection.h
//  GjFax
//
//  Created by litao on 16/9/14.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GjFaxCgiErrorModel;

/**
 *  负责接口错误数据采集上报
 */
@interface GjFaxCgiErrorCollection : NSObject

/**
 *  返回一个管理者对象
 */
+ (instancetype)manager;

/**
 *  采集一条数据
 */
- (void)collectCgiError:(GjFaxCgiErrorModel *)dataModel;
- (void)collectCgiErrorWithCgiName:(NSString *)cgiName
                           andCode:(NSString *)retCode
                           andInfo:(NSString *)retInfo;

/**
 *  返回存储的所有数据 - 不会清空原有数据
 */
//- (NSArray *)fetchSavedCgiError;

/**
 *  返回最多max条用户数据 清空原有数据 剩下的继续保存
 */
//- (NSArray *)fetchSavedCgiErrorWithMaxLength:(int)maxLength;

/**
 *  清理数据
 */
- (void)clearCgiError;

/**
 *  上传数据
 */
- (void)submitCollectionData;

@end
