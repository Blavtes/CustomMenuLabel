//
//  CustomTextField.h
//
//  Created by litao on 15/7/30.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SafeKeyBoardField.h"

typedef NS_ENUM(NSUInteger, CustomTextFieldType) {
    //  默认不监听长度 - 即不做限制
    CustomTextFieldTypeDefault   = 0,
    //  验证码限制为6位
    CustomTextFieldTypePhoneCode = 6,
    //  新类型纯数字交易密码(使用的时候7-1)
    CustomTextFieldTypeNewPayPwd = 7,
    //  电话号码限制为11位
    CustomTextFieldTypePhoneNo   = 11,
    //  普通密码限制为16位
    CustomTextFieldTypePassword  = 16,
    //  邀请码长度
    CustomTextFieldTypeInviteCode = 20
};

typedef NS_ENUM(NSUInteger,CustomTextFieldVerifyType) {
        //默认 输入不做作 验证
    CustomTextFieldVerifyTypeDefault        = 0,
    CustomTextFieldVerifyTypePhone          = 1, //是否使用 手机号 344 规则
    CustomTextFieldVerifyTypeIdentityCard   = 2,  //是否使用 身份证 6 4 4 4 ->18 位 规则
    CustomTextFieldVerifyTypeBankCard       = 3  //是否使用 银行卡 4 4 4 4 4 最长19 最短16 规则
};

/**
 *** note message ***
 *  格式化必须开启长度监听
 *  必须设置 [isLimitLength] [curTextFieldVerifyType] [curTextFieldType] 字段
 *  手机号 3 4 4
 *  银行卡 4 4 4 4 4 最长19 最短16
 *  身份证 6 4 4 4     18 位
 *
 *  自定义textField
 */

@interface CustomTextField : SafeKeyBoardField

    //显示类型
@property (nonatomic, assign) CustomTextFieldVerifyType curTextFieldVerifyType;

    //使用手机号、银行卡规则 etc. 过滤之后的内容 context
@property (nonatomic ,strong) NSString *textFieldContent;
     
//  是否开启长度监听
@property (nonatomic, assign, getter=getIsLimitLength) BOOL isLimitLength;

//  当前输入框使用类型
@property (nonatomic, assign, getter=getCurTextFieldType) CustomTextFieldType curTextFieldType;

/**
 *  初始化一个带左侧icon的tf
 *
 *  @param frame
 *  @param icon
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
             withLeftIconView:(UIView *)iconView;

- (instancetype)initWithFrame:(CGRect)frame
            withRightIconView:(UIView *)rightIconView;

- (instancetype)initWithFrame:(CGRect)frame
             withLeftIconView:(UIView *)leftIconView
            withRightIconView:(UIView *)rightIconView;
@end
