//
//  BadgeTool.h
//  HX_GJS
//
//  Created by litao on 15/9/17.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - 小红点类型枚举
/**
 *  小红点类别枚举 - bool型
 */
typedef enum
{
    isShowNewsCenterType = 0,   //系统公告的红点是否显示
    isShowNewInfomationType,    //新闻动态的红点是否显示
    isShowActCenterType,        //活动中心的红点是否显示
    isShowMoreTabbarType,        //更多模块标签是否显示红点
    isShowSignInfo             //是否显示签到
} BadgeTypeForBool;

/**
 *  小红点类别枚举 - value型
 */
typedef enum
{
    UserCenterType = 0,    //用户中心
    UnOpenRewardType,      //用户中心 - 未拆奖励
    SignEarnIntegral,       //签到赚积分
}BadgeTypeForValue;
#pragma mark - 小红点工具类
/**
 *  小红点专用工具类 - 专门处理小红点相关信息 - 单例
 */
@interface BadgeTool : NSObject
/**
 *  单例对象
 *
 *  @return
 */
+ (instancetype)sharedInstance;

@property (nonatomic ,strong)NSUserDefaults *latestDateUserDefaults;

#pragma mark - 方法
- (void)reqBadgeInfo;

/**
 *  保存小红点信息 - 是否显示
 *
 *  @param infoObj
 *  @param keyBadgeType
 */
- (void)setBadgeIsShow:(BOOL)isShow keyBadgeType:(BadgeTypeForBool)keyBadgeType;

/**
 *  获取是否显示小红点信息 - 是否显示
 *
 *  @param keyBadgeType
 *
 *  @return
 */
- (BOOL)getIsShowBadgeWithType:(BadgeTypeForBool)keyBadgeType;

/**
 *  保存小红点信息
 *
 *  @param value
 *  @param badgeType
 */
- (void)setBadgeValue:(NSString *)value keyBadgeType:(BadgeTypeForValue)badgeType;

/**
 *  获取小红点信息
 *
 *  @param badgeType
 *
 *  @return
 */
- (NSString *)getBadgeValueWithType:(BadgeTypeForValue)badgeType;

/**
 * 自定义小红点
 */
+ (UILabel*)redPointLabel:(CGRect)rect;

@end
