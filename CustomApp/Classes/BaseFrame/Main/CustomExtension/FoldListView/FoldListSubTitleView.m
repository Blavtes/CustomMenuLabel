//
//  FoldListSubTitleView.m
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "FoldListSubTitleView.h"
#import "CustomImgBgLabel.h"

@interface FoldListSubTitleView () {
    //
}
//  折叠Block
@property (copy, nonatomic) TouchBtnBlock touchBtnBlock;

@end

@implementation FoldListSubTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initBaseView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title
              withArrowStatus:(FoldBtnStatus)btnStatus
            withTouchBtnBlock:(TouchBtnBlock)touchBtnBlock
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //  default setting
        
        self.backgroundColor = COMMON_GREY_WHITE_COLOR;
        
        [self initBaseView];
        
        _titleLb.text = title;
        
        _btnStatus = btnStatus;
        
        if (_btnStatus == FoldBtnStatusShowed) {
            [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateNormal];
            [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateHighlighted];
        } else {
            [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
            [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateHighlighted];
        }
        
        if (touchBtnBlock) {
            _touchBtnBlock = touchBtnBlock;
        }
        
    }
    
    return self;
}

- (void)initBaseView
{
    //  lineView
    UIView *lineTopInView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, .5f)];
    lineTopInView.backgroundColor = COMMON_LIGHT_GREY_COLOR;
    [self addSubview:lineTopInView];
    
    UIView *lineBottomInView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, .5f)];
    lineBottomInView.backgroundColor = COMMON_LIGHT_GREY_COLOR;
    [self addSubview:lineBottomInView];
    
    //  基础UI
    UIImage *img = [UIImage imageNamed:@"product_type_flag"];
    _imgView = [[UIImageView alloc] initWithImage:img];
    _imgView.frame = CGRectMake(10, (self.height - img.size.height) * .5f, img.size.width, img.size.height);
    [self addSubview:_imgView];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(img.size.width + 15, 10, 80, CommonLbHeight)];
    _titleLb.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    _titleLb.textColor = COMMON_BLUE_GREEN_COLOR;
    [self addSubview:_titleLb];
    
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.x + 80, _titleLb.y + 2.0f, MAIN_SCREEN_WIDTH *.5f, CommonLbHeight)];
    _detailLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    _detailLb.textColor = COMMON_GREY_COLOR;
    [self addSubview:_detailLb];
    
    UIImage *arrowBtnImg = [UIImage imageNamed:@"common_arrow_up"];
    _foldBtn = [UIButton btnWithImageName:@"common_arrow_up" position:CGPointMake(self.width - 50, (self.height - arrowBtnImg.size.height) * .5f) taget:self action:@selector(touchBtn:)];
    [self addSubview:_foldBtn];
    
    _btnStatus = FoldBtnStatusShowed;
    
    //  tap事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBtn:)];
    [self addGestureRecognizer:tapGR];
    
#pragma mark - 可购买数量 - V3.2
    UIImage *bgImg = [UIImage imageNamed:@"product_lastValue_icon"];
    _imgBgLb = [CustomImgBgLabel initWithImage:bgImg andPosition:CGPointMake(self.width - 50 - bgImg.size.width, (self.height - bgImg.size.height) * .5f)];
    _imgBgLb.textLb.text = @"0";
    _imgBgLb.textLb.textAlignment = NSTextAlignmentCenter;
    _imgBgLb.textLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    _imgBgLb.textLb.textColor = COMMON_ORANGE_COLOR;
    [self addSubview:_imgBgLb];
}

- (void)touchBtn:(id)sender
{
    if (_btnStatus == FoldBtnStatusClosed) {
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateNormal];
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateHighlighted];
        
        _btnStatus = FoldBtnStatusShowed;
    } else {
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateHighlighted];
        
        _btnStatus = FoldBtnStatusClosed;
    }
    
    if (_touchBtnBlock) {
        _touchBtnBlock(_btnStatus);
    }
}

#pragma mark - lazyLoad
- (void)setBtnStatus:(FoldBtnStatus)btnStatus
{
    _btnStatus = btnStatus;
    
    if (_btnStatus == FoldBtnStatusShowed) {
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateNormal];
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_up"] forState:UIControlStateHighlighted];
    } else {
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
        [_foldBtn setBackgroundImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateHighlighted];
    }
}
@end
