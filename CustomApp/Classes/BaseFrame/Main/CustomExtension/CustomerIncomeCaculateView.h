//
//  CustomerIncomeCaculateView.h
//  GjFax
//
//  Created by gjfax on 16/9/27.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^jumpMethodBlock)(NSString *moneyStr,NSString *earningsStr);
@interface CustomerIncomeCaculateView : UIView

// 确认购买按钮
@property (nonatomic, weak) UIButton *confirmBuyBtn;
// 输入金额
@property (nonatomic, copy) NSString *inputAmount;
// 预期收入
@property (nonatomic, copy) NSString *expectEarnings;
// 预期收益率
@property (nonatomic, copy) NSString *expectEarningsRate;
// 投资天数
@property (nonatomic, copy) NSNumber *investTerms;
// 确认购买后的方法跳转block
@property (nonatomic, copy) jumpMethodBlock jumpBlock;

// 回调block
- (void)setJumpBlock:(jumpMethodBlock)jumpBlock;

// 关闭
- (void)dismiss;

// 显示
- (void)show;
@end
