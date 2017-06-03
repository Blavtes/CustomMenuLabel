    //
    //  CommonMethod.m
    //  HX_GJS
    //
    //  Created by litao on 15/5/5.
    //  Copyright (c) 2015年 ZXH. All rights reserved.
    //

#import "CommonMethod.h"
#import <CVKHierarchySearcher/CVKHierarchySearcher.h>

#import "PreCommonHeader.h"
#import "AppDelegate.h"
#import "AFMInfoBanner.h"
#import "KeychainItemWrapper.h"

#import <sys/utsname.h>

@implementation CommonMethod

#pragma mark - CATransition动画实现

+ (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view duration:(CGFloat)duration
{
        //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
        //设置运动时间
    animation.duration = duration;
    
        //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
            //设置子类
        animation.subtype = subtype;
    }
    
        //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - UIView实现动画

+ (void)animationWithView:(UIView *)view WithAnimationTransition: (UIViewAnimationTransition)transition duration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}


#pragma mark - 手机容量

/**
 *  总容量
 *
 *  @return 返回byte
 */
+ (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

/**
 *  可用容量
 *
 *  @return 返回byte
 */
+ (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark - 底部选项卡

+ (NSString *)classNameWithTabbarIndex:(NSUInteger)tabIndex
{
    NSString *className = @"DefaultClassName";
    
    switch (tabIndex) {
        case 0:
        {
            className = @"HomePageViewController";
        }
            break;
            
        case 1:
        {
            className = @"ProductViewController";
        }
            break;
            
        case 2:
        {
            className = @"AssetViewController";
        }
            break;
            
        case 3:
        {
            className = @"MorePageViewController";
        }
            break;
            
        default:
            break;
    }
    
    return className;
}

+ (void)switchTabBar:(int)index
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    [mainApp.customTabBarVc setSelectedIndex:index];
}

+ (void)setTabbarBadge:(int)itemIndex value:(NSString *)value
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    [[mainApp.customTabBarVc.tabBar.items objectAtIndex:itemIndex] setBadgeValue:value];
}

+ (int)getTabbarBadge:(int)itemIndex
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    UITabBarItem *curTabbarItem = [mainApp.customTabBarVc.tabBar.items objectAtIndex:itemIndex];
    int badgeValue = 0;
    if (![curTabbarItem.badgeValue isNullStr]) {
        badgeValue = [curTabbarItem.badgeValue intValue];
    }
    
    return badgeValue;
}

+ (int)retCurTabbarIndex
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    return (int)mainApp.customTabBarVc.selectedIndex;
}

/*
 *  3DTouch回到首页，会清空navi的子VC
 */
+ (void)goBackHomeWithTabbar
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    [mainApp.customTabBarVc fetch3DTouchCallBackHome];
}

/*
 *  回到tabbar特定页，会清空navi的子VC
 */
+ (void)goBackHomeWithTabbar:(int)selectIndex
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    [mainApp.customTabBarVc callBackHomeWithIndex:selectIndex];
}

#pragma mark - 底部tabbar小红点相关
/*
 *  显示tabbar小红点
 */
+ (void)showTabbarRedPoint:(NSUInteger)itemIndex
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    UITabBar *tabBar = mainApp.customTabBarVc.tabBar;
    
    [self badgeRedPoint:itemIndex tabBar:tabBar];
    
}

/*
 *  隐藏tabbar小红点
 */
+ (void)hiddenTabbarRedPoint:(NSUInteger)itemIndex
{
    AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    UITabBar *tabBar = mainApp.customTabBarVc.tabBar;
    [self removeRedPointWithItemIndex:itemIndex tabBar:tabBar];
}

    //新建小红点
+ (void)badgeRedPoint:(NSUInteger)index tabBar:(UITabBar *)tabBar {
    
    UIView *badgeView = [tabBar viewWithTag:888+index];
    if (!badgeView) {
        badgeView = [[UIView alloc] init];
        badgeView.tag = 888 + index;
        badgeView.layer.cornerRadius = 5;//圆形
        badgeView.backgroundColor = [UIColor redColor];//颜色：红色
        CGRect tabFrame = tabBar.frame;
        
            //确定小红点的位置
        float percentX = (index + 0.6) / 4;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    }
    [tabBar addSubview:badgeView];
}

    //移除tabbar红点
+ (void)removeRedPointWithItemIndex:(NSUInteger)index tabBar:(UITabBar *)tabBar {
        //按照tag值进行移除
    for (UIView *subView in tabBar.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - 顶部AFM弹出框

+ (void)showTipInfoTop:(NSString *)str
{
        //  判断是否有keyWindow
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        return;
    }
    
        //  有keyWindow才显示AFMInfoBanner
    AFMInfoBanner *afmBanner = [self bannerViewForCurNavi];
        //  已进入app
    if (!afmBanner && UserInfoUtil->getUserInfoWithBool(UserInfoBoolTypeEnteredApp)) {
            //  显示网络提示框
        afmBanner = [AFMInfoBanner showWithText:str style:AFMInfoBannerStyleInfo animated:YES];
        afmBanner.infoBackgroundColor = COMMON_ORANGE_COLOR;
    }
}

+ (AFMInfoBanner *)bannerViewForCurNavi
{
    UIView *targetView = nil;
    
    CVKHierarchySearcher *searcher = [[CVKHierarchySearcher alloc] init];
    
    UIViewController *topmostVC = [searcher topmostViewController];
    UINavigationBar *possibleBar = [self navigationBarFor:topmostVC];
    
    if (possibleBar && !possibleBar.translucent) {
        targetView = possibleBar.superview;
    } else {
        UINavigationController *navVC = [searcher topmostNavigationController];
        if (navVC && navVC.navigationBar.superview && !navVC.navigationBar.translucent) {
            targetView = navVC.navigationBar.superview;
        } else {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            targetView = window;
        }
    }
    
    if (targetView) {
        NSEnumerator *subviewsEnum = [targetView.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:[AFMInfoBanner class]]) {
                return (AFMInfoBanner *)subview;
            }
        }
    }
    
    return nil;
}

+ (UINavigationBar *)navigationBarFor:(UIViewController *)viewController
{
    for (UIView *view in viewController.view.subviews) {
        if ([view isKindOfClass:[UINavigationBar class]]) {
            return (UINavigationBar *)view;
        }
    }
    
    return nil;
}

+ (void)hideAllTipInfoTop
{
    [AFMInfoBanner hideAll];
}

#pragma mark - 时间转换

+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate
{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString formate:(NSString *)formate
{
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)formateTime:(NSString *)timeStr
{
    NSString *srcStr = FMT_STR(@"%@", timeStr);
        //  判断是否空字符串
    if ([srcStr isNilObj]) {
        return @"--";
    }
    
        //  剔除字符串中的特殊字符
    NSString *srcStrWithNoSign = srcStr;
    if ([srcStr rangeOfString:@"/" options:NSLiteralSearch].location != NSNotFound) {
            //  如果源数据有'/' 去掉
        srcStrWithNoSign = [srcStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
    } else if ([srcStr rangeOfString:@"-" options:NSLiteralSearch].location != NSNotFound) {
            //  如果源数据有'-' 去掉
        srcStrWithNoSign = [srcStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
        //  重新组装时间串
    NSString *retStr = srcStrWithNoSign;
    if (srcStrWithNoSign.length == 8) {
        NSString *year = [srcStrWithNoSign substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [srcStrWithNoSign substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [srcStrWithNoSign substringWithRange:NSMakeRange(6, 2)];
        
        retStr = [year stringByAppendingFormat:@"-%@-%@", month, day];
    } else {
        retStr = srcStr;
    }
    
    return retStr;
}

+ (NSString *)strCurrentTimeFormateYYMM
{
    //  实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //  设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    //  用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDateStr;
}

+ (NSString *)strTimeIntervalSince1970
{
    long long timeInterval = (long long)[NSDate date].timeIntervalSince1970 * 1000;
    NSString *timestampStr = FMT_STR(@"%lld", timeInterval);
    
    return timestampStr;
}

#pragma mark - UUID

+ (NSString *)UUIDWithKeyChain
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"GJFax_UUID" accessGroup:nil];
    
    NSString *uuid = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    if (uuid && [uuid length] > 0) {
        return uuid;
    } else {
        uuid = [[self class] uuid];
        if (uuid) {
            [wrapper setObject:uuid forKey:(__bridge id)kSecAttrAccount];
        }
        
        return uuid;
    }
}

+ (NSString*)uuid
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

#pragma mark - appVersion

+ (NSString *)appVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    return appVersion;
}

#pragma mark - 手机型号

+ (NSString *)deviceType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark -- 返回特定页面处理
/*
 *  返回特定的页面 【倒数】
 *  count     返回的倒数第几个VC, eg：当前页面为0，前一个页面为1
 *  fail      返回失败，返回页面处理
 */
+ (void)backToSpecificVC:(UINavigationController *)navi SpecificCount:(NSInteger)count fail:(void (^)(void))fail
{
    count++;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSInteger MaxCount = navi.viewControllers.count;
        if (MaxCount >= count && count > 0) {
            [navi popToViewController:navi.viewControllers[MaxCount - count]
                             animated:YES];
        }else {
            if (fail) {
                fail();
            }
        }
    }];
}

/*
 *  返回特定的页面 顺数
 *  count     返回的顺数第几个VC, eg：从第0页为第一页
 *  fail      返回失败，返回页面处理
 */
+ (void)backToSpecificVCWithOrder:(UINavigationController *)navi SpecificCount:(NSInteger)count fail:(void (^)(void))fail
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSInteger MaxCount = navi.viewControllers.count;
        if (MaxCount > count && count >= 0) {
            [navi popToViewController:navi.viewControllers[count]
                             animated:NO];
        }else {
            if (fail) {
                fail();
            }
        }
    }];
}


/**
 *  返回指定的页面
 *
 *  @param navi 当前navigationController
 *  @param name 返回的控制器类名
 *  @param fail 返回失败，返回页面处理
 */
+ (void)backToSpecificVCWithOrder:(UINavigationController *)navi SpecificName:(NSString *)name fail:(void (^)(void))fail
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSInteger index = 0;
        for (UIViewController *controller in navi.viewControllers) {
            if ([controller isKindOfClass:[NSClassFromString(name) class]]) {
                [navi popToViewController:controller animated:YES];
                break;
            }
            if (index == navi.viewControllers.count - 1) {
                
                if (fail) {
                    fail();
                }
            }
            index++;
        }
    }];
}

#pragma mark --

UIViewController *GJSTopMostViewController() {
    UIViewController *topViewController = GJSMainWindow().rootViewController;
    UIViewController *temp = nil;
    while (YES) {
        temp = nil;
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            temp = ((UINavigationController *)topViewController).visibleViewController;
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            temp = ((UITabBarController *)topViewController).selectedViewController;
        }
        else if (topViewController.presentedViewController != nil) {
            temp = topViewController.presentedViewController;
        }
        
        if (temp != nil) {
            topViewController = temp;
        } else {
            break;
        }
    }
    return topViewController;
}

UIWindow *GJSMainWindow() {
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    }
    else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}

    //push
void GJSPushViewController (UIViewController *vc,BOOL animated) {
    if (!vc || ![vc isKindOfClass:[UIViewController class]]) return;
        //    vc.hidesBottomBarWhenPushed = YES;
    [GJSTopMostViewController().navigationController pushViewController:vc animated:animated];
}

    //present
void GJSPresentViewController (UIViewController *vc,BOOL animated) {
    if (!vc) return;
   // vc.hidesBottomBarWhenPushed = YES;
    [GJSTopMostViewController().navigationController presentViewController:vc animated:animated completion:^{
        
    }];
}

@end
