//
//  HttpTool.h
//  YiYunMi
//
//  Created by 李涛 on 15/4/23.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpParamsSetting.h"

//  通用请求参数的头
static NSString * const kCommonRequestBodyHeader = @"httpParams=";
//  网络接口成功、失败
static NSString * const kInterfaceRetStatusSuccess = @"success";
static NSString * const kInterfaceRetStatusSuccessUpperCase = @"SUCCESS";
static NSString * const kInterfaceRetStatusFail = @"fail";
static NSString * const kInterfaceRetNoteNetworkErrorStr = @"网络出错啦";
static NSString * const kInterfaceRetDataErrorStr = @"服务器开小差了";

//上传文件key
#define AFREQUEST_FILEUPLOAD_FILEPATH  @"filePath"
#define AFREQUEST_FILEUPLOAD_FILEDATA  @"fileData"
#define AFREQUEST_FILEUPLOAD_FILENAME  @"fileName"
#define AFREQUEST_FILEUPLOAD_FILETYPE  @"fileType"

/**
 *  网络工具类 负责整个项目中所有的Http网络请求封装 防止对第三方的强依赖
 */

@interface HttpTool : HttpParamsSetting
#pragma mark - 判断是否有网络
/**
 *  这个函数是判断网络是否 (wifi或者蜂窝数据可用,都返回YES)
 *
 *  @return Yes or No
 */
+ (BOOL)isNetworkOpen;

#pragma mark - afn标准请求 - post
/**
 *  POST - AFNetworking based
 *
 *  @param strUrl
 *  @param dicParams
 *  @param success
 *  @param failure
 */
+ (void)postUrl:(NSString *)strUrl
         params:(NSDictionary *)dicParams
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure;

+ (void)postUrl:(NSString *)strUrl
         params:(NSDictionary *)dicParams
      headerDic:(id)headerDic
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure;

//  用于复杂参数
#pragma mark - 由于接口已于3.0标准化。故屏蔽此接口
//+ (void)postUrl:(NSString *)strUrl
//      paramsStr:(id)paramsStr
//      headerDic:(id)headerDic
//        success:(void (^)(id))success
//        failure:(void (^)(NSError *))failure;

#pragma mark - post 上传图片
/**
 *  用afn发送一个POST 多文件上传请求
 *
 *  @param strUrl  请求路径
 *  @param dicParams  请求参数
 *  @param fileParams  文件数据    fileData/filePath，fileName,fileType
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postUrl:(NSString *)strUrl
         params:(NSDictionary *)dicParams
     fileParams:(NSDictionary *)fileParams
      headerDic:(id)headerDic
        success:(void (^)(id responseObj))success
        failure:(void (^)(NSError *error))failure;

#pragma mark - 获取本机ip
/**
 *  获取本机ip数组
 */
+ (NSArray *)getCurDeviceAddress;

/**
 *  获取ip
 */
+ (NSString *)getCurDeviceAddressStr;

#pragma mark - 处理后台返回的errorCode
/**
 *  处理后台返回的errorCode
 */
+ (void)handleErrorCodeFromServer:(id)errorCode withNote:(NSString *)note;
@end