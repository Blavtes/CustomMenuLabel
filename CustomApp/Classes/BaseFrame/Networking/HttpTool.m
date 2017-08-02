//
//  HttpTool.h
//  YiYunMi
//
//  Created by 李涛 on 15/4/23.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "HttpTool.h"

#import "BaseNetworkingClient.h"
#import "HttpParamsSetting.h"

#import "Reachability.h"

#import "CommonDefine.h"
#import "CommonMethod.h"

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "GjFaxCgiErrorCollection.h"

@interface HttpTool()

/**
 *  获取拼接后的URL
 *
 *  @param cgiString
 *  @param dicParams
 *
 *  @return
 */
+ (NSURL *)getURLWithCgiStrAndParams:(NSString *)cgiString params:(NSDictionary *)dicParams;
@end

@implementation HttpTool
#pragma mark - url和body拼接封装

+ (NSURL *)getURLWithCgiStrAndParams:(NSString *)cgiString params:(NSDictionary *)dicParams
{
    
    NSString* URLpath = FMT_STR(@"%@?%@", cgiString, kCommonRequestBodyHeader);
    
    if (dicParams) {
        URLpath = [URLpath stringByAppendingString:[dicParams JSONString]];
    }
    
    URLpath = [URLpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:URLpath];
    
    return URL;
}

#pragma mark - 判断是否有网络
/**
 *  这个函数是判断网络是否可用的 (wifi或者蜂窝数据可用,都返回YES)
 *
 *  @return Yes or No
 */
+ (BOOL)isNetworkOpen
{
    if(
       ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) && ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable)
       ){
        return YES;
    } else {
        Show_iToast(kInterfaceRetNoteNetworkErrorStr);
        //[CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
        return NO;
    }
}

#pragma mark - afn标准请求 - post
+ (void)postUrl:(NSString *)strUrl
         params:(NSDictionary *)dicParams
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure
{
    [self postUrl:strUrl
           params:dicParams
        headerDic:nil
          success:success
          failure:failure];
}

+ (void)postUrl:(NSString *)strUrl
         params:(NSDictionary *)dicParams
      headerDic:(id)headerDic
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure
{
    if ([self isNetworkOpen]) {
        
        AFHTTPSessionManager *manager = [BaseNetworkingClient sharedClient];
        
        if (headerDic) {
            //  追加header
            [headerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (![obj isNilObj]) {
                    [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
                    DLog(@"key = %@ and obj = %@", key, obj);
                } else {
                    DLog(@"key = %@ and obj is Nil", key);
                }
                
            }];
        }
        
        //NSURL *URL = [self getURLWithCgiStrAndParams:strUrl params:dicParams];
        NSDictionary *reqDic = [HttpParamsSetting dicParamsSetting:(NSMutableDictionary *)dicParams];
        
        //  参数的校验串
        NSString *signStr = [HttpParamsSetting md5StrWithDic:reqDic];
        
//        //  每个请求之前清空Cookie
//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        if ([cookieJar cookies].count > 0) {
//            for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//            }
//        }
        
        //  签名放cookie中
        NSDictionary *cookiePropertiesDic = @{@"sign": signStr};
        [cookiePropertiesDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            //  设定 cookie
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [manager.baseURL host], NSHTTPCookieDomain,
                                 [manager.baseURL path], NSHTTPCookiePath,
                                 key, NSHTTPCookieName,
                                 obj, NSHTTPCookieValue,
                                 nil];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            
        }];
        
        //  请求
        NSURLSessionDataTask *task = [manager POST:strUrl parameters:reqDic progress:^(NSProgress * _Nonnull uploadProgress) {
            //  progress
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //  success
            if (responseObject == nil || [responseObject isNilObj]) {
                success([self fetchNetworkErrorResponseJSON:kInterfaceRetStatusFail withCode:kNetworkSystemError withInfo:kInterfaceRetDataErrorStr]);
                
                DLog(@"%@ -> 返回数据格式错误[数据为空]", strUrl);
                
#pragma mark - -  接口错误采集
                //  接口错误采集
                [[GjFaxCgiErrorCollection manager] collectCgiErrorWithCgiName:strUrl andCode:kNetworkSystemError andInfo:FMT_STR(@"[返回数据为空]%@", kInterfaceRetDataErrorStr)];
                
            } else {
                //  非空
                NSDictionary *retDic = [HttpParamsSetting dicFromServerRet:responseObject];
                
                if (retDic) {
//                    [BuglyTool reportGetDataNoSuccessResponse:retDic url:strUrl];
                    success(retDic);
                    
                } else if (![[responseObject objectForKeyForSafetyValue:@"note"] isNilObj] &&
                           ![[responseObject objectForKeyForSafetyValue:@"resultCode"] isNilObj] &&
                           ![[responseObject objectForKeyForSafetyValue:@"success"] isNilObj]) {
#pragma mark - 格式完全符合老版本的情形
                    NSString *retStatus = [responseObject objectForKeyForSafetyValue:@"success"];
                    NSString *retCode = [responseObject objectForKeyForSafetyValue:@"resultCode"];
                    NSString *retInfo = [responseObject objectForKeyForSafetyValue:@"note"];
                    success([self fetchNetworkErrorResponseJSON:retStatus withCode:retCode withInfo:kInterfaceRetDataErrorStr]);
                    
                    DLog(@"%@ -> 返回数据格式错误[老版本格式]", strUrl);
                    
#pragma mark - - 接口错误采集
                    //  接口错误采集
                    [[GjFaxCgiErrorCollection manager] collectCgiErrorWithCgiName:strUrl andCode:retCode andInfo:FMT_STR(@"[老版本格式]%@", retInfo)];
                } else {
                    success([self fetchNetworkErrorResponseJSON]);
                    
                    DLog(@"%@ -> 返回数据格式错误[有返回数据、解析数据为空]", strUrl);
#pragma mark - - 接口错误采集
                    //  接口错误采集
                    [[GjFaxCgiErrorCollection manager] collectCgiErrorWithCgiName:strUrl andCode:kNetworkSystemError andInfo:FMT_STR(@"[有返回数据、解析数据为空]%@", kInterfaceRetDataErrorStr)];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //  failure
//            [BuglyTool reportParseAPIError:error url:strUrl];
            //[self showNetworkError:error];
            if (failure) {
                failure(error);
            }
            DLog(@"%@ -> 网络错误[%@]", strUrl, error.localizedDescription);
            //Show_iToast(kInterfaceRetNoteNetworkErrorStr);
#pragma mark - - 接口错误采集
            //  接口错误采集
            [[GjFaxCgiErrorCollection manager] collectCgiErrorWithCgiName:strUrl andCode:FMT_STR(@"%ld", (long)error.code)  andInfo:FMT_STR(@"[网络错误]%@", error.localizedDescription)];
            
        }];
        //DLog(@"\n----PostTask----\n%@-->%@", task.currentRequest.URL.absoluteString, [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    } else {
        //  无网络提示
//        [BuglyTool reportTimeOutUrl:strUrl];
        failure(nil);
    }
}


#pragma mark - 用于复杂参数POST

//+ (void)postUrl:(NSString *)strUrl
//      paramsStr:(id)paramsStr
//      headerDic:(id)headerDic
//        success:(void (^)(id))success
//        failure:(void (^)(NSError *))failure
//{
//    if ([self isNetworkOpen]) {
//        
//        AFHTTPSessionManager *manager = [BaseNetworkingClient sharedClient];
//        
//        if (headerDic) {
//            //  追加header
//            [headerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                if (![obj isNilObj]) {
//                    [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//                    DLog(@"key = %@ and obj = %@", key, obj);
//                } else {
//                    DLog(@"key = %@ and obj is Nil", key);
//                }
//                
//            }];
//        }
//        
//        //  组装参数
//        NSDictionary *reqDic = [HttpParamsSetting dicParamsSetting:nil paramsJSONString:paramsStr security:nil];
//        
//        //  参数的校验串
//        NSString *signStr = [HttpParamsSetting md5StrWithDic:reqDic];
//        
//        //  签名放cookie中
//        NSDictionary *cookiePropertiesDic = @{@"sign": signStr};
//        [cookiePropertiesDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            //  设定 cookie
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [manager.baseURL host], NSHTTPCookieDomain,
//                                 [manager.baseURL path], NSHTTPCookiePath,
//                                 key, NSHTTPCookieName,
//                                 obj, NSHTTPCookieValue,
//                                 nil];
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            
//        }];
//        
//        //  请求
//        NSURLSessionDataTask *task = [manager POST:strUrl parameters:reqDic progress:^(NSProgress * _Nonnull uploadProgress) {
//            //  progress
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            //  success
//            NSDictionary *retDic = [HttpParamsSetting dicFromServerRet:responseObject];
//            
//            if (retDic) {
//                [CommonMethod hideAllTipInfoTop];
//                
//                success(retDic);
//                
//            } else {
//                success([self fetchNetworkErrorResponseJSON]);
//                //failure(nil);
//                
//                //[CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
//                DLog(@"%@ -> 返回数据格式错误 & 接口没有返回数据", strUrl);
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //  failure
//            //[self showNetworkError:error];
//            if (failure) {
//                failure(error);
//            }
//        }];
//        //DLog(@"\n----PostTask----\n%@-->%@", task.currentRequest.URL.absoluteString, [[NSString alloc] initWithData:task.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]);
//    } else {
//        //  无网络提示
//        failure(nil);
//    }
//}

#pragma mark - 提示网络错误
/**
 *  弹出网络错误信息
 *
 *  @param error errorInfo
 */
+ (void)showNetworkError:(NSError *)error
{
    //  统一顶部提示
    [CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
    DLog(@"error = %@",error);
    return;
#pragma mark - 为了用户体验不提示
    //  不提示
    if (error.code == -1001) {
        Show_iToast(NET_ERROR_1001);
    }
    else if (error.code == -1002) {
        Show_iToast(NET_ERROR_1002);
    }
    else if (error.code == -1003) {
        Show_iToast(NET_ERROR_1003);
    }
    else if (error.code == -1004) {
        Show_iToast(NET_ERROR_1004);
    }
    else if (error.code == -1005) {
        Show_iToast(NET_ERROR_1005);
    }
    else if (error.code == -1009) {
        Show_iToast(NET_ERROR_1009);
    } else {
        Show_iToast(NET_ERROR_1009);
    }
}

/**
 *  网络错误、接口出错情况 返回标准的JSON信息
 */
+ (NSDictionary *)fetchNetworkErrorResponseJSON
{
    NSMutableDictionary *retErrorJSONDic = [[NSMutableDictionary alloc] initWithDictionary:[self fetchNetworkErrorResponseJSON:kInterfaceRetStatusFail withCode:kNetworkSystemError withInfo:kInterfaceRetNoteNetworkErrorStr]];
    
    return retErrorJSONDic;
}

+ (NSDictionary *)fetchNetworkErrorResponseJSON:(NSString *)retStatus
                                       withCode:(NSString *)retCode
                                       withInfo:(NSString *)retInfo
{
    NSMutableDictionary *retErrorJSONDic = [[NSMutableDictionary alloc] init];
    
    //  result
    [retErrorJSONDic setObjectJudgeNil:@"" forKey:@"result"];
    
#pragma mrak - retStatus/code/note 为空时，给予一个默认值
    if (retStatus == nil || [retStatus isNilObj]) {
        retStatus = kInterfaceRetStatusFail;
    }
    
    if (retCode == nil || [retCode isNilObj]) {
        retCode = kNetworkSystemError;
    }
    
    if (retInfo == nil || [retCode isNilObj]) {
        retInfo = kInterfaceRetDataErrorStr;
    }
    
    //  retInfo
    NSMutableDictionary *interfaceInfoDic = [[NSMutableDictionary alloc] init];
    [interfaceInfoDic setObjectJudgeNil:retStatus forKey:@"status"];
    [interfaceInfoDic setObjectJudgeNil:retCode forKey:@"retCode"];
    [interfaceInfoDic setObjectJudgeNil:retInfo forKey:@"note"];
    
    [retErrorJSONDic setObjectJudgeNil:interfaceInfoDic forKey:@"retInfo"];
    
    return retErrorJSONDic;
}

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
        failure:(void (^)(NSError *error))failure
{
    if ([self isNetworkOpen]) {
        NSString *urlString = FMT_STR(@"%@", strUrl);
        //  postBody
        if (dicParams) {
            NSString *paramsStr = [dicParams JSONString];
            DLog(@"urlStirning = %@?%@", urlString, paramsStr);
        } else {
            DLog(@"urlStirning = %@", urlString);
        }
        
        //1.获得请求管理者
        AFHTTPSessionManager *mgr = [BaseNetworkingClient sharedClient];
        
        //  先判断是否有头
        if (headerDic) {
            //  追加header
            [headerDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [mgr.requestSerializer setValue:obj forHTTPHeaderField:key];
                if (![obj isNilObj]) {
                    [mgr.requestSerializer setValue:obj forHTTPHeaderField:key];
                    DLog(@"key = %@ and obj = %@", key, obj);
                } else {
                    DLog(@"key = %@ and obj is Nil", key);
                }
            }];
        }
        
        [mgr POST:urlString parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //封装请求体
            if ([fileParams count] > 0) {
                NSArray *allKeys = [fileParams allKeys];
                for (int i = 0; i < allKeys.count; i++) {
                    NSString *key = allKeys[i];
                    id value = [fileParams objectForKey:key];
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        //多媒体文件
                        NSDictionary *fileDict = (NSDictionary *)value;
                        NSString *filePath = [fileDict objectForKey:AFREQUEST_FILEUPLOAD_FILEPATH];
                        NSData   *fileData = [fileDict objectForKey:AFREQUEST_FILEUPLOAD_FILEDATA];
                        NSString *fileName = [fileDict objectForKey:AFREQUEST_FILEUPLOAD_FILENAME];
                        NSString *fileType = [fileDict objectForKey:AFREQUEST_FILEUPLOAD_FILETYPE];
                        //文件上传时必须有文件路径或文件的字节流其中的一个
                        if (![filePath isKindOfClass:[NSNull class]] && [filePath length] > 0) {
                            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:key error:nil];
                        } else if(fileData){
                            [formData appendPartWithFileData:fileData name:key fileName:fileName mimeType:fileType];
                        }
                    } else {
                        DLog(@"post file is not Dic");
                    }
                }
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //  success
            if (responseObject == nil || [responseObject isNilObj]) {
                success([self fetchNetworkErrorResponseJSON:kInterfaceRetStatusFail withCode:kNetworkSystemError withInfo:kInterfaceRetDataErrorStr]);
                //failure(nil);
                
                //[CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
                DLog(@"%@ -> 返回数据格式错误[数据为空]", strUrl);
            } else {
            
                NSDictionary *retDic = [HttpParamsSetting dicFromServerRet:responseObject];
                
                if (retDic) {
                    [CommonMethod hideAllTipInfoTop];
                    
                    success(retDic);
                    
                } else if (![[responseObject objectForKeyForSafetyValue:@"note"] isNilObj] &&
                           ![[responseObject objectForKeyForSafetyValue:@"resultCode"] isNilObj] &&
                           ![[responseObject objectForKeyForSafetyValue:@"success"] isNilObj]) {
#pragma mark - 格式完全符合老版本的情形
                    NSString *retStatus = [responseObject objectForKeyForSafetyValue:@"success"];
                    NSString *retCode = [responseObject objectForKeyForSafetyValue:@"resultCode"];
                    NSString *retInfo = [responseObject objectForKeyForSafetyValue:@"note"];
                    success([self fetchNetworkErrorResponseJSON:retStatus withCode:retCode withInfo:kInterfaceRetDataErrorStr]);
                    //failure(nil);
                    
                    //[CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
                    DLog(@"%@ -> 返回数据格式错误[老版本格式]", strUrl);
                } else {
                    success([self fetchNetworkErrorResponseJSON]);
                    //failure(nil);
                    
                    //[CommonMethod showTipInfoTop:DEFAULT_NO_NETWORK_TOP_TIP];
                    DLog(@"%@ -> 返回数据格式错误", strUrl);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
        //        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //
        //        }];
        
    } else {
        //  无网络提示
        failure(nil);
    }
}

#pragma mark - 获取本机ip
/**
 *  获取本机ip数组
 */
+ (NSArray *)getCurDeviceAddress
{
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    return ips;
}

/**
 *  获取本机ip字符串
 */
+ (NSString *)getCurDeviceAddressStr
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    DLog(@"[cur phone IP]:%@", address);
    return address;
}

#pragma mark - 处理后台返回的errorCode
+ (void)handleErrorCodeFromServer:(id)errorCode withNote:(NSString *)note
{
    //  属于特殊错误码则直接处理
    if (![SpecialLogicErrorTool handleSpecialErrorWithCode:errorCode andNote:note]) {
        //  不属于特殊错误码则直接打印note
        if (note && ![note isNullStr] && [note respondsToSelector:@selector(isNullStr)]) {
             Show_iToast(note);
        }
       
    }
}
@end
