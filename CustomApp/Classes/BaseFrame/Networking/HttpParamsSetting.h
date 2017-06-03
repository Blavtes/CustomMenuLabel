//
//  HttpParamsSetting.h
//  YiYunMi
//
//  Created by litao on 15/9/8.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络工具类 - 子工具类 - 用于网络请求参数设置
 *  不全部放在HttpTool中原因 - 专人做专事 - 减低维护成本 - 提升本工具类的使用范围
 */

@interface HttpParamsSetting : NSObject
#pragma mark - 自定义参数字典封装
/**
 *  请求参数封装
 *
 *  @param dicParams    标准json格式参数字典
 *
 *  @return mutableDic
 */
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)dicParams;

/**
 *  请求参数封装
 *
 *  @param src          请求来源
 *  @param dicParams    标准json格式参数字典
 *  @param securityCode 安全码
 *
 *  @return mutableDic
 */
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)srcDic
                                dicParams:(NSMutableDictionary *)dicParams
                                 security:(NSMutableDictionary *)securityDic;

#pragma mark - 复杂参数
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)srcDic
                         paramsJSONString:(NSString *)paramsJSONString
                                 security:(NSMutableDictionary *)securityDic;

+ (NSDictionary *)dicFromServerRet:(id)responseObject;

+ (NSString *)jsonStrWithCryptedStr:(NSString *)cryptedStr;

+ (NSString *)md5StrWithDic:(NSDictionary *)dic;
@end
