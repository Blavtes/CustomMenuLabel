//
//  AppDelegate.m
//  HX_GJS
//
//  Created by ZXH on 15/3/14.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreSpotlight/CoreSpotlight.h>

#import "CustomTabBarViewController.h"
#import "GuidePageViewController.h"

#import "PreCommonHeader.h"

//#import "GeTuiManager.h"
//#import "GJSShareSDKManager.h"

//#import <ShareSDK/ShareSDK.h>
#import "ThreeDTouchTool.h"

#import "WebViewController.h"

#import "MorePageViewController.h"
#import "CustomNavigationController.h"

#import "NetWorkingStatusModel.h"   //  网络状态model
//#import "JSPatchTool.h"
#import "NotificationViewController.h"

NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

static float const kLaunchSleepTime = 1.5f;

@interface AppDelegate ()  
{
    //  启动页
    UIView *launchView;
    //  定时器
    NSTimer *timer;
    //  启动页链接
    NSString *_launchLinkUrl;
    NSMutableDictionary *_shareParams;
}

@end

@implementation AppDelegate

//  告诉代理启动基本完成程序准备开始运行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //  显示状态栏
    application.statusBarHidden = NO;
    //  延迟启动页显示时间
    [NSThread sleepForTimeInterval:0.5f];
    
    [_window makeKeyAndVisible];
    
    //开启bugly
//    [BuglyTool setupBuglyConfig];
    
    //开启JSPatch
    
//    [JSPatchTool startJSPatch];
    //  设置根控制器
    [self addRootWindowVc];
    
    //  注册消息推送
    [self registerNotifications];
    //  个推SDK注册
//    [GeTuiManager starGeTuiSDK];
    
    //  创建搜索
    //[self initCoreSpotlight];
    
    //  注册分享
//    [GJSShareSDKManager regeistShareSDK];
    
#pragma mark - 发送采集数据
    
    
#pragma mark - - 启动页
    //  启动页面
//    [self launchView];

#pragma mark - - 引导页
//    [[GuidePageViewController sharedInstance] fetchGuideData];
    
#pragma mark - - 小红点信息
    [[BadgeTool sharedInstance] reqBadgeInfo];
    
#pragma mark - - 更新信息
   // [[UpdateTool sharedInstance] reqUpdateInfo];
    
#pragma mark - - 产品可购买数量信息
    
    
#pragma mark －UM(UM即友盟，下同)配置AppDelegate
    
    
    //  初始化登陆信息
    [self initLoginInfo];
    

    //初始化3DTouch
    [ThreeDTouchTool initApplicationShortcutItem];
    
    //  启动并注册 监控联网状态
    [NetWorkingStatusModel manager];
    [self login];
    return YES;
}

#pragma mark - 网络状态监听


#pragma mark -



#pragma mark - 初始化新搜索特性
/**
 *  初始化CoreSpotlight信息
 */
- (void)initCoreSpotlight
{
    NSMutableArray *searchableItems = [NSMutableArray array];
    
    //  Create an attribute set for an item that represents an image.
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"image"];
    attributeSet.title = @"app";
    attributeSet.contentDescription = @"test!";
    attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"icon120x120"]);
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"app" domainIdentifier:@"com.yy.app" attributeSet:attributeSet];
    [searchableItems addObject:item];

    //  save
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
        if (error) {
            DLog(@"error message:%@", error.localizedDescription);
        }
    }];
}

- (void)initLoginInfo
{
    //  放弃自动登陆
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeAutoLogin, NO);
    //  非手势弹窗
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeShowedLoginViewFromGestureView, NO);
    
    //  没正式进入app之前 - 不允许弹顶部网络框
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeEnteredApp, NO);
    
#pragma mark - V3.2.2手势密码存于后台 - 故之前版本更新后默认将本地手势密码关闭
  
}

- (void)loadTabBarViewController
{
    MorePageViewController *vc = [[MorePageViewController alloc] init];
    
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
   // _customTabBarVc = [[CustomTabBarViewController alloc] init];
   // self.window.rootViewController = _customTabBarVc;
    
        //  设置窗口为主窗口
    [self.window makeKeyAndVisible];
}

    //修正第一次 活动拉取tabbar 图片切换不了的问题
- (void)addSpringNotification
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTabBarViewController) name:@"homeBannerDataUpdate" object:nil];
}

- (void)addRootWindowVc
{
    [self addSpringNotification];
    //  创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
        //春节元素
    
    [self loadTabBarViewController];
}



/**
 *  注册push消息推送
 */
- (void)registerNotifications
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
}

//  禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url
//{
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation
//{
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

#pragma mark - 启动页
- (void)launchView
{
    launchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    launchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:launchView];
    //  可点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLaunchImgView)];
    [launchView addGestureRecognizer:tap];
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:@"3" forKey:@"bannerType"];
    
    [HttpTool postUrl:HX_BANNER_URL params:reqDic success:^(id responseObj) {
        //加载完成
        [self reqLaunchInfo_callBack:responseObj];
    } failure:^(NSError *error) {
        //  请求错误
    }];
    
    //  添加定时器 - 2.5s后移除启动页
    timer = [NSTimer scheduledTimerWithTimeInterval:kLaunchSleepTime target:self selector:@selector(removeLaunchView) userInfo:nil repeats:NO];
}

- (void)reqLaunchInfo_callBack:(id)data
{
    //  imgView
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:launchView.bounds];
    //  数据解析
    if (data) {
        NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
        
        NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
        NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
        NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
        
        NSString *imgUrl = nil;
        
        if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccess]) {
            NSDictionary *resultDic = [body objectForKeyForSafetyDictionary:@"result"];
            
            if (resultDic && ![resultDic isNilObj]) {
                imgUrl = [resultDic objectForKeyForSafetyValue:@"imageUrl"];
                _launchLinkUrl = [resultDic objectForKeyForSafetyValue:@"redirectUrl"];
                if (_launchLinkUrl && ![_launchLinkUrl isNilObj]) {
                    //  有链接返回才能点击
                    launchView.userInteractionEnabled = YES;
                }
                //  单点登录参数
                NSString *title = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"title"]);
                NSString *content = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"content"]);
                NSString *logopath = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"logopath"]);
                
                _shareParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:title, @"title", _launchLinkUrl, @"url", content, @"content", logopath, @"logopath", nil];
            }
        } else {
            [HttpTool handleErrorCodeFromServer:retCodeStr withNote:retNoteStr];
        }
        
    
            [imageV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"640x1136"]];
        
    } else {
       
            //  非4s
            imageV.image = [UIImage imageNamed:@"640x1136"];
        
    }
    //  添加网络获取的图片
    [launchView addSubview:imageV];
    [self.window bringSubviewToFront:launchView];
}

- (void)tapLaunchImgView
{
    if (_launchLinkUrl && ![_launchLinkUrl isNilObj]) {
        //  调用成功立马移除启动页
        [self removeLaunchView];
        
        WebViewController *webVc = [[WebViewController alloc] init];
        webVc.urlStr = _launchLinkUrl;
        webVc.isSSO = NO;
        webVc.title = @"详情";
        webVc.shareParams = _shareParams;
        GJSPushViewController(webVc, YES);
    }
}

- (void)removeLaunchView
{
    [launchView removeFromSuperview];
#pragma mark - more模块tabbar小红点
    if ([[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowMoreTabbarType]) {
        [CommonMethod showTabbarRedPoint:MORE_INDEX];
    } else {
        [CommonMethod hiddenTabbarRedPoint:MORE_INDEX];
    }
    
#pragma mark - 是否第一次进入页面放在定时器结束后 - 流程控制
    //  是否第一次进入页面，进行引导
//    [self showGuideView];
    
    //  释放timer
    [timer invalidate];
    timer = nil;
    
    //  运行到这里表示已进入APP
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeEnteredApp, YES);
    

}

#pragma mark - 引导页
- (void)showGuideView
{
    if (!UserInfoUtil->getUserInfoWithBool(UserInfoBoolTypeFirstLaunched)) {
        [GuidePageViewController show];
    }
}

#pragma mark - appdelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  告诉代理进程启动但还没进入状态保存
    return YES;
}

#pragma mark - 程序启动相关
- (void)applicationWillResignActive:(UIApplication *)application {
    //  当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //  当应用程序入活动状态执行，这个刚好跟上面那个方法相反
    //清空所有通知，置为0，将icon上的红点消失
    
    
    // [EXT] 重新上线
//    [GeTuiManager starGeTuiSDK];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
    
    // [EXT] APP进入后台时，通知个推SDK进入后台
//    [GeTuiManager enterBackGroud];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //  当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反
}

#pragma mark -- 消息推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //获取推送号
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"消息推送号 ＝＝＝ %@",token);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    DLog(@"didFailToRegisterForRemoteNotificationsWithError Registfail:%@\n", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //  收到推送消息
    DLog(@"didReceiveRemoteNotification userInfo:%@", userInfo);
    
    //	if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) return;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //  for ios 8 notification
    DLog(@"handleActionWithIdentifier userInfo:%@", userInfo);
    
    //	if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) return;
}

#pragma mark - background fetch  唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //[5] Background Fetch 恢复SDK 运行
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //  当程序将要退出时被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。

}

- (void)applicationDidFinishLaunching:(UIApplication*)application {
    //  当程序载入后执行
}

#pragma mark - 新搜索特性
//  ios9.0 - CoreSpotlight搜索框架
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
//    //  获得标识
//    NSString *identifier = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];
//    
//    //  跳转到指定区域
//    CustomNavigationController *navigationController = (CustomNavigationController *)self.window.rootViewController;
//    [navigationController popToRootViewControllerAnimated:NO];
//    
//    // TODO: 后续添加
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    //3D Touch
    [ThreeDTouchTool clickShorycutItemJump:shortcutItem];
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    
    [self login];
    
    // 在不需要再推送时，可以取消推送
    [NotificationViewController haveLocalNotificationInfo:notification.userInfo];
}

- (void)login
{
    [self startRequestLoginWithPhoneNum:@"13538101601" passWord:@"aaa111"];
    [self startRequestLoginWithPhoneNum:@"18575564137" passWord:@"aaa111"];
    [self startRequestLoginWithPhoneNum:@"18823836928" passWord:@"aaa111"];
}

- (void)startRequestLoginWithPhoneNum:(NSString *)phoneNum passWord:(NSString *)passWord
{
    
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc]init];
    
    [loginDic setObject:phoneNum forKey:@"userName"];
    [loginDic setObject:passWord forKey:@"password"];
    
    NSString *uuid = [CommonMethod UUIDWithKeyChain];
    [loginDic setObject:uuid forKey:@"deviceNo"];
    
    
    
    [HttpTool postUrl:HX_POSTLogin params:loginDic success:^(id responseObj) {
        //加载完成
        DLog(@"login %@",responseObj);
        Show_iToast(@"o");
    } failure:^(NSError *error) {
       
    }];
}

@end
