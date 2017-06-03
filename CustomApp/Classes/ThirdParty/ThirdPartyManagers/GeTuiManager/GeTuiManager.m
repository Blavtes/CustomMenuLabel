//
//  GeTuiManager.m
//  HX_GJS
//
//  Created by gjfax on 15/11/5.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import "GeTuiManager.h"
#import "pushNotifiWebViewViewController.h"


@implementation GeTuiManager


+ (GeTuiManager *)sharedManager
{
    static dispatch_once_t onceToken;
    static GeTuiManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GeTuiManager alloc] init];
    });
    
    return sharedInstance;
}

/**
 *  开启个推SDK服务
 *
 */
+ (void)starGeTuiSDK
{
    GeTuiManager  *manager = [[self class] sharedManager];
//    NSError *error = nil;
//    [GeTuiSdk startSdkWithAppId:kGeTuiAppId appKey:kGeTuiAppKey appSecret:kGeTuiAppSecret delegate:manager error:&error];
    
    [GeTuiSdk startSdkWithAppId:kGeTuiAppId appKey:kGeTuiAppKey appSecret:kGeTuiAppSecret delegate:manager];
    [GeTuiSdk runBackgroundEnable:YES];
//    [GeTuiSdk setPushModeForOff:NO];
}

/**
 *  向个推服务器注册deviceToken
 *  注册失败也使用  deviceToken 传@“”
 */
+ (void)registerDeviceToken:(NSString *)deviceToken
{
    [GeTuiSdk registerDeviceToken:deviceToken];
}

/**
 *  Background Fetch 恢复SDK 运行
 *
 */
+ (void)GeTuiBackGroudFetchResume
{
    [GeTuiSdk resume];
}

/**
 *  APP进入后台时，通知个推SDK进入后台
 *
 */
+ (void)enterBackGroud
{
//    [GeTuiSdk enterBackground];
}

/**
 *  在rootViewController打开webView
 *
 */
+ (void)presentWebView:(NSString *)redirectURL
{
    pushNotifiWebViewViewController *notiWebVC = [[pushNotifiWebViewViewController alloc] init];
    notiWebVC.requestURL = redirectURL;
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:notiWebVC animated:YES completion:nil];
}

- (NSString *)formateTime:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

#pragma mark -- GeTui Delegate

//SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    DLog(@"registerClient == %@",clientId);
}


//SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    
//    NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
//    
//    //消息内容，json
//    //目前只作打开URL，redirectUrl跳转的url
//    if (payload) {
//        NSError *error = nil;
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingMutableContainers error:&error];
//        
//        NSDictionary *body = [resultDic objectForKeyForSafetyDictionary:@"body"];
//        NSString     *redirectURL = [body objectForKeyForSafetyValue:@"redirectUrl"];
//        DLog(@"redirectUrl == %@",redirectURL);
//        if (redirectURL && ![redirectURL isKindOfClass:[NSNull class]]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
////                [[self class] presentWebView:redirectURL];
//            });
//            
//        }
//    }

    //[[[[iToast makeText:FMT_STR(@"%@",record)] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
    
}


//SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result
{
    DLog(@"GeTuiSdkDidSendMessage == %@  , result == %@",messageId,@(result));
}


//SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    DLog(@"GeTuiSdkDidOccurError == %@ ",error);

}


//SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
     DLog(@"GeTuiSDkDidNotifySdkState == %@ ",@(aStatus));
}


//SDK设置关闭推送功能回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error
{
    DLog(@"GeTuiSdkDidSetPushMode == %@ ",error);
}




@end
