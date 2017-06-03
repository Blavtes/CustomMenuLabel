//
//  NoDataOrNetworkView.h
//  YiYunMi
//
//  Created by litao on 15/9/8.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  产品收益类型
 */
typedef NS_ENUM(NSUInteger, CustomerTipType)
{
    NoDataType = 0,    // 无数据信息
    NoProductType,     // 无产品信息
    NoNetworkType,     // 无网络
    NoInvestRecord,    // 无投资记录
    NoTransferProduct, // 无转让产品
    NoSearchDataType,  // 无搜索结果类型
    NoDateNoTap,       // 无记录不能点击刷新
    NoGJSTicket,       // 您当前暂无任何广金券
    NoExchangeTicket,   // 暂无可供兑换的广金券
    
    //Tab账户     --  我的定期
    NoFixInvestType,                 //我的定期
    NoFixInvestRecondType,           //投资记录
    NoFixTransferRecordType,         //转让记录
    NoFixListRecordType,             //历史收款
    //           --  我的活期
    NoCurrentInvestType,             //我的活期页面
    NoCurrentListRecordType,         //活期交易记录
    //           --  我的基金
    NoFundInvestType,                //我的基金
    NoFundRecordType,                //交易记录
    //           --  我的保险
    NoInsuranceHoldingType,          //持有中
    NoInsuranceSurrenderingType,     //退保中
    NoInsuranceSurrenderedType,      //已退保
    //           --  我的转让
    NoCanTransferType,               //可转让
    NoTransferingType,               //转让中
    NoTransferedType,                //已转让
    NoTransferRecordType,            //转让记录
    //           --  活动奖励
    NoActivityRewardType,            //待拆奖励
    NoMyGJSCoinType,                 //我的广金币
    NoMyGJSScoreType,                //积分详情
    NoMyGJSRedPacketType,            //我的红包
    NoMyPropsViewType,               //我的道具
    NoMyMatterRewardType,            //实物奖励
    NoRewardRecordType,              //奖励记录
    //           --  我的推荐
    NoMyRecommendType,               //我的推荐界面
    //           --  可用资金
    NoAssetRecordType,               //资金记录
    //Tab更多
    NoActivityCenter,                //活动中心
    NoCompanyNews,                   //公司动态
    NoNewsCenter                     //消息中心
};

/**
 用于所有没有数据、网络   -   提示
 */

/** 触摸描述的回调 */
typedef void (^TouchTipBlock)();

@interface NoDataOrNetworkView : UIView
#pragma mark - 可变属性
//  设置是否点击描述信息重新加载
@property (nonatomic, assign, getter=isTouchRemove) BOOL isTouchRemove;


#pragma mark - 基类方法
/**
 *  自定义一个view - 默认填充整个屏幕,
 */
- (instancetype)initWithFrame:(CGRect)frame
                  imageString:(NSString *)imageString
                   tipsString:(NSString *)tipsString;


#pragma mark - 初始化view
/**
 *  初始化一个view - 默认填充整个屏幕
 */
- (instancetype)initWithTipType:(CustomerTipType)tipType;

/**
 *  初始化一个view
 */
- (instancetype)initWithFrame:(CGRect)frame tipType:(CustomerTipType)tipType ;

/**
 *  初始化一个view - 默认填充整个屏幕 - block
 */
- (instancetype)initWithTipType:(CustomerTipType)tipType touchTipBlock:(TouchTipBlock)touchTipBlock;

/**
 *  初始化一个view - block
 */
- (instancetype)initWithFrame:(CGRect)frame tipType:(CustomerTipType)tipType touchTipBlock:(TouchTipBlock)touchTipBlock;

#pragma mark - 类方法
/**
 *  显示一个无数据提示页面
 */
+ (instancetype)showTipView:(CustomerTipType)tipType view:(UIView *)view touchTipBlock:(TouchTipBlock)touchTipBlock;

/**
 *  显示一个无数据提示页面, etc.view hidden nav 
 */
+ (instancetype)showTipView:(CustomerTipType)tipType view:(UIView *)view viewFrame:(CGRect)frame touchTipBlock:(TouchTipBlock)touchTipBlock;
#pragma mark - 移除view
/**
 *  移除提示页面
 */
+ (void)hideTipView:(UIView *)view;
@end
