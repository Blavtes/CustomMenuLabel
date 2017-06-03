//
//  GJSShareSDKManager.h
//  HX_GJS
//
//  Created by gjfax on 15/11/23.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"


#define ShareSDK_AppKey                     @""

//http://open.weibo.com
#define ShareSDK_SinaWeibo_AppKey           @""
#define ShareSDK_SinaWeibo_AppSecret        @""
#define ShareSDK_SinaWeibo_AppRedirectUri   @""

//http://open.weixin.qq.com
#define ShareSDK_WeChat_AppID               @""//@"wx7cbda2643bc8fef2"
#define ShareSDK_WeChat_AppSecret           @""//@"319eac587bbb99887593c473bbd76b17"

//http://open.qq.com/
//URL schemes :QQ41DB8C01, tencent1104907265 这2个必须填写。
//其中，QQ+16进制appID 1104907265的16进制：41DB8C01   1104360125的16进制：41D332BD
#define ShareSDK_QQAndQZone_AppID           @""//@"1104907265"
#define ShareSDK_QQAndQZone_AppKey          @"" //@"bpiqrM9SS5RVojNK"

@interface GJSShareSDKManager : NSObject

@property (assign,nonatomic)BOOL isActivityCenterShare;
/**
 *  注册shareSDK
 */
+ (void)regeistShareSDK;



/**
 *  外层调用，打开分享视图，默认平台列表
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *  shareParams 使用 shareParamsWithTitle:imageUrlString:urlString:content:
 **/
+ (void)startShareSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams;

//活动中心的分享
+ (void)activityCenterstartShareSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams;

/**
 *  原始方法，分享
 *
 *  shareParams =   [[self class] shareParamsWithTitle:imageUrlString:urlString:content:];
 *  shareList   =   [shareSDK customShareListWithType:]
 *  shareSDK策略，用户没安装的平台，实际不会出现在列表中。
 */
+ (void)showShareActionSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams shareList:(NSArray *)shareList;

/**
 *  构造分享内容shareParams
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *
 **/
+ (id<ISSContent>)shareParamsWithTitle:(NSString *)title
                        imageUrlString:(NSString *)imageUrlStr
                             urlString:(NSString *)urlStr
                               content:(NSString *)content;


/**
 *  这里仅适用于红包分享中微信以及微信朋友圈列表
 *  外层调用，打开分享视图，默认平台列表
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *  shareParams 使用 shareParamsWithTitle:imageUrlString:urlString:content:
 **/
+ (void)startRedPacketShareSheetOnlyWexin:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams;

@end
