//
//  UpdateTool.h
//  HX_GJS
//
//  Created by litao on 15/9/18.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 更新工具类
/**
 *  更新工具类 - 专门跟新相关信息 - 单例
 */
@interface UpdateTool : NSObject
/**
 *  单例对象
 *
 *  @return
 */
+ (instancetype)sharedInstance;

#pragma mark - 方法
/**
 *  更新信息
 */
- (void)setUpdateDescMsg:(NSString *)msg;

- (NSString *)getUpdateDescMsg;

/**
 *  获取是否需要更新
 */
- (BOOL)getIsUpdate;

/**
 *  获取是否需要强制
 */
- (BOOL)getIsForce;

/**
 *  检查app-ios版本是否需要升级
 */
- (void)reqUpdateInfo;
@end