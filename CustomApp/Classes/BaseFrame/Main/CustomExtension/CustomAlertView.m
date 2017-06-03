//
//  CustomAlertView.m
//  HX_GJS
//
//  Created by litao on 16/2/3.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomAlertView.h"
#import "CustomTextField.h"

#import "PhoneCodeViewModel.h"

static const CGFloat kNormalAlertViewContentHeight = 180.0f;
static const CGFloat kAutoOrderAlertViewContentHeight = 200.0f;
static const CGFloat kNormalOrderAlertViewContentHeight = 250.0f;
static const CGFloat kRowHeight = 40.0f;
static const CGFloat kSpaceFloat = 20.0f;
static const NSInteger kAutoPwdLenght = 6;

#pragma mark - 基类弹框

@interface CustomAlertView() <UITextFieldDelegate> {
    //  ..
}

//  背景view
@property (weak, nonatomic) UIView *bgView;

@property (copy, nonatomic) CancelBlock cancelBlock;

@property (weak, nonatomic) UIView *titleView;
@property (nonatomic, weak) UIButton *dismissBtn;
@property (nonatomic, weak) UILabel *titleLb;

@property (weak, nonatomic) UIView *btnView;

@property (weak, nonatomic) UIView *lineViewHor;
@property (weak, nonatomic) UIView *lineViewVec;

@end

@implementation CustomAlertView

#pragma mark - setter & getter

- (void)setTitle:(NSString * __nullable)title
{
    _titleLb.text = title;
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

- (UIButton*)getConfirmBtn
{
    return _confirmBtn;
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

- (UIView *)btnContentView
{
    return _btnView;
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
        //  基础属性
        self.backgroundColor = [UIColor colorWithWhite:0.35f alpha:0.5f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
        [self addGestureRecognizer:tap];
        
        //  背景
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat, (MAIN_SCREEN_HEIGHT - bgHeight) * .5f, MAIN_SCREEN_WIDTH - kSpaceFloat * 2.0f, bgHeight)];
        bgView.backgroundColor = COMMON_GREY_WHITE_COLOR;
        bgView.layer.cornerRadius = 6.0f;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        _bgView = bgView;
        
        _confirmBlock = completionBlock;
        
        [self configTitleView];
        
        [self configBtnView];
    }
    
    return self;
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
//    
//    [cancelBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
//    _cancelBtn = cancelBtn;
    
    CustomFirstRateButton *cancelBtn = [[CustomFirstRateButton alloc] initWithFrame:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width * .5f - kSpaceFloat * 2.0f, kRowHeight) title:@"取消" cornerRadius:YES];
    [btnView addSubview:cancelBtn];
    cancelBtn.clickHandle = ^(UIButton *btn) {
        [self cancel];
    };
    cancelBtn.hidden = YES;
    _cancelBtn = cancelBtn;
    
//    UIButton *confirmBtn = [UIButton btnWithTitle:@"确认" rect:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width - kSpaceFloat * 2.0f, kRowHeight) taget:self action:@selector(completion)];
//    [btnView addSubview:confirmBtn];
//    [confirmBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
//    _confirmBtn = confirmBtn;

    CustomFirstRateButton *confirmBtn = [[CustomFirstRateButton alloc] initWithFrame:CGRectMake(kSpaceFloat, kSpaceFloat * .5f, btnView.width - kSpaceFloat * 2.0f, kRowHeight) title:@"确认" cornerRadius:YES];
    [btnView addSubview:confirmBtn];
    confirmBtn.clickHandle = ^(UIButton *btn) {
        [self completion];
    };
    _confirmBtn = confirmBtn;
    
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

- (void)changeButtonStyle:(BOOL)clear
{
    if (clear) {
        [_confirmBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [_confirmBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
        
        [_cancelBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        
        [_cancelBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    }
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
        [CustomAlertView hideAll];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismiss
{
    if (self) {
        [self removeFromSuperview];
    }
}

- (BOOL)isAnyAlertViewShowed
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    for (CustomAlertView *subview in window.subviews) {
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
    for (CustomAlertView *subview in view.subviews) {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //  视图上移
    [UIView animateWithDuration:.3f animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -90;
        self.frame = frame;
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //  视图恢复
    [UIView animateWithDuration:.3f animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
    
    return YES;
}

@end

#pragma mark - 功能跳转弹窗

@implementation CustomAlertViewForFuncJump

- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock];
    
    if (self) {
        
        self.confirmBlock = completionBlock;
        
        [self configTipView];
    }
    
    return self;
}

- (void)configTipView
{
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.5f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_textLabel];
    
    _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 2.2f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    _detailTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_detailTextLabel];
// 添加弹框外屏幕的点击手势
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTapBehind:)];
    // 点击次数
    [recognizerTap setNumberOfTapsRequired:1];
    // 点击手指数
    recognizerTap.numberOfTouchesRequired = 1;
    // 默认YES.说明一旦手势被识别，那么就调用[touchView touchesCancelled:withEvent]
    recognizerTap.cancelsTouchesInView = NO;
    // 添加手势
    [self addGestureRecognizer:recognizerTap];
}

// 处理手势在view之外的点击事件
- (void)handleTapBehind:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self.bgContentView pointInside:[self.bgContentView convertPoint:location fromView:self.bgContentView.window] withEvent:nil]){
            // block监听点击view之外的点击，取消掉弹框
            [self dismiss];
            if (self.clickBlank) {
                self.clickBlank();
            }
        }
    }
}

@end

#pragma mark - 强提示信息框

@implementation CustomAlertViewForStrongTip

- (instancetype)initWithCancelBlock:(CancelBlock)cancelBlock
                withCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock];
    
    if (self) {
        
        self.cancelBlock = cancelBlock;
        self.confirmBlock = completionBlock;
        
        self.titleType = CustomAlertViewTitleHide;
        self.btnType = CustomAlertViewBtnWithCancel;
        
        [self configTipView];
        
        [self changeButtonStyle:YES];
    }
    
    return self;
}

- (void)configTipView
{
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.2f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_textLabel];
    _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.8f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _detailTextLabel.textAlignment = NSTextAlignmentCenter;
    _detailTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_detailTextLabel];
    
    // 添加弹框外屏幕的点击手势
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapOut:)];
    // 点击次数
    [recognizerTap setNumberOfTapsRequired:1];
    // 点击手指数
    recognizerTap.numberOfTouchesRequired = 1;
    // 默认YES.说明一旦手势被识别，那么就调用[touchView touchesCancelled:withEvent]
    recognizerTap.cancelsTouchesInView = NO;
    // 添加手势
    [self addGestureRecognizer:recognizerTap];
}

// 处理手势在view之外的点击事件
- (void)handleTapOut:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self.bgContentView pointInside:[self.bgContentView convertPoint:location fromView:self.bgContentView.window] withEvent:nil]){
            // block监听点击view之外的点击，取消掉弹框
            [self dismiss];
        }
    }
}

@end


#pragma mark - 订单信息确认
@interface CustomAlertViewForOrderInfo () <UITextFieldDelegate> {
    //  是否输入完成
    BOOL _isAutoComplete;
    //  是否点击了关闭按钮
    BOOL _isTapCloseBtn;
}
@property (strong, nonatomic) NSMutableArray *dotForPasswordIndicatorArrary;
@end

@implementation CustomAlertViewForOrderInfo

#pragma mark - init

- (instancetype)initWithOrderType:(CustomOrderAlertViewType)orderType withCompletionBlock:(ConfirmBlock)completionBlock
{
    if (CustomOrderAlertViewAuto == orderType) {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:kAutoOrderAlertViewContentHeight];
        
        self.btnType = CustomAlertViewBtnDefault;
    } else {
        self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight];
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
    _orderTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kRowHeight * 1.3f, self.bgContentView.width * .5f, CommonLbHeight)];
    _orderTextDescLabel.textAlignment = NSTextAlignmentRight;
    _orderTextDescLabel.text = @"订单金额（元）";
    _orderTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _orderTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextDescLabel];
    
    _orderTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgContentView.width * .5f + kSpaceFloat * .5f, kRowHeight * 1.3f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _orderTextLabel.textAlignment = NSTextAlignmentLeft;
    _orderTextLabel.text = @"-.-";
    _orderTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextLabel];
    
    _costTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kRowHeight * 2.0f, self.bgContentView.width * .5f, CommonLbHeight)];
    _costTextDescLabel.textAlignment = NSTextAlignmentRight;
    _costTextDescLabel.text = @"抵用金额（元）";
    _costTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _costTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_costTextDescLabel];
    
    _costTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgContentView.width * .5f + kSpaceFloat * .5f, kRowHeight * 2.0f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _costTextLabel.textAlignment = NSTextAlignmentLeft;
    _costTextLabel.text = @"-.-";
    _costTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_costTextLabel];
    
    _payTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kRowHeight * 2.7f, self.bgContentView.width * .5f, CommonLbHeight)];
    _payTextDescLabel.textAlignment = NSTextAlignmentRight;
    _payTextDescLabel.text = @"支付金额（元）";
    _payTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _payTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_payTextDescLabel];
    
    _payTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bgContentView.width * .5f + kSpaceFloat * .5f, kRowHeight * 2.7f, self.bgContentView.width * .5f - kSpaceFloat, CommonLbHeight)];
    _payTextLabel.textAlignment = NSTextAlignmentLeft;
    _payTextLabel.textColor = COMMON_ORANGE_COLOR;
    _payTextLabel.text = @"-.-";
    _payTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_payTextLabel];
    
    _payPwdTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 3.6f, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
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
    }
    // v3.2 使用安全键盘
    _payPwdTf.forbidSpace = YES;
    _payPwdTf.forbidClipboard = YES;
    
}

- (void)dismiss
{
    _isTapCloseBtn = YES;
    if (self) {
        //  存在的时候才调用移除函数
        [self removeFromSuperview];
    }
}

- (void)completion
{
    if (_payPwdTf) {
        //  隐藏键盘
        [_payPwdTf resignFirstResponder];
    }
    
    [super completion];
}

- (void)initAutoUI
{
    UIView *autoView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 3.6f, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
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
            [_payPwdTf resignFirstResponder];
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

@interface CustomAlertViewForMsgConfirm () {
    //  倒计时时间
    int _timeOut;
}

@property (strong, nonatomic) PhoneCodeViewModel *phoneCodeViewModel;

@property (strong, nonatomic) UIView *tfRightView;
@property (strong, nonatomic) UIActivityIndicatorView *actIndicatorView;

@end

@implementation CustomAlertViewForMsgConfirm
#pragma mark - Lazy Load
- (PhoneCodeViewModel *)phoneCodeViewModel
{
    if (_phoneCodeViewModel) {
        return _phoneCodeViewModel;
    }
    
    _phoneCodeViewModel = [[PhoneCodeViewModel alloc] init];
    
    return _phoneCodeViewModel;
}

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
        _reservedPhone = FMT_STR(@"%@", UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeMobilePhone));
    }
    return _reservedPhone;
}

#pragma mark - init BaseView
- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalOrderAlertViewContentHeight];
    
    if (self) {
        //  默认倒计时
        _timeOut = kCommonTimeOut;
        
        self.confirmBlock = completionBlock;
        
        [self configMsgView];
    }
    
    return self;
}

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
        _msgSendDescTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
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

        _phoneCodeTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 2.6f, self.bgContentView.width - kSpaceFloat - kRowHeight * 2.0f, kRowHeight)];
        _phoneCodeTf.isLimitLength = YES;
        _phoneCodeTf.placeholder = @"短信验证码";
        _phoneCodeTf.delegate = self;
        [_phoneCodeTf becomeFirstResponder];
        _phoneCodeTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneCodeTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneCodeTf.curTextFieldType = CustomTextFieldTypePhoneCode;
        [self.bgContentView addSubview:_phoneCodeTf];
        
        _payPwdTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 3.8f, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
        _payPwdTf.isLimitLength = YES;
        _payPwdTf.placeholder = @"请输入交易密码";
        _payPwdTf.delegate = self;
        _payPwdTf.secureTextEntry = YES;
        _payPwdTf.keyboardType = UIKeyboardTypeDefault;
        _payPwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _payPwdTf.curTextFieldType = CustomTextFieldTypePassword;
        // v3.2 使用安全键盘
        [_payPwdTf setSafeKeyBoardType:SafeKeyBoardTypeCharacter];
        _payPwdTf.forbidSpace  = YES;
        _payPwdTf.forbidClipboard = YES;
    
        [self.bgContentView addSubview:_payPwdTf];
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
    
    if (_msgType == PhoneCodeTypeChargeCash) {
        [self.phoneCodeViewModel fetchPhoneCodeData:_msgType withNewVersionFlag:YES withAmount:[_orderTextLabel.text formatStrWithSignToNumberStr]];
    } else {
        [self.phoneCodeViewModel fetchPhoneCodeData:_msgType withNewVersionFlag:YES];
    }
}

#pragma mark - 倒计时
- (void)updateCountDownUI
{
    NSString *sendDescStr = FMT_STR(@"%@", [self.reservedPhone hidePhoneNumStr]);
    _msgSendDescTextLabel.text = FMT_STR(@"验证码已发送到%@", sendDescStr);
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

#pragma mark - 邀请码类型
/**
 *  邀请码类型
 */
@interface CustomAlertViewForInviteCode () {
    //
}
@end

@implementation CustomAlertViewForInviteCode
#pragma mark - Lazy Load

#pragma mark - init BaseView
- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock];
    
    if (self) {
        
        self.confirmBtnTitle = @"确定";
        self.btnType = CustomAlertViewBtnNormal;
        self.confirmBlock = completionBlock;
        
        [self configView];
    }
    
    return self;
}

- (void)configView
{
    _orderTextDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 1.1f, self.bgContentView.width - kSpaceFloat * 2.0f, CommonLbHeight)];
    _orderTextDescLabel.textAlignment = NSTextAlignmentCenter;
    _orderTextDescLabel.text = @"邀请码";
    _orderTextDescLabel.textColor = COMMON_BLACK_COLOR;
    _orderTextDescLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [self.bgContentView addSubview:_orderTextDescLabel];
    
    _codeTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, _orderTextDescLabel.y + CommonLbHeight, self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    _codeTf.isLimitLength = YES;
    _codeTf.placeholder = @"请输入邀请码";
    _codeTf.delegate = self;
    [_codeTf becomeFirstResponder];
    _codeTf.keyboardType = UIKeyboardTypeDefault;
    _codeTf.curTextFieldType = CustomTextFieldTypeInviteCode;
    [self.bgContentView addSubview:_codeTf];
}

@end


#pragma mark - 需发送短信验证码确认类

@interface CustomAlertViewForSingleMsgConfirm () {
    //  倒计时时间
    int _timeOut;
}

@property (strong, nonatomic) PhoneCodeViewModel *phoneCodeViewModel;

@property (strong, nonatomic) UIView *tfRightView;
@property (strong, nonatomic) UIActivityIndicatorView *actIndicatorView;

@end

@implementation CustomAlertViewForSingleMsgConfirm
#pragma mark - Lazy Load
- (PhoneCodeViewModel *)phoneCodeViewModel
{
    if (_phoneCodeViewModel) {
        return _phoneCodeViewModel;
    }
    
    _phoneCodeViewModel = [[PhoneCodeViewModel alloc] init];
    
    return _phoneCodeViewModel;
}

- (void)setMsgType:(PhoneCodeType)msgType
{
    _msgType = msgType;
    
    if (_msgType) {
        [self postCode];
    }
    
}

#pragma mark - init BaseView
- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock withBgHeight:kNormalAlertViewContentHeight];
    
    if (self) {
        //  默认倒计时
        _timeOut = kCommonTimeOut;
        
        self.confirmBlock = completionBlock;
        
        [self configMsgView];
    }
    
    return self;
}

- (void)configMsgView
{
    _tfRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRowHeight * 2.0f, CommonLbHeight)];
    _tfRightView.backgroundColor = [UIColor clearColor];
    
    _postCodeDescTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kRowHeight * 2.0f, CommonLbHeight)];
    _postCodeDescTextLabel.textColor = COMMON_BLUE_GREEN_COLOR;
    _postCodeDescTextLabel.text = [NSString stringWithFormat:@"%is",kCommonTimeOut];
    _postCodeDescTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    _postCodeDescTextLabel.textAlignment = NSTextAlignmentCenter;
    _postCodeDescTextLabel.userInteractionEnabled = YES;
    _postCodeDescTextLabel.hidden = YES;
    [_tfRightView addSubview:_postCodeDescTextLabel];
    
    _actIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _actIndicatorView.center = _tfRightView.center;
    _actIndicatorView.color = COMMON_BLUE_GREEN_COLOR;
    _actIndicatorView.hidden = YES;
    [_actIndicatorView setHidesWhenStopped:YES];
    [_tfRightView addSubview:_actIndicatorView];
    
    //    UILabel *postNoticeDes = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat * 2, kRowHeight - 10, self.bgContentView.width - kSpaceFloat * 4.0f, 40)];
    
    //    NSString *desStr = @"短信验证码已发送至银行预留手机号";
    //    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:desStr];
    //    [attStr addAttributes:@{NSForegroundColorAttributeName:COMMON_GREY_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12]} range:NSMakeRange(0, desStr.length)];
    ////    [attStr addAttributes:@{NSForegroundColorAttributeName:COMMON_BLUE_GREEN_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubDesc_14]} range:NSMakeRange(9, 8)];
    //    postNoticeDes.attributedText = attStr;
    //    [self.bgContentView addSubview:postNoticeDes];
    
    _postNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight , self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight)];
    _postNoticeLabel.textColor = COMMON_GREY_COLOR;
    _postNoticeLabel.numberOfLines = 0;
    _postNoticeLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    _postNoticeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.bgContentView addSubview:_postNoticeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postCode)];
    [_postCodeDescTextLabel addGestureRecognizer:tap];
    
    _phoneCodeTf = [[CustomTextField alloc] initWithFrame:CGRectMake(kSpaceFloat, kRowHeight * 2.f , self.bgContentView.width - kSpaceFloat * 2.0f, kRowHeight) withRightIconView:_tfRightView];
    _phoneCodeTf.isLimitLength = YES;
    _phoneCodeTf.placeholder = @"短信验证码";
    _phoneCodeTf.delegate = self;
    [_phoneCodeTf becomeFirstResponder];
    _phoneCodeTf.keyboardType = UIKeyboardTypeNumberPad;
    _phoneCodeTf.curTextFieldType = CustomTextFieldTypePhoneCode;
    [self.bgContentView addSubview:_phoneCodeTf];
}

#pragma mark - 发送验证码 --- TDD
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
    
    [self.phoneCodeViewModel fetchPhoneCodeData:_msgType withNewVersionFlag:YES];
}

#pragma mark - 倒计时
- (void)updateCountDownUI
{
    NSString *sendDescStr = [FMT_STR(@"%@", UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeMobilePhone)) hidePhoneNumStr];
    //    _msgSendDescTextLabel.text = FMT_STR(@"验证码已发送到%@", sendDescStr);
    //    _msgSendDescTextLabel.hidden = NO;
    
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


@implementation CustomAlertViewForFundFuncJump

- (CustomAlertViewForFuncJump*)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    return [super initWithCompletionBlock:completionBlock];
}

- (void)configTipView
{
    [super configTipView];
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.x, self.detailTextLabel.y + kSpaceFloat * 3, self.detailTextLabel.width, self.detailTextLabel.height);
    self.detailTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    self.detailTextLabel.textColor = UIColorFromRGBHex(0xBDBDBD);
    
    self.textLabel.numberOfLines = 0;
    self.textLabel.textColor = UIColorFromRGBHex(0x404040);
    self.textLabel.frame = CGRectMake(self.textLabel.x, self.textLabel.y - kSpaceFloat / 2, self.textLabel.width, self.textLabel.height * 2);
    UIButton *btn = [self getConfirmBtn];
    btn.frame = CGRectMake(btn.x, btn.y - kSpaceFloat, btn.width, btn.height);
}
@end

@implementation CustomAlertViewForGJSTicket

- (CustomAlertViewForGJSTicket*)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithCompletionBlock:completionBlock withBgHeight:230.f];
    
    if (self) {
        
        self.confirmBlock = completionBlock;
        
        [self configTipView];
    }
    
    return self;
}

- (void)configTipView
{
    [super configTipView];
    self.detailTextLabel.hidden = YES;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textColor = UIColorFromRGBHex(0x404040);
    self.textLabel.frame = CGRectMake(self.textLabel.x, self.textLabel.y - kSpaceFloat / 2, self.textLabel.width, self.textLabel.height * 2);
}
@end

