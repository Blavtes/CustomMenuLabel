//
//  GeTuiManager.h
//  HX_GJS
//
//  Created by gjfax on 15/11/5.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeTuiSdk.h"



#define kGeTuiAppId                     @"NiWQHSe3AR9a0xeiqhj4V"
#define kGeTuiAppKey                    @"wlnIfkabvj6oQKGcBxdwxA"
#define kGeTuiAppSecret                 @"roJvlHRqRl9kWD3hIl6R87"


@interface GeTuiManager : NSObject <GeTuiSdkDelegate>

/**
 *  开启个推SDK服务
 *
 */
+ (void)starGeTuiSDK;

/**
 *  向个推服务器注册deviceToken
 *  注册失败也使用  deviceToken 传@“”
 */
+ (void)registerDeviceToken:(NSString *)deviceToken;

/**
 *  Background Fetch 恢复SDK 运行
 *
 */
+ (void)GeTuiBackGroudFetchResume;

/**
 *  APP进入后台时，通知个推SDK进入后台
 *
 */
+ (void)enterBackGroud;

/**
 *  在rootViewController打开webView
 *
 */
+ (void)presentWebView:(NSString *)redirectURL;
@end
