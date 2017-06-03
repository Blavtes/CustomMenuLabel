//
//  CommonDefine.h
//
//  Created by 李涛 on 15/4/25.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#ifndef GJS_CommonDefine_h
#define GJS_CommonDefine_h

#pragma mark - 打印弹出信息
//  打印日志
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) nil
#endif

#ifdef DEBUG
#else
#define NSLog(...) {}
#endif

//  提示用户的信息
#define Show_iToast(string) [[[[[iToast sharedToast] makeText:string] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
//#define Show_iToast(string) [[[[iToast makeText:string] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];

/**
 *  格式化字符串
 *
 *  @param format 格式符串
 *  @param ...    参数列表
 *
 *  @return 格式化了的字符串
 */
#define FMT_STR(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]

/**
 *  打印BOOL变量
 *
 *  @param b BOOL变量
 *
 *  @return BOOL变量对应的字符串
 */
#define PRINT_BOOL(b) DLog(@"%@", b ? @"YES" : @"NO")

//  断言
#define LT_Assert(condition) NSAssert(condition, ([NSString stringWithFormat:@"file name = %s ---> function name = %s at line: %d", __FILE__, __FUNCTION__, __LINE__]));

#pragma mark -- 数据校验
/**
 *  安全获取字符串
 */
#define NSStringSafety(obj) \
[obj isKindOfClass:[NSObject class]] ? [NSString stringWithFormat:@"%@",obj] : @""

/**
 *  安全获取字典中的Value
 */
#define ObjectForKeySafety(obj,key) \
[obj isKindOfClass:[NSDictionary class]] && ![[obj objectForKey:key] isKindOfClass:[NSNull class]] ? [obj objectForKey:key]:nil

/**
 *  安全获取数组中的Value
 */
#define ObjectIndexSafety(obj,index) \
[obj isKindOfClass:[NSArray class]] && index < [obj count] && ![[obj objectAtIndex:index] isKindOfClass:[NSNull class]] ? [obj objectAtIndex:index] :nil


#pragma mark - 系统版本 - 语言等
/**
 *  获取当前系统版本
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//  是否高于ios7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

/**
 *  获取当前语言
 */
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark - 判断机型

//  判断是否4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height >= 568.0)

//  宏定义机型判断
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//  判断是否 Retina-4s屏、iphone5、iPad等
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//  设备屏宽
#define IS_WIDESCREEN_5                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                        (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)

//  各型号设备
#define IS_IPOD                                    ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])

#define iPhone5                                (IS_IPHONE && IS_WIDESCREEN_5)

#define iPhone6                                (IS_IPHONE && IS_WIDESCREEN_6)

#define iPhone6Plus                            (IS_IPHONE && IS_WIDESCREEN_6Plus)

#pragma mark - 通用按钮转角 - tvCell高度等 - 导航栏高度等 - 获取屏幕宽度
//  屏幕大小
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MAIN_SCREEN_BOUNDS [UIScreen mainScreen].bounds

//  底部标签栏高度
#define TabbarHeight 49.0f

//  选项卡标签高度
#define TopSwitchHeight 40.0f

//  普通按钮的弧度
#define CommonBtnCornerRadius 3.0f

//  maxSize
#define MAX_SIZE CGSizeMake(MAXFLOAT, MAXFLOAT)

//  状态栏
#define STATUS_BAR_HEIGHT 20
//  navi
#define NAVI_HEIGHT 44

#pragma mark - 网络错误提示文字

//  网络错误和通用hud信息
#define NORMAL_HUD_STATE_STR @"正在拼命加载中.."
#define NORMAL_HUD_ERROR_STR @"网络连接错误,请稍候再试!"
#define COMMON_NO_NETWORK @"当前无网络,请开启后再试!"
#define NET_ERROR_1001 @"请求超时"
#define NET_ERROR_1002 @"不支持的请求"
#define NET_ERROR_1003 @"找不到服务器或主机名"
#define NET_ERROR_1004 @"当前网络不可用"
#define NET_ERROR_1005 @"网络连接已丢失"
#define NET_ERROR_1009 @"当前网络不可用"

#define DEFAULT_NO_NETWORK_TOP_TIP @"世界上最遥远的距离就是没网.请连接网络!"

#pragma mark - 选项卡索引 - 平台
//  选项卡id
#define HOME_INDEX 0
#define PRODUCT_INDEX 1
#define USERCENTER_INDEX 2
#define MORE_INDEX 3

#pragma mark - 常量
//  Label高度
static CGFloat const CommonLbHeight = 30.0f;

//  按钮转角
static CGFloat const kCommonBtnRad = 3.0f;

static CGFloat const kCommonBtnHeight = 40.0f;

//  tableView里面近似0
static CGFloat const kTableViewHeightZero = 0.0001f;
//  table cell头高度
static CGFloat const kTableViewHeaderHeightSmall = 3.0f;
//  标准footer间隔
static CGFloat const kTableViewFooterHeight = 10.0f;
//  标准headerer间隔
static CGFloat const kTableViewHeaderHeight = 40.0f;
//  普通table cell头高度
static CGFloat const kTableViewCellHeightNormal = 50.0f;
//  产品table cell高度
static CGFloat const kProductTableViewCellHeight = 90.0f;
//  产品table cell高度 - 业务专区图片专用
static CGFloat const kProductTableViewCellHeightForBusiness = 110.0f;
//  短信倒计时时间
static int const kCommonTimeOut = 60;


#endif
