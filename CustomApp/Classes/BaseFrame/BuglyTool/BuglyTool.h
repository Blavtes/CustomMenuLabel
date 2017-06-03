//
//  BuglyTool.h
//  GjFax
//
//  Created by Blavtes on 2017/3/15.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuglyTool : NSObject <BuglyDelegate>
//开启bugly
+ (void)setupBuglyConfig;

//上传获取数据返回不为success的数据
+ (void)reportGetDataNoSuccessResponse:(id)response url:(NSString *)apiUrl;

//上传解析错误的api 返回为error 的接口
+ (void)reportParseAPIError:(NSError *)error url:(NSString *)strUrl;

//上传超时的url
+ (void)reportTimeOutUrl:(NSString *)strUrl;

//上传push 异常的vc
+ (void)reportVCPushException:(UIViewController *)viewController;

//上传pop 异常的vc
+ (void)reportVCPopException:(UINavigationController *)nav;

//上传pop root异常的vc
+ (void)reportVCPopRootException:(UINavigationController *)nav;

//上传异常 selector msg
+ (void)reportSelectorException:(NSArray *)msg;

//上传 异常 过滤过的信息
+ (void)reportSafetyException:(NSString *)msg;

@end
