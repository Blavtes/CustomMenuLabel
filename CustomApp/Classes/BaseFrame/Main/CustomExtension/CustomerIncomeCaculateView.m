//
//  CustomerIncomeCaculateView.m
//  GjFax
//
//  Created by gjfax on 16/9/27.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomerIncomeCaculateView.h"
// 以iphone6为尺寸原型来适配
    // 计算器距离屏幕顶部的距离
static CGFloat const kTopGap = 200.0f;
    // 计算器距离屏幕左侧的距离
static CGFloat const kLeftGap = 15.0f;
    // 计算器的整体高度
static CGFloat const kHeight = 445.0f;


@interface CustomerIncomeCaculateView()
// 输入金额label
@property (nonatomic, weak) UILabel *inputAmountLb;
// 预计收益描述label
@property (nonatomic, weak) UILabel *expectEarningsDescLb;
// 预计收益金额label
@property (nonatomic, weak) UILabel *expectEarningsLb;

// 关闭计算器按钮
@property (nonatomic, weak) UIButton *dismissBtn;


// 大的背景View（整个窗口）
@property (nonatomic, weak) UIView *bigView;
// 小的背景View (预计收益背景)
@property (nonatomic, weak) UIView *smallView;
// 数字按钮View
@property (nonatomic, weak) UIView *numbersView;

// 计算器字符显示
@property (nonatomic, strong) NSArray *numbersArray;

@end


@implementation CustomerIncomeCaculateView

#pragma mark - 初始化
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
        
        [self dismissTapGesture];
    
    }
    
    return self;
}

- (void)dismissTapGesture
{
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTapBehind:)];
    // 点击次数
    [recognizerTap setNumberOfTapsRequired:1];
    // 点击手指数
    recognizerTap.numberOfTouchesRequired = 1;
    // 默认YES.说明一旦手势被识别，那么就调用[touchView touchesCancelled:withEvent]
    recognizerTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:recognizerTap];
}

// 处理手势在view之外的点击事件
- (void)handleTapBehind:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint location = [sender locationInView:nil];
        if (![self.bigView pointInside:[self.bigView convertPoint:location fromView:self.bigView.window] withEvent:nil]){
            if (self) {
                [self dismiss];
            }
        }
    }
}

- (void)initBaseView
{
    //  高度适配比率
    CGFloat heightRate = MAIN_SCREEN_HEIGHT/ 667.0f;
    
    // 大的背景View（整个窗口）
    UIView *bigView = [[UIView alloc] init];
    bigView.frame = CGRectMake(kLeftGap, kTopGap * heightRate , MAIN_SCREEN_WIDTH - kLeftGap * 2, kHeight * heightRate);
    bigView.backgroundColor = COMMON_WHITE_COLOR;
    bigView.layer.cornerRadius = 6;
    bigView.layer.masksToBounds = YES;
    [self addSubview:bigView];
    _bigView = bigView;
    
    // 关闭按钮
    UIImage *btnImg = [UIImage imageNamed:@"common_close_selected"];
    UIButton *dismissBtn = [UIButton btnWithImageName:@"common_close_selected" position:CGPointMake(bigView.width - 5 - btnImg.size.width, 5) taget:self action:@selector(dismiss)];
    [bigView addSubview:dismissBtn];
    _dismissBtn = dismissBtn;
    
    // 输入金额
    UILabel *inputAmountLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 45 * heightRate, bigView.width - 10, 30 * heightRate)];
    inputAmountLb.text = @"0";
    inputAmountLb.textColor = COMMON_BLUE_GREEN_COLOR;
    inputAmountLb.font = [UIFont systemFontOfSize:kCommonFontSizeBtnTitle_25];
    inputAmountLb.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:inputAmountLb];
    _inputAmountLb = inputAmountLb;
        // 初始化输入返回值inputAmount
    self.inputAmount = @"";
    
    // 小的背景View (预计收益背景)
    UIView *smallView = [[UIView alloc] init];
    smallView.frame = CGRectMake(0, 85 * heightRate, bigView.width ,45 * heightRate);
    smallView.backgroundColor = COMMON_BLUE_GREEN_COLOR;
        // 预计收益描述
    UILabel *expectEarningsDescLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bigView.width * 0.5f - 10, smallView.height)];
    expectEarningsDescLb.text = @"预计收益(元)";
    expectEarningsDescLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    expectEarningsDescLb.textColor = COMMON_WHITE_COLOR;
    expectEarningsDescLb.textAlignment = NSTextAlignmentLeft;
    _expectEarningsDescLb = expectEarningsDescLb;
    [smallView addSubview:expectEarningsDescLb];
        // 预计收益值显示
    UILabel *expectEarningsLb = [[UILabel alloc] initWithFrame:CGRectMake(bigView.width  * 0.5f, 0, bigView.width * 0.5f - 10, smallView.height)];
    expectEarningsLb.text = @"0.00";
    expectEarningsLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    expectEarningsLb.textColor = COMMON_WHITE_COLOR;
    expectEarningsLb.textAlignment = NSTextAlignmentRight;
    _expectEarningsLb = expectEarningsLb;
    [smallView addSubview:expectEarningsLb];
    
    [bigView addSubview:smallView];
    _smallView = smallView;
    
    // 数字按钮View
    UIView *numbersView = [[UIView alloc] init];
    numbersView.frame = CGRectMake(0, 135 * heightRate, bigView.width ,270 * heightRate);
    numbersView.backgroundColor = [UIColor clearColor];
    NSArray *numbersArray = [[NSArray alloc] initWithObjects: @1, @2, @3, @4, @5, @6, @7, @8, @9, @0, @0,nil];
    _numbersArray = numbersArray;
    _numbersView = numbersView;
        //初始化12个btn按钮
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *button = [self creatButtonWithX:i Y:j];
            [numbersView addSubview:button];
        }
    }
    
    [bigView addSubview:numbersView];
    
    
    // 确认购买按钮
    UIButton *confirmBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(bigView.width *0.5f - 50, 410 * heightRate, 100, 20)];
    [confirmBuyBtn setTitle:@"按此金额购买" forState:UIControlStateNormal];
    [confirmBuyBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
    [confirmBuyBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    confirmBuyBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    confirmBuyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBuyBtn addTarget:self action:@selector(confirmBuyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:confirmBuyBtn];
    _confirmBuyBtn = confirmBuyBtn;
    
}

// 关闭按钮
- (void)dismiss
{
    [self removeFromSuperview];
}

// 确认购买
- (void)confirmBuyBtnAction {
    if (_jumpBlock) {
        _jumpBlock(_inputAmount,_expectEarnings);
    }
    [self dismiss];
}

// 生成数字计算器上的每个button的方法
-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y
{
    // 每个button的序号
    NSInteger num = y + 3*x +1;
    // 给每个button绑定tag
    UIButton *button = [self viewWithTag:num];
    
    if (!button) {
            //数字view总高度
        CGFloat kHeight = _numbersView.height;
            //数字view总宽度
        CGFloat kWidth = _numbersView.width;
            //距离最左端的间隙
        CGFloat kLeftGap = 10.0f;
            //距离最顶端的间隙
        CGFloat kTopGap = 10.0f;
            //每个button之间的横向间隙（行距）
        CGFloat kRowSpace = 5.0f;
            //每个button之间的纵向间隙（列距）
        CGFloat kColSpace = 5.0f;
            //每个button的宽
        CGFloat kBtnWidth  = (kWidth - 2 * kLeftGap - 2 * kColSpace) / 3;
            //每个button的X值
        CGFloat kSizeX = kLeftGap + (kBtnWidth + kColSpace) * y;
            //每个button的高
        CGFloat kBtnHeight = (kHeight - 2 * kTopGap - 3 * kRowSpace) / 4;
            //每个button的Y值
        CGFloat kSizeY = kTopGap + (kBtnHeight + kRowSpace) * x;
   
        
      // button的通用设置
        button = [[UIButton alloc] initWithFrame:CGRectMake(kSizeX, kSizeY, kBtnWidth, kBtnHeight)];
        button.tag = num;
        button.layer.cornerRadius = 3.f;
        UIColor *colorNormal = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        UIColor *colorHightlighted = [UIColor colorWithRed:58.0/255 green:167.0/255 blue:194.0/255 alpha:1.0];
        button.backgroundColor = colorNormal;
        button.clipsToBounds = YES;
         [button setBackgroundColor:colorHightlighted forState:UIControlStateHighlighted];
        
         if (num == 11){
            [button setFrame:CGRectMake(kLeftGap, kTopGap + (kBtnHeight + kRowSpace) * 3, kBtnWidth *2 + kColSpace, kBtnHeight)];
         }
        

    }
    
    NSString *title = @"";
    // 处理显示效果
    if (num < 12) {
        title = [NSString stringWithFormat:@"%@",self.numbersArray[num - 1]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
        [button setTitleColor:COMMON_WHITE_COLOR forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeBtnTitle_25];
    } else if (num == 12) {
        [button setImage:[UIImage imageNamed:@"Custom_KeyBoard_Clear2_Icon"] forState:UIControlStateNormal];
    } else {
    
    }
    // 添加点击动作
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 点击了按钮
-(void)clickButton:(UIButton *)sender
{
    // 处理输入数字
       if (sender.tag == 12) {
           // 删除键
           if (self.inputAmount.length > 0) {
               self.inputAmount =  [self.inputAmount substringToIndex:self.inputAmount.length - 1];
           }
           
        }else {
          // 数字键
              // 数字键长度限制
            if (self.inputAmount.length >= 10) {
                return;
            }
              // 数字键拼接
            self.inputAmount = [self.inputAmount stringByAppendingString:sender.titleLabel.text];
            
              // 数字键第一次输入0时限制
                if ([self.inputAmount hasPrefix:@"0"]) {
                   self.inputAmount = [self.inputAmount substringFromIndex:1];
                }
            }
    // 显示用户输入金额
    [self showInputAmount];
    
    // 显示用户待收收益
    [self showExpectEarnings];
}

// 显示用户输入金额
- (void)showInputAmount {
    if (self.inputAmount.length > 0) {
        NSString *showInputAmount = [self.inputAmount formatStrTo10_4WithNoDecimal];
        NSString *coinMark = @"￥";
        NSString *combineString = [coinMark stringByAppendingString:showInputAmount];
        self.inputAmountLb.text = combineString;
    } else {
        self.inputAmountLb.text = @"0";
    }
   
}

// 显示用户待收收益
- (void)showExpectEarnings {
    // 预期年化
    double expectEarningsRateFloat =  [_expectEarningsRate floatValue];
    // 投资金额
    double inputAmountFloat = [_inputAmount floatValue];
    // 投资天数
    int investTermsInt = [_investTerms intValue];
    // 预期收益
    double expectEarningsFloat = expectEarningsRateFloat * inputAmountFloat * 0.01f * investTermsInt / 360;
    NSString *expectEarningsString = [[NSString stringWithFormat:@"%f",expectEarningsFloat] formatStrTo10_4];
    _expectEarnings = expectEarningsString;
    _expectEarningsLb.text = expectEarningsString;
    
}

// 显示计算器
- (void)show
{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}


- (void)setJumpBlock:(jumpMethodBlock)jumpBlock
{
    _jumpBlock = jumpBlock;
}
@end
