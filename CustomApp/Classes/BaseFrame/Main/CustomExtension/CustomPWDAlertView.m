//
//  ChargeCashPayPWDAlertView.m
//  HX_GJS
//
//  Created by gjfax on 16/3/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomPWDAlertView.h"
#import "CustomTextField.h"
#import "PhoneCodeViewModel.h"

static const CGFloat kAutoOrderAlertViewContentHeight = 150.f;
//static const CGFloat kNormalOrderAlertViewContentHeight = 200.0f;
static const CGFloat kNormalOrderAlertViewContentHeight = 250.0f;
static const CGFloat kRowHeight = 40.0f;
static const CGFloat kSpaceFloat = 20.0f;
static const NSInteger kAutoPwdLenght = 6;

static const CGFloat kNormalAlertViewContentHeight = 180.0f;
static const CGFloat kNormalPWDAlertViewContentHeight = 200.0f;
static const CGFloat kSafeKeyBoardHeight = 276.0f;

#pragma mark - 基类弹框

@interface CustomPWDAlertView() <UITextFieldDelegate> {
        //  ..
}

    //  背景view
@property (weak, nonatomic) UIView *bgView;

@property (copy, nonatomic) CancelBlock cancelBlock;

@property (weak, nonatomic) UIView *titleView;
@property (nonatomic, weak) UIButton *dismissBtn;
@property (nonatomic, weak) UILabel *titleLb;

@property (weak, nonatomic) UIView *btnView;
@property (strong, nonatomic) PhoneCodeViewModel *phoneCodeViewModel;

@property (weak, nonatomic) UIView *lineViewHor;
@property (weak, nonatomic) UIView *lineViewVec;

@end

@implementation CustomPWDAlertView

#pragma mark - setter & getter

- (void)setTitle:(NSString * __nullable)title
{
    _titleLb.text = title;
}
- (PhoneCodeViewModel *)phoneCodeViewModel
{
    if (_phoneCodeViewModel) {
        return _phoneCodeViewModel;
    }
    
    _phoneCodeViewModel = [[PhoneCodeViewModel alloc] init];
    
    return _phoneCodeViewModel;
}
- (void)setConfirmBtnTitle:(NSString * __nullable)confirmBtnTitle
{
    [_confirmBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];
    [_confirmBtn setTitle:confirmBtnTitle forState:UIControlStateHighlighted];
}

- (void)setCancelBtnTitle:(NSString * __nullable)cancelBtnTitle
{
    [_cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [_cancelBtn setTitle:cancelBtnTitle forState:UIControlStateHighlighted];
}

- (void)setTitleType:(CustomAlertViewTitleType)titleType
{
    if (CustomAlertViewTitleHide == titleType) {
        _titleView.hidden = YES;
    } else {
        _titleView.hidden = NO;
    }
    
    _titleType = titleType;
}

- (void)setBtnType:(CustomAlertViewBtnType)btnType
{
    [self configBtnWithType:btnType];
    
    _btnType = btnType;
}

- (UIView *)bgContentView
{
    return _bgView;
}

#pragma mark - init

- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [self initWithCompletionBlock:completionBlock withBgHeight:kNormalAlertViewContentHeight];
    
    if (self) {
            //
    }
    
    return self;
}

- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)bgHeight
{
    self = [super initWithFrame:MAIN_SCREEN_BOUNDS];
    
    if (self) {
        [self initBaseViewWithBgHeight:bgHeight offSetBgWidth:kSpaceFloat bgMasks:YES];
        
        _confirmBlock = completionBlock;
        
        [self configTitleView];
        
        [self configBtnView];
    }
    
    return self;
}

- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)bgHeight withOffSetBgWidth:(CGFloat)offsetWidth
{
    self = [super initWithFrame:MAIN_SCREEN_BOUNDS];
    
    if (self) {
        [self initBaseViewWithBgHeight:bgHeight offSetBgWidth:offsetWidth bgMasks:NO];
        _confirmBlock = completionBlock;
        
        [self configTitleView];
        
        [self configBtnView];
    }
    
    return self;
}

/**
 *  Description
 *
 *  @param bgHeight    bgHeight description
 *  @param offsetWidth offsetWidth description
 *  @param masks       圆角
 */
- (void)initBaseViewWithBgHeight:(CGFloat)bgHeight offSetBgWidth:(CGFloat)offsetWidth bgMasks:(BOOL)masks
{
        //  基础属性
    self.backgroundColor = [UIColor colorWithWhite:0.35f alpha:0.5f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
    [self addGestureRecognizer:tap];
    
        //  背景 键盘276
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(offsetWidth / 2, (MAIN_SCREEN_HEIGHT - bgHeight + kSpaceFloat * 4.2 - kSafeKeyBoardHeight - kNormalAlertViewContentHeight / 2), MAIN_SCREEN_WIDTH - offsetWidth, bgHeight)];
    bgView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    
    DLog(@"bg %f", (MAIN_SCREEN_HEIGHT - bgHeight - kSafeKeyBoardHeight));
    if (masks) {
        bgView.layer.cornerRadius = 6.0f;
        bgView.layer.masksToBounds = YES;
    }
    [self addSubview:bgView];
    _bgView = bgView;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(offsetWidth / 2, (bgHeight), MAIN_SCREEN_WIDTH - offsetWidth, kSafeKeyBoardHeight * 1.5)];
    bottomView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    [bgView addSubview:bottomView];
//    __block UIView *view = bgView;
    
#pragma mark --- show view animate--
    CGRect frame = bgView.frame;
    frame.origin.y += kSafeKeyBoardHeight + bgHeight;
    bgView.frame = frame;
    
    [UIView animateWithDuration:0.3f animations:^{
          CGRect frame = bgView.frame;
        frame.origin.y -=  (kSafeKeyBoardHeight + bgHeight);
        bgView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideBackgroundAlpha
{
    self.backgroundColor = [UIColor clearColor];
    self.bgContentView.backgroundColor = COMMON_WHITE_COLOR;
}

- (void)showBackgroundAlpha
{
    self.backgroundColor = [UIColor colorWithWhite:0.35f alpha:0.5f];
    self.bgContentView.backgroundColor = COMMON_GREY_WHITE_COLOR;
}

- (void)disableConfirmBtn:(BOOL)isDisable
{
//    if (!isDisable) {
//        _confirmBtn.alpha = 0.4f;
//    } else {
//        _confirmBtn.alpha = 1.0f;
//    }
    _confirmBtn.enabled = isDisable;
}

- (void)configTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kRowHeight)];
    titleView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:titleView];
    _titleView = titleView;
    
        //  标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(kRowHeight, kSpaceFloat * .4f, _bgView.frame.size.width - kRowHeight * 2.0f, CommonLbHeight)];
    titleLb.textColor = COMMON_BLACK_COLOR;
    titleLb.text = @"温馨提示";
    titleLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLb];
    _titleLb = titleLb;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kRowHeight, _bgView.frame.size.width, .5f)];
    lineView.backgroundColor = COMMON_GREY_COLOR;
    lineView.alpha = .5f;
    [titleView addSubview:lineView];
    
        //  关闭按钮
    UIButton *dismissBtn = [[UIButton alloc] init];
    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"common_close_selected"] forState:UIControlStateNormal];
    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"common_close_selected"] forState:UIControlStateHighlighted];
    dismissBtn.size = dismissBtn.currentBackgroundImage.size;
    dismissBtn.frame = CGRectMake(_bgView.width - dismissBtn.size.width - kSpaceFloat * .5f, kSpaceFloat * .4f, dismissBtn.size.width, dismissBtn.size.height);
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissBtn];
    _dismissBtn = dismissBtn;
}

- (void)configBtnView
{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgView.height - kRowHeight - kSpaceFloat, _bgView.width, kRowHeight + kSpaceFloat)];
    btnView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:btnView];
    _btnView = btnView;
    
//    UIButton *cancelBtn = [UIButton btnWithTitle:@"取消" rect:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width * .5f - kSpaceFloat * 2.0f, kRowHeight) taget:self action:@selector(cancel)];
//    cancelBtn.hidden = YES;
//    [btnView addSubview:cancelBtn];
//    _cancelBtn = cancelBtn;
    
    CustomFirstRateButton *cancelBtn = [[CustomFirstRateButton alloc] initWithFrame:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width * .5f - kSpaceFloat * 2.0f, kRowHeight) title:@"取消" cornerRadius:YES];
    [btnView addSubview:cancelBtn];
    cancelBtn.hidden = YES;
    cancelBtn.clickHandle = ^(UIButton *btn) {
        [self cancel];
    };
    self.cancelBtn = cancelBtn;
    
//    UIButton *confirmBtn = [UIButton btnWithTitle:@"确认" rect:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width - kSpaceFloat * 2.0f, kRowHeight) taget:self action:@selector(completion)];
//    [btnView addSubview:confirmBtn];
//    _confirmBtn = confirmBtn;
    
    CustomFirstRateButton *confirmBtn = [[CustomFirstRateButton alloc] initWithFrame:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width - kSpaceFloat * 2.0f, kRowHeight) title:@"确认" cornerRadius:YES];
    [btnView addSubview:confirmBtn];
    confirmBtn.clickHandle = ^(UIButton *btn) {
        [self completion];
    };
    //防重复 点击确认之后不可以 ，同时 回调中 confirmBtn 状态不设置（或设为 enable = NO
//    confirmBtn.isResetState = NO;

    self.confirmBtn = confirmBtn;

        //  4s或者5系列手机改变按钮文字大小
    if (isRetina || iPhone5) {
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    }
    
    UIView *lineViewHor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnView.width, 1.0f)];
    lineViewHor.backgroundColor = COMMON_GREY_COLOR;
    lineViewHor.hidden = YES;
    [btnView addSubview:lineViewHor];
    _lineViewHor = lineViewHor;
    
    UIView *lineViewVec = [[UIView alloc] initWithFrame:CGRectMake(btnView.width * .5f - .25f, 0, .5f, btnView.height)];
    lineViewVec.backgroundColor = COMMON_GREY_COLOR;
    lineViewVec.hidden = YES;
    [btnView addSubview:lineViewVec];
    _lineViewVec = lineViewVec;
}

- (void)configBtnWithType:(CustomAlertViewBtnType)btnType
{
    switch (btnType) {
        case CustomAlertViewBtnDefault:
        {
        _btnView.hidden = YES;
        }
            break;
            
        case CustomAlertViewBtnNormal:
        {
        _btnView.hidden = NO;
        _cancelBtn.hidden = YES;
        
        _lineViewHor.hidden = YES;
        _lineViewVec.hidden = YES;
        }
            break;
            
        case CustomAlertViewBtnWithCancel:
        {
        _btnView.hidden = NO;
        
        _cancelBtn.hidden = NO;
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
        
        _confirmBtn.frame = CGRectMake(_btnView.width * .5f + kSpaceFloat, kSpaceFloat * .5f, _btnView.width * .5f - kSpaceFloat * 2.0f, kRowHeight);
        _confirmBtn.backgroundColor = [UIColor clearColor];
        [_confirmBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
        
        _lineViewHor.hidden = NO;
        _lineViewVec.hidden = NO;
        }
            break;
    }
}

#pragma mark - 显示隐藏

- (void)show
{
    [self show:YES];
}

- (void)show:(BOOL)isHideShowed
{
        //[[[UIApplication sharedApplication].delegate window] addSubview:self];
        //  判断是否有弹出框已经显示了 且 想移除掉所有已存在的再显示
    if (isHideShowed && [self isAnyAlertViewShowed]) {
        [CustomPWDAlertView hideAll];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismiss
{
    if (self) {
        [UIView animateWithDuration:0.3f animations:^{
            [self endEditing:YES];
            CGRect frame = _bgView.frame;
            frame.origin.y = + MAIN_SCREEN_HEIGHT;
            _bgView.frame = frame;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
        
    }
}

- (BOOL)isAnyAlertViewShowed
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    for (CustomPWDAlertView *subview in window.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)hideAll;
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self hideAllInView:window];
}

+ (void)hideAllInView:(UIView *)view
{
    for (CustomPWDAlertView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            [subview dismiss];
        }
    }
}

- (void)completion
{
    if (_confirmBlock) {
        _confirmBlock(self);
    }
}

- (void)cancel
{
    if (_cancelBlock) {
        _cancelBlock(self);
    }
}

#pragma mark - textField delegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//        //  视图上移
//    [UIView animateWithDuration:.3f animations:^{
//        CGRect frame = self.frame;
//        frame.origin.y = -90;
//        self.frame = frame;
//    }];
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//        //  视图恢复
//    [UIView animateWithDuration:.3f animations:^{
//        CGRect frame = self.frame;
//        frame.origin.y = 0;
//        self.frame = frame;
//    }];
//    
//    return YES;
//}

@end

#pragma mark - 强提示信息框

@interface ChargeCashPayPWDAlertView () <UITextFieldDelegate> {
    //  是否输入完成
    BOOL _isAutoComplete;
    //  是否点击了关闭按钮
    BOOL _isTapCloseBtn;
}
@end

@implementation ChargeCashPayPWDAlertView

#pragma mark - init

- (ChargeCashPayPWDAlertView *)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock
{
    if (CustomOrderAlertViewAuto == orderType) {
        return [[ChargeCashPayPWDAlertView alloc] initWithOrderType:orderType withCompletionBlock:completionBlock withBgHeight:kAutoOrderAlertViewContentHeight];
    } else {
        return [[ChargeCashPayPWDAlertView alloc] initWithOrderType:orderType withCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight];
    }
}

- (ChargeCashPayPWDAlertView *)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)heigt
{
    if (CustomOrderAlertViewAuto == orderType) {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:heigt];
        
        self.btnType = CustomAlertViewBtnDefault;
    } else {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:heigt];
    }
    
    _orderType = orderType;
    
    if (self) {
        
        _dotForPasswordIndicatorArrary = [NSMutableArray array];
        _isAutoComplete = NO;
        _isTapCloseBtn = NO;
        
        self.confirmBlock = completionBlock;
        
        [self configOrderInfoView];
    }
    
    return self;
}

- (ChargeCashPayPWDAlertView *)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock withBgHeight:(CGFloat)heigt withOffSetBgWidth:(CGFloat)offsetWidth
{

    if (CustomOrderAlertViewAuto == orderType) {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:heigt withOffSetBgWidth:offsetWidth];
        
        self.btnType = CustomAlertViewBtnDefault;
    } else {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:heigt withOffSetBgWidth:offsetWidth];
    }
    
    _orderType = orderType;
    
    if (self) {
        
        _dotForPasswordIndicatorArrary = [NSMutableArray array];
        _isAutoComplete = NO;
        _isTapCloseBtn = NO;
        
        self.confirmBlock = completionBlock;
        
        [self configOrderInfoView];
    }
    
    return self;
}

- (void)configOrderInfoView
{
    _moneyTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kRowHeight * 1.3f, self.bgContentView.width * .5f, CommonLbHeight)];
    _moneyTipsLabel.textAlignment = 0;
    _moneyTipsLabel.text = @"充值金额（元）";
    _moneyTipsLabel.textColor = COMMON_BLACK_COLOR;
    _moneyTipsLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_moneyTipsLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgContentView.width * .5f + kSpaceFloat * .5f, kRowHeight * 1.3f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    _moneyLabel.text = @"-.-";
    _moneyLabel.textColor = COMMON_ORANGE_COLOR;
    _moneyLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_moneyLabel];
    
    
    _payPwdTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, _moneyLabel.bottom + 10, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    _payPwdTf.isLimitLength = YES;
    _payPwdTf.placeholder = @"请输入交易密码";
    _payPwdTf.delegate = self;
    _payPwdTf.secureTextEntry = YES;
    [_payPwdTf becomeFirstResponder];
    _payPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payPwdTf.curTextFieldType = CustomTextFieldTypePassword;
    [self.bgContentView addSubview:_payPwdTf];
    
    
    if (CustomOrderAlertViewAuto == _orderType) {
        //  数字键盘
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeNumber];
        //  block回调
        [_payPwdTf shouldChangeCharacters:^(SafeKeyBoardField *textField, NSString *string) {
            [self payPwdTfEditingChanged:textField];
        }];
//        _payPwdTf.keyboardType = UIKeyboardTypeNumberPad;
        
        _payPwdTf.hidden = YES;
//        [_payPwdTf addTarget:self action:@selector(payPwdTfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
        //  添加自动填充框
        [self initAutoUI];
        
    } else {
//        _payPwdTf.keyboardType = UIKeyboardTypeDefault;
        [_payPwdTf shouldChangeCharacters:^(SafeKeyBoardField *textField, NSString *string) {
            [self textChanged:textField];
        }];
        [_payPwdTf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        self.confirmBtn.enabled = NO;
        //  普通键盘
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeCharacter];
    }
    // v3.2 使用安全键盘
    _payPwdTf.forbidSpace = YES;
    _payPwdTf.forbidClipboard = YES;
}

- (void)textChanged:(UITextField *)textField
{
    if (_payPwdTf.text.length > 0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}

- (void)dismiss
{
    _isTapCloseBtn = YES;
    [self dismissView];
}

- (void)hideBackgroundAlpha
{
    [super hideBackgroundAlpha];
    [_payPwdTf resignFirstResponder];
}

- (void)showBackgroundAlpha
{
    [super showBackgroundAlpha];
    _payPwdTf.text = @"";
    [self setDotWithCount:0];
    _isAutoComplete = NO;
    [_payPwdTf becomeFirstResponder];
}

- (void)dismissView
{
    if (self) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.bgContentView.frame;
            frame.origin.y = + MAIN_SCREEN_HEIGHT;
            self.bgContentView.frame = frame;
            [_payPwdTf resignFirstResponder];
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
        
    }
}


- (void)initAutoUI
{
    UIView *autoView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat, _moneyLabel.bottom + 10, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    autoView.backgroundColor = COMMON_WHITE_COLOR;
    autoView.layer.cornerRadius = kCommonBtnRad;
    autoView.layer.borderColor = [COMMON_GREY_COLOR CGColor];
    [self.bgContentView addSubview:autoView];
    
    CGFloat sigleDotViewWidth = autoView.width / 6;
    CGFloat sigleDotWidth = sigleDotViewWidth * .25f;
        // 触发弹起键盘
    [autoView GJSHandleClick:^(UIView *view) {
        [_payPwdTf becomeFirstResponder];
    }];
    //  竖线
    for (int idx = 0; idx < kAutoPwdLenght; idx++) {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((idx + 1) * sigleDotViewWidth, 5.0f, .5f, autoView.height - 10.0f)];
        lineImageView.backgroundColor = COMMON_LIGHT_GREY_COLOR;
        [autoView addSubview:lineImageView];
    }
    //  密码标志
    for (int idx = 0; idx < kAutoPwdLenght; idx++) {
        UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((sigleDotViewWidth - sigleDotWidth) * .5f + idx * sigleDotViewWidth, (autoView.height - sigleDotWidth) * .5f, sigleDotWidth, sigleDotWidth)];
        dotImageView.backgroundColor = COMMON_BLACK_COLOR;
        dotImageView.layer.cornerRadius = sigleDotWidth * .5f;
        dotImageView.clipsToBounds = YES;
        dotImageView.hidden = YES;
        [autoView addSubview:dotImageView];
        
        [_dotForPasswordIndicatorArrary addObject:dotImageView];
    }
}

#pragma mark - 字符变更监听
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //  YES则可继续输入，返回NO表示禁止输入
    if ([string isEqualToString:@"\n"]) {
        //  按回车关闭键盘(本场景不启用)
        //[textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //  判断是不是删除键
        return YES;
    } else {
        return YES;
    }
}

#pragma mark - 未完成输入情况下不允许失去焦点
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_isAutoComplete && _orderType == CustomOrderAlertViewAuto && textField == _payPwdTf) {
            //  这里重新获得焦点 再次输入会首先清空已输入的密码
        if (!_isTapCloseBtn) {
            [textField becomeFirstResponder];
        }
    }
}

//  先响应点击事件 --> tf获得焦点 --> 则不会触发tf失去焦点的代理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_orderType == CustomOrderAlertViewAuto) {
        [_payPwdTf becomeFirstResponder];
    }
}

- (void)payPwdTfEditingChanged:(UITextField *)textField
{
    if (_orderType == CustomOrderAlertViewAuto && textField == _payPwdTf) {
        //  显示输入圆点
        [self setDotWithCount:_payPwdTf.text.length];
        //  检测到6位输入则直接出发block回调
        if (_payPwdTf.text.length >= kAutoPwdLenght) {
            _isAutoComplete = YES;
            self.confirmBlock(self);
            _payPwdTf.text = [_payPwdTf.text substringWithRange:NSMakeRange(0, kAutoPwdLenght)];
            //  隐藏键盘
//            [_payPwdTf resignFirstResponder];
        }
    }
}

#pragma mark - 设置密码标志
- (void)setDotWithCount:(NSInteger)count
{
    for (UIImageView *dotImageView in _dotForPasswordIndicatorArrary) {
        dotImageView.hidden = YES;
    }
    
    //  显示密码标志
    for (int idx = 0; idx < count; idx++) {
        ((UIImageView*)[_dotForPasswordIndicatorArrary objectAtIndex:idx]).hidden = NO;
    }
}

@end


#pragma mark - 需发送短信验证码确认类

@interface CustomPWDAlertViewForMsgConfirm () {
        //  倒计时时间
    int _timeOut;
}



@property (strong, nonatomic) UIView *tfRightView;
@property (strong, nonatomic) UIActivityIndicatorView *actIndicatorView;

@end

@implementation CustomPWDAlertViewForMsgConfirm
#pragma mark - Lazy Load


- (void)setMsgType:(PhoneCodeType)msgType
{
    _msgType = msgType;
    
    if (_msgType) {
        [self postCode];
    }
    
}

- (NSString *)reservedPhone
{
    if (!_reservedPhone || [_reservedPhone isNullStr]) {
        
    }
    return _reservedPhone;
}

#pragma mark - init BaseView
    // 带键盘类型
- (CustomPWDAlertViewForMsgConfirm * _Nonnull)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock _Nullable)completionBlock {
    self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight withOffSetBgWidth:0];
    
    _orderType = orderType;
    
    if (self) {
        //  默认倒计时
        _timeOut = kCommonTimeOut;
        
        self.confirmBlock = completionBlock;
        
        [self configMsgView];
    }
    
    return self;
}
    // 不带键盘类型
//- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
//{
//    self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight withOffSetBgWidth:0];
//    
//    if (self) {
//            //  默认倒计时
//        _timeOut = kCommonTimeOut;
//        
//        self.confirmBlock = completionBlock;
//        
//        [self configMsgView];
//    }
//    
//    return self;
//}

- (void)configMsgView
{
    _orderTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.2f, self.bgContentView.width * .5f, CommonLbHeight)];
    _orderTextDescLabel.textAlignment = NSTextAlignmentLeft;
    _orderTextDescLabel.text = @"充值金额（元）";
    _orderTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _orderTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextDescLabel];
    
    CGSize descSize = [_orderTextDescLabel.text strSizeWithFont:kCommonFontSizeDetail_16 maxSize:MAX_SIZE];
    _orderTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(descSize.width + kSpaceFloat, kRowHeight * 1.2f, self.bgContentView.width * .5f, CommonLbHeight)];
    _orderTextLabel.textAlignment = NSTextAlignmentLeft;
    _orderTextLabel.text = @"-.-";
    _orderTextLabel.textColor = COMMON_ORANGE_COLOR;
    _orderTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextLabel];
    
    _msgSendDescTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.8f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _msgSendDescTextLabel.textAlignment = NSTextAlignmentLeft;
    _msgSendDescTextLabel.text = @"验证码已发送到135****345";
    _msgSendDescTextLabel.textColor = COMMON_GREY_COLOR;
    _msgSendDescTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSmall_10];
    _msgSendDescTextLabel.hidden = YES;
    [self.bgContentView addSubview:_msgSendDescTextLabel];
    
    _phoneCodeBg = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 2.6f, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    _phoneCodeBg.backgroundColor = COMMON_WHITE_COLOR;
    _phoneCodeBg.layer.cornerRadius = kCommonBtnRad;
    _phoneCodeBg.layer.masksToBounds = YES;
    [self.bgContentView addSubview:_phoneCodeBg];
    
    _tfRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRowHeight * 2.0f, CommonLbHeight)];
    _tfRightView.backgroundColor = [UIColor clearColor];
    
    _postCodeDescTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(_phoneCodeBg.width - kRowHeight * 2.f, 5, kRowHeight * 2.0f, CommonLbHeight)];
    _postCodeDescTextLabel.textColor = COMMON_BLUE_GREEN_COLOR;
    _postCodeDescTextLabel.text = [NSString stringWithFormat:@"%is",kCommonTimeOut];
    _postCodeDescTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    _postCodeDescTextLabel.textAlignment = NSTextAlignmentCenter;
    _postCodeDescTextLabel.userInteractionEnabled = YES;
    _postCodeDescTextLabel.hidden = YES;
    [_phoneCodeBg addSubview:_postCodeDescTextLabel];
    
    _actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _actIndicatorView.center = _tfRightView.center;
    _actIndicatorView.color = COMMON_BLUE_GREEN_COLOR;
    _actIndicatorView.hidden = YES;
    [_actIndicatorView setHidesWhenStopped:YES];
    [_tfRightView addSubview:_actIndicatorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postCode)];
    [_postCodeDescTextLabel addGestureRecognizer:tap];
    
    CustomTextField *phoneCodeTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 2.6f, self.bgContentView.width - kSpaceFloat - kRowHeight * 2.0f, kRowHeight)];
    phoneCodeTf.isLimitLength = YES;
    phoneCodeTf.placeholder = @"请输入短信验证码";
    phoneCodeTf.delegate = self;
    [phoneCodeTf becomeFirstResponder];
    phoneCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    phoneCodeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneCodeTf.curTextFieldType = CustomTextFieldTypePhoneCode;
    [self.bgContentView addSubview:phoneCodeTf];
    _phoneCodeTf = phoneCodeTf;
    [phoneCodeTf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

    _payPwdTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 3.8f, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    _payPwdTf.isLimitLength = YES;
    _payPwdTf.delegate = self;
    _payPwdTf.secureTextEntry = YES;
    _payPwdTf.keyboardType = UIKeyboardTypeDefault;
    _payPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payPwdTf.curTextFieldType = CustomTextFieldTypePassword;
        // v3.2 使用安全键盘
    if (CustomOrderAlertViewAuto == _orderType) {
        _payPwdTf.placeholder = @"请输入6位数字交易密码";
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeNumber];
        
    } else {
        _payPwdTf.placeholder = @"请输入交易密码";
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeCharacter];
    }
    _payPwdTf.forbidSpace  = YES;
    _payPwdTf.forbidClipboard = YES;
    
    [self.bgContentView addSubview:_payPwdTf];
    
    [_payPwdTf shouldChangeCharacters:^(SafeKeyBoardField *textField, NSString *string) {
        [self textChanged:textField];
    }];
    [_payPwdTf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

    self.confirmBtn.enabled = NO;
}

- (void)textChanged:(UITextField *)textFiled {
    if (_payPwdTf.text.length > 0 && _phoneCodeTf.text.length > 0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}

- (void)showBackgroundAlpha
{
    [super showBackgroundAlpha];
    _payPwdTf.text = @"";
    [_payPwdTf becomeFirstResponder];
}

- (void)hideBackgroundAlpha
{
    [super hideBackgroundAlpha];
    [_payPwdTf resignFirstResponder];
}

#pragma mark - 发送验证码
- (void)postCode
{
   
    [_actIndicatorView startAnimating];
    _postCodeDescTextLabel.hidden = YES;
    __weak __typeof(self) weakSelf = self;
        //  短信校验
    [self.phoneCodeViewModel setReqBlockWithRetValue:^(id returnValue) {
            //  短信发送成功后回调
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ((BOOL)returnValue && strongSelf) {
            [strongSelf.actIndicatorView stopAnimating];
            
            strongSelf.postCodeDescTextLabel.hidden = NO;
            _timeOut = kCommonTimeOut;
            [strongSelf updateCountDownUI];
        }
    } withErrorBlock:^(id errorCode, NSString *errorNote) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.actIndicatorView stopAnimating];
            strongSelf.postCodeDescTextLabel.hidden = NO;
            if ([errorCode isEqualToString:kPhoneCodeTime]) {
                    //  短信太频繁
                _timeOut = (int)[errorNote longLongValue] / 1000;
                [strongSelf updateCountDownUI];
            } else {
                strongSelf.postCodeDescTextLabel.text = @"重发";
                    //  显示下验证码错误信息
                [HttpTool handleErrorCodeFromServer:errorCode withNote:errorNote];
            }
        }
    } withFailureBlock:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.actIndicatorView stopAnimating];
            strongSelf.postCodeDescTextLabel.hidden = NO;
            strongSelf.postCodeDescTextLabel.text = @"重发";
        }
    }];
    
    if (_msgType == PhoneCodeTypeChargeCash || _msgType == PhoneCodeTypeWithdrawCash) {
        [self.phoneCodeViewModel fetchPhoneCodeData:_msgType withNewVersionFlag:YES withAmount:[_orderTextLabel.text formatStrWithSignToNumberStr]];
    } else {
        [self.phoneCodeViewModel fetchPhoneCodeData:_msgType withNewVersionFlag:YES];
    }
}

#pragma mark - 倒计时
- (void)updateCountDownUI
{
    NSString *sendDescStr = FMT_STR(@"%@", [self.reservedPhone hidePhoneNumStr]);
    _msgSendDescTextLabel.text = FMT_STR(@"验证码已发送到 %@", sendDescStr);
    _msgSendDescTextLabel.hidden = NO;
    
        //  倒计时时间
    __block int timeout = _timeOut;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        //  每秒执行
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0f * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
                //  倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _postCodeDescTextLabel.text = @"重发";
                _postCodeDescTextLabel.userInteractionEnabled = YES;
            });
        } else {
            int seconds = timeout % (kCommonTimeOut + 1);
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                    //  设置界面的按钮显示 根据自己需求设置
                _postCodeDescTextLabel.text = strTime;
                _postCodeDescTextLabel.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
@end


#pragma mark - 订单信息确认
@interface CustomPWDAlertViewForOrderInfo () <UITextFieldDelegate> {
        //  是否输入完成
    BOOL _isAutoComplete;
        //  是否点击了关闭按钮
    BOOL _isTapCloseBtn;
}
@property (strong, nonatomic) NSMutableArray *dotForPasswordIndicatorArrary;
@end

@implementation CustomPWDAlertViewForOrderInfo

#pragma mark - init

- (instancetype)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock
{
    if (CustomOrderAlertViewAuto == orderType) {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalAlertViewContentHeight withOffSetBgWidth:0];
        
        self.btnType = CustomAlertViewBtnDefault;
    } else {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight withOffSetBgWidth:0];
    }
    
    _orderType = orderType;
    
    if (self) {
        
        _dotForPasswordIndicatorArrary = [NSMutableArray array];
        _isAutoComplete = NO;
        _isTapCloseBtn = NO;
        
        self.confirmBlock = completionBlock;
        
        [self configOrderInfoView];
    }
    
    return self;
}

- (void)configOrderInfoView
{
    _orderTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat , kRowHeight * 1.3f, kSpaceFloat * 6, CommonLbHeight)];
    _orderTextDescLabel.textAlignment = NSTextAlignmentLeft;
    _orderTextDescLabel.text = @"订单金额（元）";
    _orderTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _orderTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextDescLabel];
    
    _orderTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat * 7.f, kRowHeight * 1.3f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _orderTextLabel.textAlignment = NSTextAlignmentLeft;
    _orderTextLabel.text = @"-.-";
    _orderTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextLabel];
    
    _costTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat , kRowHeight * 2.0f, kSpaceFloat * 6, CommonLbHeight)];
    _costTextDescLabel.textAlignment = NSTextAlignmentLeft;
    _costTextDescLabel.text = @"抵用金额（元）";
    _costTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _costTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_costTextDescLabel];
    
    _costTextLabel = [[UILabel alloc] initWithFrame:CGRectMake( kSpaceFloat * 7.f, kRowHeight * 2.0f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _costTextLabel.textAlignment = NSTextAlignmentLeft;
    _costTextLabel.text = @"-.-";
    _costTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_costTextLabel];
    
    _payTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat , kRowHeight * 2.7f, kSpaceFloat * 6, CommonLbHeight)];
    _payTextDescLabel.textAlignment = NSTextAlignmentLeft;
    _payTextDescLabel.text = @"支付金额（元）";
    _payTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _payTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_payTextDescLabel];
    
    _payTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat * 7.f, kRowHeight * 2.7f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _payTextLabel.textAlignment = NSTextAlignmentLeft;
    _payTextLabel.textColor = COMMON_ORANGE_COLOR;
    _payTextLabel.text = @"-.-";
    _payTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_payTextLabel];
    
    _payPwdTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat , kRowHeight * 3.6f, self.bgContentView.width - kSpaceFloat * 2, kRowHeight)];
    _payPwdTf.isLimitLength = YES;
    _payPwdTf.placeholder = @"请输入交易密码";
    _payPwdTf.delegate = self;
    _payPwdTf.secureTextEntry = YES;
    [_payPwdTf becomeFirstResponder];
    _payPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payPwdTf.curTextFieldType = CustomTextFieldTypePassword;
    [self.bgContentView addSubview:_payPwdTf];
    if (CustomOrderAlertViewAuto == _orderType) {
            //  数字键盘
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeNumber];
            //  block回调
        [_payPwdTf shouldChangeCharacters:^(SafeKeyBoardField *textField, NSString *string) {
            [self payPwdTfEditingChanged:textField];
        }];
        
            //_payPwdTf.keyboardType = UIKeyboardTypeNumberPad;
        
        _payPwdTf.hidden = YES;
            //        [_payPwdTf addTarget:self action:@selector(payPwdTfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
            //  添加自动填充框
        [self initAutoUI];
    } else {
            //_payPwdTf.keyboardType = UIKeyboardTypeDefault;
            //  普通字符键盘
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeCharacter];
        [_payPwdTf shouldChangeCharacters:^(SafeKeyBoardField *textField, NSString *string) {
            [self textChanged:textField];
        }];
        [_payPwdTf addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        self.confirmBtn.enabled = NO;
    }
        // v3.2 使用安全键盘
    _payPwdTf.forbidSpace = YES;
    _payPwdTf.forbidClipboard = YES;
    
}

- (void)textChanged:(UITextField *)textFiled
{
    if (_payPwdTf.text.length > 0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}

- (void)dismiss
{
    _isTapCloseBtn = YES;
    if (self) {
            //  存在的时候才调用移除函数
        if (self) {
            [UIView animateWithDuration:0.3f animations:^{
                CGRect frame = self.bgContentView.frame;
                frame.origin.y = + MAIN_SCREEN_HEIGHT;
                self.bgContentView.frame = frame;
                [_payPwdTf resignFirstResponder];
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
            
        }
    }
}

- (void)completion
{
    if (_payPwdTf && _orderType == CustomOrderAlertViewAuto ) {
            //  隐藏键盘
        [_payPwdTf resignFirstResponder];
    }
    
    [super completion];
}

- (void)hideBackgroundAlpha
{
    [super hideBackgroundAlpha];
    [_payPwdTf resignFirstResponder];
}

- (void)showBackgroundAlpha
{
    [super showBackgroundAlpha];
    _payPwdTf.text = @"";
    [self setDotWithCount:0];
    _isAutoComplete = NO;
    [_payPwdTf becomeFirstResponder];
}

- (void)initAutoUI
{
    UIView *autoView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat , kRowHeight * 3.6f, self.bgContentView.width - kSpaceFloat * 2, kRowHeight)];
    autoView.backgroundColor = COMMON_WHITE_COLOR;
    autoView.layer.cornerRadius = kCommonBtnRad;
    autoView.layer.borderColor = [COMMON_GREY_COLOR CGColor];
    [self.bgContentView addSubview:autoView];
    
        // 触发弹起键盘
    [autoView GJSHandleClick:^(UIView *view) {
        [_payPwdTf becomeFirstResponder];
    }];
    
    CGFloat sigleDotViewWidth = autoView.width / 6;
    CGFloat sigleDotWidth = sigleDotViewWidth * .25f;
    
        //  竖线
    for (int idx = 0; idx < kAutoPwdLenght - 1; idx++) {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((idx + 1) * sigleDotViewWidth, 5.0f, .5f, autoView.height - 10.0f)];
        lineImageView.backgroundColor = COMMON_LIGHT_GREY_COLOR;
        [autoView addSubview:lineImageView];
    }
        //  密码标志
    for (int idx = 0; idx < kAutoPwdLenght; idx++) {
        UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((sigleDotViewWidth - sigleDotWidth) * .5f + idx * sigleDotViewWidth, (autoView.height - sigleDotWidth) * .5f, sigleDotWidth, sigleDotWidth)];
        dotImageView.backgroundColor = COMMON_BLACK_COLOR;
        dotImageView.layer.cornerRadius = sigleDotWidth * .5f;
        dotImageView.clipsToBounds = YES;
        dotImageView.hidden = YES;
        [autoView addSubview:dotImageView];
        
        [_dotForPasswordIndicatorArrary addObject:dotImageView];
    }
}

#pragma mark - 字符变更监听
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        //  YES则可继续输入，返回NO表示禁止输入
    if ([string isEqualToString:@"\n"]) {
            //  按回车关闭键盘(本场景不启用)
            //[textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
            //  判断是不是删除键
        return YES;
    } else {
        return YES;
    }
}

#pragma mark - 未完成输入情况下不允许失去焦点
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!_isAutoComplete && _orderType == CustomOrderAlertViewAuto && textField == _payPwdTf) {
            //  这里重新获得焦点 再次输入会首先清空已输入的密码
        if (!_isTapCloseBtn) {
            [textField becomeFirstResponder];
        }
    }
}

    //  先响应点击事件 --> tf获得焦点 --> 则不会触发tf失去焦点的代理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_orderType == CustomOrderAlertViewAuto) {
        [_payPwdTf becomeFirstResponder];
    }
}

- (void)payPwdTfEditingChanged:(UITextField *)textField
{
    if (_orderType == CustomOrderAlertViewAuto && textField == _payPwdTf) {
            //  显示输入圆点
        [self setDotWithCount:_payPwdTf.text.length];
            //  检测到6位输入则直接出发block回调
        if (_payPwdTf.text.length >= kAutoPwdLenght) {
            _isAutoComplete = YES;
            self.confirmBlock(self);
            _payPwdTf.text = [_payPwdTf.text substringWithRange:NSMakeRange(0, kAutoPwdLenght)];
                //  隐藏键盘
//            [_payPwdTf resignFirstResponder];
        }
    }
}

#pragma mark - 设置密码标志
- (void)setDotWithCount:(NSInteger)count
{
    for (UIImageView *dotImageView in _dotForPasswordIndicatorArrary) {
        dotImageView.hidden = YES;
    }
    
        //  显示密码标志
    for (int idx = 0; idx < count; idx++) {
        ((UIImageView*)[_dotForPasswordIndicatorArrary objectAtIndex:idx]).hidden = NO;
    }
}

@end


