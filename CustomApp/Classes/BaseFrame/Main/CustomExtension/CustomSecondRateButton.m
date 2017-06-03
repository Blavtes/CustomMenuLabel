//
//  CustomSecondRateButton.m
//  GjFax
//
//  Created by yangyong on 2017/2/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomSecondRateButton.h"

@implementation CustomSecondRateButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super init]) {
        
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self configSet:YES];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(BOOL)cornerRadius
{
    if (self = [super init]) {
        
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self configSet:cornerRadius];
    }
    
    return self;
}

- (void)configSet:(BOOL)cornerRadius
{
    self.layer.cornerRadius = kCommonBtnRad;
    self.layer.masksToBounds = cornerRadius;
    self.layer.borderColor = COMMON_ORANGE_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
    [self setBackgroundColor:COMMON_SECOND_RANK_TOUCH_COLOR forState:UIControlStateHighlighted];
    [self setBackgroundColor:COMMON_GREY_WHITE_COLOR forState:UIControlStateNormal];
    [self setTitleColor:COMMON_ORANGE_COLOR forState:UIControlStateNormal];
    [self setTitleColor:COMMON_SECOND_RANK_TITLE_COLOR forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    
    [self addTarget:self action:@selector(secondBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(secondBtnDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(secondBtnCancel:) forControlEvents:UIControlEventTouchDragExit];
}

- (void)awakeFromNib {
    [super awakeFromNib];
        // Initialization code
        //默认有圆角
    [self configSet:YES];
}

- (void)secondBtnClick:(UIButton *)btn
{
    if (_clickHandle) {
        self.clickHandle(btn);
    }
}

- (void)secondBtnDown:(UIButton *)btn
{
    btn.layer.borderColor = COMMON_SECOND_RANK_TITLE_COLOR.CGColor;
}

- (void)secondBtnCancel:(UIButton *)btn
{
    btn.layer.borderColor = COMMON_ORANGE_COLOR.CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

