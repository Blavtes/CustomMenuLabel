//
//  CheckUpdateAlertView.m
//  GjFax
//
//  Created by gjfax on 16/8/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CheckUpdateAlertView.h"
#import <Masonry.h>

static const CGFloat kSpaceFloat = 30.0f;
static const CGFloat kSpaceRange = 15.0f;

@interface CustomAlertView() {
    //  ..
}
@end

@implementation CheckUpdateAlertView

- (instancetype)initWithCompletionBlock:(ConfirmBlock)completionBlock
{
    self = [super initWithFrame:MAIN_SCREEN_BOUNDS];
    
    if (self) {
        //  基础属性
        self.backgroundColor = [UIColor colorWithWhite:0.35f alpha:0.5f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
        [self addGestureRecognizer:tap];
        
        //  背景
        //  4s或者5系列手机改变背景大小
        if (isRetina || iPhone5) {
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat,MAIN_SCREEN_HEIGHT * 145.f/737.f , MAIN_SCREEN_WIDTH - kSpaceFloat * 2.0f,MAIN_SCREEN_HEIGHT * 410.f/737.f)];
            [self addSubview:bgView];
            bgView.backgroundColor = COMMON_GREY_WHITE_COLOR;
            bgView.layer.cornerRadius = 6.0f;
            bgView.layer.masksToBounds = YES;
            
            self.confirmBlock = completionBlock;
            
            [self configTitleView:bgView];
            
        } else {
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kSpaceFloat,MAIN_SCREEN_HEIGHT * 145.f/737.f , MAIN_SCREEN_WIDTH - kSpaceFloat * 2.0f,MAIN_SCREEN_HEIGHT * 360.f/736.f)];
            [self addSubview:bgView];
            bgView.backgroundColor = COMMON_GREY_WHITE_COLOR;
            bgView.layer.cornerRadius = 6.0f;
            bgView.layer.masksToBounds = YES;
            
            self.confirmBlock = completionBlock;
            
            [self configTitleView:bgView];
            
        }
    }
    
    return self;
}

- (void)configTitleView:(UIView *)bgView
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.width,MAIN_SCREEN_HEIGHT * 100/736.f)];
    titleImageView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:titleImageView];
    titleImageView.image = [UIImage imageNamed:@"checkIsUpdateAlertTitle"];
    
    self.closeBtn = [[UIButton alloc]init];
    [self addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"checkIsUpdateAlertClose"] forState:UIControlStateNormal];
    [self.closeBtn setImage:[UIImage imageNamed: @"checkIsUpdateAlertCloseWhenTouch"] forState:UIControlStateHighlighted];
    [self.closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(bgView.mas_right);
        make.centerY.equalTo(bgView.mas_top);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        
    }];
    
//    UIButton *completeBtn = [UIButton btnWithTitle:@"立即升级" rect:CGRectMake(kSpaceRange,bgView.height - MAIN_SCREEN_HEIGHT * 50.0f/736.f - kSpaceRange ,bgView.width - kSpaceRange * 2.0f, MAIN_SCREEN_HEIGHT * 50.0f/736.f) taget:self action:@selector(completion)];
//    [bgView addSubview:completeBtn];
    
    CustomFirstRateButton *completeBtn = [[CustomFirstRateButton alloc] initWithFrame:CGRectMake(kSpaceRange,bgView.height - MAIN_SCREEN_HEIGHT * 50.0f/736.f - kSpaceRange ,bgView.width - kSpaceRange * 2.0f, MAIN_SCREEN_HEIGHT * 50.0f/736.f) title:@"立即升级" cornerRadius:YES];
    completeBtn.clickHandle = ^(UIButton *btn) {
        [self completion];
    };
    [bgView addSubview:completeBtn];
    
    self.decScrollView = [[UIScrollView alloc]init];
    [bgView addSubview:self.decScrollView];
    self.decScrollView.frame = CGRectMake(bgView.frame.origin.x - 15, titleImageView.bottom, bgView.size.width - 30, bgView.size.height - 10 -titleImageView.height - completeBtn.height - 30);
    self.decScrollView.showsVerticalScrollIndicator = NO;
    self.decScrollView.showsHorizontalScrollIndicator = NO;
    self.decScrollView.userInteractionEnabled = YES;
    
    _decLable = [[UILabel alloc] init];
    [self.decScrollView addSubview:_decLable];
    _decLable.backgroundColor = COMMON_GREY_WHITE_COLOR;
    _decLable.textColor = COMMON_BLACK_COLOR;
    if (isRetina || iPhone5) {
        _decLable.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    } else {
        _decLable.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    }
    [_decLable setContentMode:UIViewContentModeTopLeft];
    
    self.decScrollView.contentSize = CGSizeMake(self.decScrollView.width, MAXFLOAT);
    
}

- (void)completion
{
    if (self.confirmBlock) {
        self.confirmBlock(self);
    }
}

- (void)dismiss
{
    [super dismiss];
    
    [self removeFromSuperview];
}


@end

