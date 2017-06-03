//
//  GJSShareSDKManager.m
//  HX_GJS
//
//  Created by gjfax on 15/11/23.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import "GJSShareSDKManager.h"
#import "CommonDefine.h"

@implementation GJSShareSDKManager


#pragma mark - 标准版版 shareSDK
/**
 *  注册shareSDK
 */
+ (void)regeistShareSDK
{

    [ShareSDK registerApp:ShareSDK_AppKey];

    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:ShareSDK_SinaWeibo_AppKey
                               appSecret:ShareSDK_SinaWeibo_AppSecret
                             redirectUri:ShareSDK_SinaWeibo_AppRedirectUri];

    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:ShareSDK_QQAndQZone_AppID
                           appSecret:ShareSDK_QQAndQZone_AppKey
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];

    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:ShareSDK_QQAndQZone_AppID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:ShareSDK_WeChat_AppID   //微信APPID
                           appSecret:ShareSDK_WeChat_AppSecret  //微信APPSecret
                           wechatCls:[WXApi class]];

    //连接短信分享
    [ShareSDK connectSMS];
//    //连接邮件
//    [ShareSDK connectMail];

}

/**
 *  外层调用，打开分享视图，默认平台列表
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *  shareParams 使用 shareParamsWithTitle:imageUrlString:urlString:content:
 **/
+ (void)startShareSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams
{
    NSArray *shareList = [ShareSDK customShareListWithType:
                          //[NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                          //[NSNumber numberWithInteger:ShareTypeQQ],
                          [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                          [NSNumber numberWithInteger:ShareTypeQQSpace],
                          [NSNumber numberWithInteger:ShareTypeSMS],
                          nil];
    
    [[self class] showShareActionSheet:vc shareParams:shareParams shareList:shareList];
}

//活动中心的分享
+ (void)activityCenterstartShareSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams{
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                          [NSNumber numberWithInteger:ShareTypeQQ],
                          [NSNumber numberWithInteger:ShareTypeSinaWeibo],
                          [NSNumber numberWithInteger:ShareTypeQQSpace],
                          [NSNumber numberWithInteger:ShareTypeSMS],
                          nil];
    
    [[self class] showShareActionSheet:vc shareParams:shareParams shareList:shareList];
}
/**
 *  构造分享内容shareParams
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *
 **/
+ (id<ISSContent>)shareParamsWithTitle:(NSString *)title
                        imageUrlString:(NSString *)imageUrlStr
                             urlString:(NSString *)urlStr
                               content:(NSString *)content
{
    //构造分享内容
    id<ISSCAttachment> imageUrl = nil;
    if (![imageUrlStr hasPrefix:@"/"]) {
        imageUrl = [ShareSDK imageWithUrl:imageUrlStr];
    }else {
        imageUrl = [ShareSDK imageWithPath:imageUrlStr];
    }
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"分享有惊喜哦!"
                                                image:imageUrl
                                                title:title
                                                  url:urlStr
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    return publishContent;
}

/**
 *  原始方法，分享
 *
 *  shareParams = [[self class] shareParamsWithTitle:imageUrlString:urlString:content:];
 *  shareList = @[shareSDK customShareListWithType:]
 *  shareSDK策略，用户没安装的平台，实际不会出现在列表中。
 */
+ (void)showShareActionSheet:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams shareList:(NSArray *)shareList
{
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:vc];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:shareParams
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

                                if (state == SSResponseStateSuccess)
                                {
                                    Show_iToast(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    if ([error errorCode] == -6004 || [error errorCode] == -24002) {//QQ
                                        Show_iToast([error errorDescription]);
                                    }else if ([error errorCode] == -22003) {    //微信
                                        Show_iToast([error errorDescription]);
                                    }
                                    DLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

/**
 *  这里仅适用于红包分享中微信以及微信朋友圈列表
 *  外层调用，打开分享视图，默认平台列表
 *  shareParams需要默认值，分享时不能存在空值，否则分享失败
 *  shareParams 使用 shareParamsWithTitle:imageUrlString:urlString:content:
 **/
+ (void)startRedPacketShareSheetOnlyWexin:(UIViewController *)vc shareParams:(id<ISSContent>)shareParams
{
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
            
                          nil];
    
    [[self class] showShareActionSheet:vc shareParams:shareParams shareList:shareList];
}



@end
