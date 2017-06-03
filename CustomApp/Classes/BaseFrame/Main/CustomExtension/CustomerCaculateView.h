//
//  CustomerCaculateView.h
//  HX_GJS
//
//  Created by litao on 15/8/26.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义计算器
 */
@interface CustomerCaculateView : UIView

//  金额说明
@property (nonatomic, weak) UILabel *costDescLb;
@property (nonatomic, weak) UITextField *costTf;
@property (nonatomic, weak) UILabel *termDescLb;
@property (nonatomic, weak) UITextField *termTf;
@property (nonatomic, weak) UILabel *rateDescLb;
@property (nonatomic, weak) UITextField *rateTf;
//  描述
@property (nonatomic, weak) UILabel *incomeDescLb;
@property (nonatomic, weak) UILabel *incomeLb;
//  tip
@property (nonatomic, weak) UILabel *tipLb;

//  投资金额
@property (nonatomic, assign) float costNum;
//  投资期限
@property (nonatomic, assign) int termNum;
//  预期
@property (nonatomic, assign) float rateNum;
//  收益类型
@property (nonatomic, copy) NSString *incomeType;

#pragma mark - 初始化

#pragma mark - 方法
/**
 *  关闭按钮
 */
- (void)dismiss;

/**
 显示
 */
- (void)show;
@end
