    //
    //  CommonMethod.h
    //  HX_GJS
    //
    //  Created by litao on 15/5/5.
    //  Copyright (c) 2015年 ZXH. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFMInfoBanner;

@interface CommonMethod : NSObject

#pragma mark - CATransition动画实现

/**
 *  CATransition动画实现
 *
 *  @param type
 *  @param subtype
 *  @param view
 *  @param duration
 */
+ (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view duration:(CGFloat)duration;

#pragma mark - UIView实现动画

/**
 *  uiview动画实现
 *
 *  @param view
 *  @param transition
 *  @param duration
 */
+ (void)animationWithView:(UIView *)view WithAnimationTransition: (UIViewAnimationTransition)transition duration:(CGFloat)duration;

#pragma mark - 手机容量

/**
 *  总容量
 *
 *  @return 返回byte
 */
+ (NSNumber *)totalDiskSpace;
/**
 *  可用容量
 *
 *  @return 返回byte
 */
+ (NSNumber *)freeDiskSpace;

#pragma mark - 底部选项卡

/**
 *  获取目标索引的tabbar类名
 */
+ (NSString *)classNameWithTabbarIndex:(NSUInteger)tabIndex;

/**
 *  切换选项卡
 */
+ (void)switchTabBar:(int)index;

/**
 *  设置选项卡小红点
 *
 *  @param value
 */
+ (void)setTabbarBadge:(int)itemIndex value:(NSString *)value;

/**
 *  获取选项卡小红点
 *
 *  @param value
 */
+ (int)getTabbarBadge:(int)itemIndex;

/**
 *  返回当前选项卡
 */
+ (int)retCurTabbarIndex;

/*
 *  3DTouch回到首页，会清空navi的子VC
 */
+ (void)goBackHomeWithTabbar;

/*
 *  回到tabbar特定页，会清空navi的子VC
 */
+ (void)goBackHomeWithTabbar:(int)selectIndex;

#pragma mark - tabbar 纯小红点

/*
 *  显示tabbar小红点
 */
+ (void)showTabbarRedPoint:(NSUInteger)itemIndex;

/*
 *  隐藏tabbar小红点
 */
+ (void)hiddenTabbarRedPoint:(NSUInteger)itemIndex;

#pragma mark - 顶部AFM弹出框

/**
 *  顶部弹出信息框
 */
+ (void)showTipInfoTop:(NSString *)str;

/**
 *  隐藏所有弹出信息框
 */
+ (void)hideAllTipInfoTop;

#pragma mark - 时间转换

/**
 *  date 格式化为 string
 *  formate   日期格式  eg:  yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate;

/**
 *  日期转换，string 格式化为 date
 *  formate   日期格式  eg:  yyyy-MM-dd HH:mm:ss
 */
+ (NSDate *)dateFromString:(NSString *)dateString formate:(NSString *)formate;

/**
 *  转换时间
 */
+ (NSString *)formateTime:(NSString *)timeStr;

/**
 *  返回yyyy-MM-dd HH:mm:ss的当前时间
 */
+ (NSString *)strCurrentTimeFormateYYMM;

/**
 *  时间戳 longlong --> NSString类型
 *
 */
+ (NSString *)strTimeIntervalSince1970;

#pragma mark - UUID

/**
 *  从keychain中获取UUID，若无则生成UUID并获取
 *
 */
+ (NSString*)UUIDWithKeyChain;

#pragma mark - appVersion

/**
 *  获取项目版本号
 *
 */
+ (NSString *)appVersion;

#pragma mark - 手机型号
+ (NSString *)deviceType;

#pragma mark -- 返回特定页面处理
/*
 *  返回特定的页面
 *  count     返回的倒数第几个VC eg：当前页面为0，前一个页面为1
 *  fail      返回失败，返回页面处理
 */
+ (void)backToSpecificVC:(UINavigationController *)navi SpecificCount:(NSInteger)count fail:(void (^)(void))fail;

/*
 *  返回特定的页面 顺数
 *  count     返回的倒数第几个VC, eg：当前页面为0，前一个页面为1
 *  fail      返回失败，返回页面处理
 */
+ (void)backToSpecificVCWithOrder:(UINavigationController *)navi SpecificCount:(NSInteger)count fail:(void (^)(void))fail;

/**
 *  返回指定的页面
 *
 *  @param navi 当前navigationController
 *  @param name 返回的控制器类名
 *  @param fail 返回失败，返回页面处理
 */
+ (void)backToSpecificVCWithOrder:(UINavigationController *)navi SpecificName:(NSString*)name fail:(void(^)(void))fail;
#pragma mark --

    //获取当前的window，不一定是keywindow
UIWindow *GJSMainWindow();

    //当前最高一级VC
UIViewController *GJSTopMostViewController();

    //可以任意地方调用这个push，不需要跑回基类VC调用self.navigationController这么麻烦
void GJSPushViewController (UIViewController *vc,BOOL animated);

    //present，同上
void GJSPresentViewController (UIViewController *vc,BOOL animated);

@end
