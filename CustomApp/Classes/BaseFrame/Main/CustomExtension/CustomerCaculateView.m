//
//  CustomerCaculateView.m
//  HX_GJS
//
//  Created by litao on 15/8/26.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "CustomerCaculateView.h"
#import "PreCommonHeader.h"
#import "CustomTextField.h"

static CGFloat const kTopRange = 150.0f;
@interface CustomerCaculateView () <UITextFieldDelegate> {
    //
}
//  背景view
@property (nonatomic, weak) UIView *bgView;
//  确认按钮
@property (nonatomic, weak) UIButton *completBtn;
//  关闭按钮
@property (nonatomic, weak) UIButton *dismissBtn;
//  标题
@property (nonatomic, weak) UILabel *titleLb;

//  lineView
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *lineViewMore;
@end

@implementation CustomerCaculateView
#pragma mark - lazyLoad

- (void)setCostNum:(float)costNum
{
    _costTf.text = FMT_STR(@"%.2f", costNum);
    _costNum = costNum;
    
    [self updateIncomeLb];
}

- (void)setTermNum:(int)termNum
{
    _termTf.text = FMT_STR(@"%d", termNum);
    _termNum = termNum;
    
    [self updateIncomeLb];
}

- (void)setRateNum:(float)rateNum
{
    _rateTf.text = FMT_STR(@"%.2f", rateNum);
    _rateNum = rateNum;
    
    [self updateIncomeLb];
}

#pragma mark - base init
/**
 *  初始化
 *
 *  @param frame
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:MAIN_SCREEN_BOUNDS];
    if (self) {
        //  基础属性
        self.backgroundColor = [UIColor colorWithWhite:0.35 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
        [self addGestureRecognizer:tap];
        
        //  初始化
        [self initBaseView];
    }
    
    return self;
}

- (void)initBaseView
{
    //  背景
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(20, kTopRange, MAIN_SCREEN_WIDTH - 40, 300);
    bgView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    bgView.layer.cornerRadius = 6;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    _bgView = bgView;
    
    //  标题
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, bgView.frame.size.width - 80, CommonLbHeight)];
    titleLb.textColor = COMMON_BLACK_COLOR;
    titleLb.text = @"收益计算器";
    titleLb.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLb];
    _titleLb = titleLb;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, bgView.frame.size.width, .5f)];
    lineView.backgroundColor = COMMON_GREY_COLOR;
    lineView.alpha = .5f;
    [bgView addSubview:lineView];
    _lineView = lineView;
    
    //  关闭按钮
    UIImage *btnImg = [UIImage imageNamed:@"common_close_selected"];
    UIButton *dismissBtn = [UIButton btnWithImageName:@"common_close_selected" position:CGPointMake(bgView.width - 10 - btnImg.size.width, 10) taget:self action:@selector(dismiss)];
    [bgView addSubview:dismissBtn];
    _dismissBtn = dismissBtn;
    
    //  金额显示区域
    UILabel *costDescLb = [[UILabel alloc] init];
    costDescLb.text = @"投资金额(元)";
    costDescLb.textColor = COMMON_BLACK_COLOR;
    costDescLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    costDescLb.textAlignment = NSTextAlignmentLeft;
    CGSize costDescSize = [costDescLb.text strSizeWithFont:kCommonFontSizeDetail_16 maxSize:MAX_SIZE];
    costDescLb.frame = CGRectMake(10, 70, costDescSize.width, CommonLbHeight);
    [bgView addSubview:costDescLb];
    _costDescLb = costDescLb;
    
    UITextField *costTf = [[CustomTextField alloc] initWithFrame:CGRectMake(costDescLb.frame.origin.x + costDescLb.frame.size.width + 10, costDescLb.frame.origin.y - 5, bgView.frame.size.width - (costDescLb.frame.origin.x + costDescLb.frame.size.width + 20), CommonLbHeight + 10)];
    costTf.placeholder = @"投资金额";
    costTf.textAlignment = NSTextAlignmentLeft;
    costTf.keyboardType = UIKeyboardTypeNumberPad;
    costTf.clearButtonMode = UITextFieldViewModeAlways;
    [costTf addTarget:self action:@selector(inputInfoChanged:) forControlEvents:UIControlEventEditingChanged];
    costTf.layer.borderWidth = .5f;
    costTf.textColor = COMMON_BLACK_COLOR;
    costTf.layer.borderColor = [COMMON_GREY_COLOR CGColor];
    costTf.backgroundColor = [UIColor whiteColor];
    costTf.layer.cornerRadius = 4;
    costTf.delegate = self;
    costTf.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [bgView addSubview:costTf];
    _costTf = costTf;
    
    UILabel *termDescLb = [[UILabel alloc] initWithFrame:CGRectMake(costDescLb.frame.origin.x, costDescLb.frame.origin.y + CommonLbHeight + 20, costDescSize.width + 10, CommonLbHeight)];
    termDescLb.text = @"投资期限(天)";
    termDescLb.textColor = COMMON_BLACK_COLOR;
    termDescLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    termDescLb.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:termDescLb];
    _termDescLb = termDescLb;
    
    UITextField *termTf = [[CustomTextField alloc] initWithFrame:CGRectMake(costTf.frame.origin.x, termDescLb.frame.origin.y - 5, costTf.frame.size.width, CommonLbHeight + 10)];
    termTf.placeholder = @"投资期限";
    termTf.textAlignment = NSTextAlignmentLeft;
    termTf.keyboardType = UIKeyboardTypeNumberPad;
    termTf.clearButtonMode = UITextFieldViewModeAlways;
    [termTf addTarget:self action:@selector(inputInfoChanged:) forControlEvents:UIControlEventEditingChanged];
    termTf.textColor = COMMON_BLACK_COLOR;
    termTf.text = FMT_STR(@"%d", _termNum);
    termTf.layer.borderWidth = .5f;
    termTf.delegate = self;
    termTf.layer.borderColor = [COMMON_GREY_COLOR CGColor];
    termTf.backgroundColor = COMMON_WHITE_COLOR;
    termTf.layer.cornerRadius = 4;
    termTf.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    [bgView addSubview:termTf];
    _termTf = termTf;
    
    UILabel *rateDescLb = [[UILabel alloc] initWithFrame:CGRectMake(termDescLb.frame.origin.x, termDescLb.frame.origin.y + CommonLbHeight + 20, costDescSize.width + 10, CommonLbHeight)];
    rateDescLb.text = @"收益率(%)";
    rateDescLb.textColor = COMMON_BLACK_COLOR;
    rateDescLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    rateDescLb.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:rateDescLb];
    _rateDescLb = rateDescLb;
    
    UITextField *rateTf = [[CustomTextField alloc] initWithFrame:CGRectMake(costTf.frame.origin.x, rateDescLb.frame.origin.y - 5, costTf.frame.size.width, CommonLbHeight + 10)];
    rateTf.placeholder = @"预期年化收益率";
    rateTf.textAlignment = NSTextAlignmentLeft;
    rateTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    rateTf.clearButtonMode = UITextFieldViewModeAlways;
    [rateTf addTarget:self action:@selector(inputInfoChanged:) forControlEvents:UIControlEventEditingChanged];
    rateTf.text = FMT_STR(@"%.2f", _rateNum);
    rateTf.textColor = COMMON_BLACK_COLOR;
    rateTf.layer.borderWidth = .5f;
    rateTf.delegate = self;
    rateTf.backgroundColor = [UIColor whiteColor];
    rateTf.layer.borderColor = [COMMON_GREY_COLOR CGColor];
    rateTf.layer.cornerRadius = 4;
    rateTf.delegate=self;
    [bgView addSubview:rateTf];
    _rateTf = rateTf;
    
    //  结果描述
    UIView *lineViewMore = [[UIView alloc] initWithFrame:CGRectMake(0, rateDescLb.frame.origin.y + 50, bgView.frame.size.width, .5f)];
    lineViewMore.backgroundColor = COMMON_GREY_COLOR;
    lineViewMore.alpha = .5f;
    [bgView addSubview:lineViewMore];
    _lineViewMore = lineViewMore;
    
    //  收益描述
    UILabel *incomeDescLb = [[UILabel alloc] initWithFrame:CGRectMake(10, lineViewMore.frame.origin.y + 15, bgView.frame.size.width * .5f - 10, CommonLbHeight)];
    incomeDescLb.text = @"预期产品收益(元)";
    incomeDescLb.textAlignment = NSTextAlignmentLeft;
    incomeDescLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    incomeDescLb.textColor = COMMON_BLACK_COLOR;
    [bgView addSubview:incomeDescLb];
    _incomeDescLb = incomeDescLb;
    
    UILabel *incomeLb = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width * .5f, incomeDescLb.frame.origin.y, bgView.frame.size.width * .5f - 10, CommonLbHeight)];
    incomeLb.text = @"-.-";
    incomeLb.textAlignment = NSTextAlignmentRight;
    incomeLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    incomeLb.textColor = COMMON_ORANGE_COLOR;
    [bgView addSubview:incomeLb];
    _incomeLb = incomeLb;
    
    //  提示
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(10, incomeDescLb.frame.origin.y + 20, bgView.frame.size.width - 20.0f, CommonLbHeight)];
    tipLb.textColor = COMMON_GREY_COLOR;
    tipLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    tipLb.text = @"收益以实际兑付金额为准";
    tipLb.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:tipLb];
    _tipLb = tipLb;
    
    //  添加监听
    [_costTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_termTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_rateTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)updateIncomeLb
{
    CGFloat costf= [_costTf.text floatValue];
    CGFloat termf= [_termTf.text floatValue];
    CGFloat ratef= [_rateTf.text floatValue] * .01f;
    _incomeLb.text = [FMT_STR(@"%.2f", (costf * termf * ratef) / 360) formatStrTo10_4];
}

#pragma mark - 监听
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([_costTf.text isEqualToString:@""] ||
        [_termTf.text isEqualToString:@""] ||
        [_rateTf.text isEqualToString:@""]) {
        _incomeLb.text = [NSString stringWithFormat:@"%.2f", 0.0f];
        return;
    }
    
    [self updateIncomeLb];
}

#pragma mark - 显示 - 消失
/**
 *  关闭按钮
 */
- (void)dismiss
{
    [self removeFromSuperview];
}

/**
 显示
 */
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}


#pragma mark - tf delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //  视图上移
    [UIView animateWithDuration:.3f animations:^{
        CGRect frame = self.frame;
        frame.origin.y = -110;
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

/**
 *  code验证
 *
 *  @param sender
 */
- (void)inputInfoChanged:(id)sender
{
    if (sender == _costTf) {
        //  改变投资金额
//        if ([_costTf.text floatValue] > _costNum) {
//            _costTf.text = FMT_STR(@"%.0f", _costNum);
//            Show_iToast(@"投资金额不可超过剩余可投金额");
//        }
    } else if (sender == _termTf) {
        //  改变投资期限
    } else if (sender == _rateTf) {
        //  改变年化收益率
    }
}
@end
