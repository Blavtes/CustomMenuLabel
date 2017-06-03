//
//  ChargeCashPayPWDAlertView.h
//  HX_GJS
//
//  Created by gjfax on 16/3/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//


#pragma mark - Base CustomAlertView
/**
 *  项目通用弹出框 - 基类
 */
@interface CustomPWDAlertView : UIView

@property (copy, nonatomic, nullable) NSString *title;

@property (copy, nonatomic, nullable) NSString *confirmBtnTitle;

@property (copy, nonatomic, nullable) NSString *cancelBtnTitle;

@property (assign, nonatomic) CustomAlertViewTitleType titleType;

@property (assign, nonatomic) CustomAlertViewBtnType btnType;

@property (copy, nonatomic, readonly, nonnull) UIView *bgContentView;

@property (copy, nonatomic) ConfirmBlock confirmBlock;

@property (weak, nonatomic, nullable) UIButton *cancelBtn;
@property (weak, nonatomic, nullable) UIButton *confirmBtn;

- (CustomPWDAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock;

/**
 *  密码框
 *
 *  @param orderType       密码框类型
 *  @param completionBlock completionBlock
 *  @param heigt           键盘以上除去透明高度
 *  @param offsetWidth     默认20宽度偏移
 *
 *  @return return value description
 */
- (CustomPWDAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)bgHeight;

/**
 *  密码框
 *
 *  @param orderType       密码框类型
 *  @param completionBlock completionBlock
 *  @param heigt           键盘以上除去透明高度
 *  @param offsetWidth     宽度偏移
 *
 *  @return return value description
 */
- (CustomPWDAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)bgHeight withOffSetBgWidth:(CGFloat)width;

- (void)show;
- (void)show:(BOOL)isHideShowed;

- (void)dismiss;

+ (void)hideAll;

- (void)hideBackgroundAlpha;

- (void)showBackgroundAlpha;

- (void)disableConfirmBtn:(BOOL)isDisable;
@end

/**
 *  基金申购类
 */
@interface ChargeCashPayPWDAlertView : CustomPWDAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *moneyTipsLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *moneyLabel;

@property (strong, nonatomic, readonly, nullable) CustomTextField *payPwdTf;

@property (assign, nonatomic, readonly) CustomOrderAlertViewType orderType;
@property (strong, nonatomic, nullable) NSMutableArray *dotForPasswordIndicatorArrary;


- (ChargeCashPayPWDAlertView * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock;

/*
 *  密码输入框高度调整
 */
- (ChargeCashPayPWDAlertView * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)heigt;

/**
 *  密码框
 *
 *  @param orderType       密码框类型
 *  @param completionBlock completionBlock
 *  @param heigt           键盘以上除去透明高度
 *  @param offsetWidth     宽度偏移
 *
 *  @return return value description
 */
- (ChargeCashPayPWDAlertView * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)heigt withOffSetBgWidth:(CGFloat)offsetWidth;

- (void)configOrderInfoView;

- (void)showBackgroundAlpha;
@end


#pragma mark - 需发送短信验证码确认类
/**
 *  需发送短信验证码确认类
 */
@interface CustomPWDAlertViewForMsgConfirm : CustomPWDAlertView

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
    //  弹框类型
@property (assign, nonatomic, readonly) CustomOrderAlertViewType orderType;

//- (CustomPWDAlertViewForMsgConfirm * _Nonnull)initWithCompletionBlock:(ConfirmBlock _Nullable)completionBlock;
- (CustomPWDAlertViewForMsgConfirm * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock _Nullable)completionBlock;

- (void)showBackgroundAlpha;
- (void)hideBackgroundAlpha;
@end

#pragma mark - 订单信息确认
/**
 *  订单信息确认
 */
@interface CustomPWDAlertViewForOrderInfo : CustomPWDAlertView

@property (strong, nonatomic, readonly, nullable) UILabel *orderTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *orderTextLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *costTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *costTextLabel;

@property (strong, nonatomic, readonly, nullable) UILabel *payTextDescLabel;
@property (strong, nonatomic, readonly, nullable) UILabel *payTextLabel;

@property (strong, nonatomic, readonly, nullable) CustomTextField *payPwdTf;

@property (assign, nonatomic, readonly) CustomOrderAlertViewType orderType;

- (CustomPWDAlertViewForOrderInfo * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock;

- (void)showBackgroundAlpha;
@end
