//
//  GjFaxCgiErrorModel.h
//  GjFax
//
//  Created by litao on 16/9/14.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  接口错误数据模型
 */
@interface GjFaxCgiErrorModel : NSObject <NSCoding>

//  接口名称
@property (nonatomic, copy) NSString *cgiName;
//  用户id【取不到为@“”】
@property (nonatomic, copy) NSString *userId;
//  app版本号
@property (nonatomic, copy) NSString *appVersion;
//  发生时间
@property (nonatomic, copy) NSString *curTime;
//  显示页面
@property (nonatomic, copy) NSString *pageId;
//  错误码
@property (nonatomic, copy) NSString *errorCode;
//  错误信息
@property (nonatomic, copy) NSString *errorMsg;

#pragma mark - init
- (instancetype)initWithCgiName:(NSString *)cgiName
                        andCode:(NSString *)retCode
                        andInfo:(NSString *)retInfo;

+ (instancetype)modelWithCgiName:(NSString *)cgiName
                         andCode:(NSString *)retCode
                         andInfo:(NSString *)retInfo;

@end
