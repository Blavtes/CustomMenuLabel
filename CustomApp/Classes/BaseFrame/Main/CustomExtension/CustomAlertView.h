    //
    //  CustomAlertView.h
    //  HX_GJS
    //
    //  Created by litao on 16/2/3.
    //  Copyright © 2016年 GjFax. All rights reserved.
    //

#import <UIKit/UIKit.h>
@class CustomAlertView;
@class CustomTextField;

typedef NS_ENUM(NSInteger, CustomAlertViewTitleType) {
    CustomAlertViewTitleShow = 0,   //  显示titleView
    CustomAlertViewTitleHide        //  隐藏titleView
};

typedef NS_ENUM(NSInteger, CustomAlertViewBtnType) {
    CustomAlertViewBtnDefault = 0,      //  无确认按钮
    CustomAlertViewBtnNormal,           //  单独确认按钮
    CustomAlertViewBtnWithCancel        //  底部左边带取消 右边为确认按钮
};

typedef NS_ENUM(NSInteger, CustomOrderAlertViewType) {
    CustomOrderAlertViewNormal = 0,  //  标准订单弹窗
    CustomOrderAlertViewAuto         //  自动纯数字密码框弹窗
};

typedef void (^ __nullable CancelBlock)(id _Nonnull alertView);
typedef void (^ __nullable ConfirmBlock)(id _Nonnull alertView);

#pragma mark - Base CustomAlertView
/**
 *  项目通用弹出框 - 基类
 */
@interface CustomAlertView : UIView

@property (copy, nonatomic, nullable) NSString *title;

@property (copy, nonatomic, nullable) NSString *confirmBtnTitle;

@property (copy, nonatomic, nullable) NSString *cancelBtnTitle;

@property (assign, nonatomic) CustomAlertViewTitleType titleType;

@property (assign, nonatomic) CustomAlertViewBtnType btnType;

@property (copy, nonatomic, readonly, nonnull) UIView *bgContentView;
@property (copy, nonatomic, readonly, nonnull) UIView *btnContentView;
@property (copy, nonatomic) ConfirmBlock confirmBlock;

@property (weak, nonatomic, nullable) UIButton *cancelBtn;
@property (weak, nonatomic, nullable) UIButton *confirmBtn;

- (CustomAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock;
- (CustomAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)bgHeight;

- (void)show;
- (void)show:(BOOL)isHideShowed;

- (void)dismiss;

+ (void)hideAll;

#pragma mark - 功能跳转信息框
/**
 *  是否使用 干净模式
 */
- (void)changeButtonStyle:(BOOL)clear;

- (UIButton* _Nonnull)getConfirmBtn;
@end

#pragma mark - 功能跳转信息框
/**
 *  功能跳转信息框
 */
typedef void (^ClickBlank)();

@interface CustomAlertViewForFuncJump : CustomAlertView

@property (strong, nonatomic, readwrite, nullable) UILabel *textLabel;

@property (strong, nonatomic, readwrite, nullable) UILabel *detailTextLabel;

@property (nonatomic, copy,nullable) ClickBlank clickBlank;

- (CustomAlertViewForFuncJump * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

@end

#pragma mark - 强提示信息框
/**
 *  强提示信息框
 */
@interface CustomAlertViewForStrongTip : CustomAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *textLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *detailTextLabel;

- (CustomAlertViewForStrongTip * _Nonnull)initWithCancelBlock:(CancelBlock)cancelBlock
                                          withCompletionBlock:(ConfirmBlock)completionBlock;

@end

#pragma mark - 订单信息确认
/**
 *  订单信息确认
 */
@interface CustomAlertViewForOrderInfo : CustomAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *orderTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *orderTextLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *costTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *costTextLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *payTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *payTextLabel;

@property (strong, nonatomic, readonly, nullable) CustomTextField *payPwdTf;

@property (assign, nonatomic, readonly) CustomOrderAlertViewType orderType;

- (CustomAlertViewForOrderInfo * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock;
@end

#pragma mark - 需发送短信验证码确认类
/**
 *  需发送短信验证码确认类
 */
@interface CustomAlertViewForMsgConfirm : CustomAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *orderTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *orderTextLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *msgSendDescTextLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *postCodeDescTextLabel;
@property (strong, nonatomic, readonly, nullable) CustomTextField *phoneCodeTf;
@property (strong, nonatomic, readonly, nullable) CustomTextField *payPwdTf;
@property (nonatomic, strong, readonly, nullable) UIView *phoneCodeBg;
@property (assign, nonatomic) PhoneCodeType msgType;

//  默认是账号手机
@property (nonatomic , copy , nullable) NSString       *reservedPhone; //预留手机号码

- (CustomAlertViewForMsgConfirm * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

@end

#pragma mark - 邀请码类型
/**
 *  邀请码类型
 */
@interface CustomAlertViewForInviteCode  : CustomAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *orderTextDescLabel;

@property (strong, nonatomic, readonly, nullable) CustomTextField *codeTf;

- (CustomAlertViewForInviteCode * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

@end

#pragma mark - 需发送短信验证码确认类
/**
 *  需发送单独短信验证码确认类
 */
@interface CustomAlertViewForSingleMsgConfirm : CustomAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *postNoticeLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *postCodeDescTextLabel;
@property (strong, nonatomic, readonly, nullable) CustomTextField *phoneCodeTf;

@property (assign, nonatomic) PhoneCodeType msgType;

- (CustomAlertViewForSingleMsgConfirm * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

@end


/**
 基金 弹出提示框
 
 - returns:
 */

@interface CustomAlertViewForFundFuncJump : CustomAlertViewForFuncJump

- (CustomAlertViewForFundFuncJump * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;
@end

#pragma mark - 广金券信息框
/**
 *  广金券信息框提示
 */
@interface CustomAlertViewForGJSTicket : CustomAlertViewForFuncJump

- (CustomAlertViewForGJSTicket * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

@end
