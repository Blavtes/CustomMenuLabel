//
//  CustomFirstRateButton.m
//  GjFax
//
//  Created by yangyong on 2017/2/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomFirstRateButton.h"
@interface CustomFirstRateButton ()
@property (nonatomic, assign) BOOL isCornerRadius;
@end
@implementation CustomFirstRateButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(BOOL)cornerRadius
{
    if (self = [super init]) {
        
        self.frame = frame;
        if (cornerRadius) {
                //如：申购页 弹出框
            self.layer.cornerRadius = kCommonBtnRad;
            self.layer.masksToBounds = YES;
//            self.layer.borderColor = COMMON_FIRST_RANK_NORMOALL_BG_COLOR.CGColor;
//            self.layer.borderWidth = 1.0f;
            [self setBackgroundColor:COMMON_FIRST_RANK_TOUCH_COLOR forState:UIControlStateHighlighted];
            [self setBackgroundColor:COMMON_FIRST_RANK_NORMOALL_BG_COLOR forState:UIControlStateNormal];
            [self setBackgroundColor:COMMON_FIRST_RANK_NOT_ACTIVITYED_BG_COLOR forState:UIControlStateDisabled];
            
            [self setTitleColor:COMMON_WHITE_COLOR forState:UIControlStateNormal];
            [self setTitleColor:COMMON_GREY_WHITE_COLOR forState:UIControlStateHighlighted];
            [self setTitleColor:COMMON_GREY_WHITE_COLOR forState:UIControlStateDisabled];
        } else {
                //如：详情页
            [self setBackgroundColor:COMMON_FIRST_RANK_TOUCH_COLOR forState:UIControlStateHighlighted];
            [self setBackgroundColor:COMMON_FIRST_RANK_NORMOALL_BG_COLOR forState:UIControlStateNormal];
            [self setBackgroundColor:COMMON_GREY_COLOR forState:UIControlStateDisabled];
            
            [self setTitleColor:COMMON_WHITE_COLOR forState:UIControlStateNormal];
            [self setTitleColor:COMMON_GREY_WHITE_COLOR forState:UIControlStateHighlighted];
            [self setTitleColor:COMMON_GREY_WHITE_COLOR forState:UIControlStateDisabled];
        }
       
        
        [self setTitle:title forState:UIControlStateNormal];
       
        self.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
        
        //防重复点击
        [self addTarget:self action:@selector(firstActionRepeatDown:) forControlEvents:UIControlEventTouchUpInside];
//        [self addTarget:self action:@selector(firstBtnDown:) forControlEvents:UIControlEventTouchDown];
//        [self addTarget:self action:@selector(firstBtnCancel:) forControlEvents:UIControlEventTouchDragExit];
        
//        [self addTarget:self action:@selector(firstActionRepeatDown:) forControlEvents:UIControlEventTouchDownRepeat];
        _isResetState = YES;
        _isCornerRadius = cornerRadius;
    }
    
    return self;
}

    //双击
- (void)firstActionRepeatDown:(UIButton *)btn
{
    btn.enabled = NO;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(firstBtnClick:) object:btn];
    if (_clickHandle) {
        self.clickHandle(btn);
    }
    if (!_isResetState) {
        [self setBackgroundColor:COMMON_FIRST_RANK_NOT_ACTIVITYED_BG_COLOR forState:UIControlStateDisabled];

    } else {
        [self setBackgroundColor:COMMON_FIRST_RANK_TOUCH_COLOR forState:UIControlStateDisabled];

    }
    
//    btn.layer.borderColor = COMMON_FIRST_RANK_NORMOALL_BG_COLOR.CGColor;
//    [self firstBtnClick:btn];
     [self performSelector:@selector(firstBtnClick:) withObject:btn afterDelay:0.2];
    
}

- (void)firstBtnDown:(UIButton *)btn
{
//    self.enabled = NO;
    
    [self performSelector:@selector(firstBtnClick:) withObject:btn afterDelay:0.2];
    
//    btn.layer.borderColor = COMMON_FIRST_RANK_TOUCH_COLOR.CGColor;
}

//延迟修改按钮状态
- (void)firstBtnClick:(UIButton *)btn
{
//    if (_clickHandle) {
//        self.clickHandle(btn);
//    }
    if (_isResetState) { //默认点击之后恢复 状态，投资密码框 不恢复
        btn.enabled = YES;
        [btn setBackgroundColor:COMMON_FIRST_RANK_NOT_ACTIVITYED_BG_COLOR forState:UIControlStateDisabled];
    } else {
        btn.enabled = NO;

        [self setBackgroundColor:COMMON_FIRST_RANK_NOT_ACTIVITYED_BG_COLOR forState:UIControlStateDisabled];

    }
    
//    btn.layer.borderColor = COMMON_FIRST_RANK_NORMOALL_BG_COLOR.CGColor;
    
}


- (void)firstBtnCancel:(UIButton *)btn
{
    btn.layer.borderColor = COMMON_FIRST_RANK_NORMOALL_BG_COLOR.CGColor;
    self.enabled = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
