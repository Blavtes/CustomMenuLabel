//
//  CustomNavTopView.m
//  GjFax
//
//  Created by Blavtes on 2017/3/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomNavTopView.h"


@implementation CustomNavTopView

- (instancetype)initWithTitle:(NSString *)title backClickHandle:(BackClickHandle)handle
{
    return [self initWithTitle:title showBackImage:YES rightTitle:nil backClickHandle:handle rightClickHandle:nil];
}

- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightClickHandle:(RightClickHandle)rightClick
{
    return [self initWithTitle:title showBackImage:NO rightTitle:rightTitle backClickHandle:nil rightClickHandle:rightClick];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightTitle:(NSString *)rightTitle backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick
{
    if (self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 64)]) {
        self.backgroundColor = COMMON_BLUE_GREEN_COLOR;
        
        if (show) {
            [self showBackHandle:handle];
        }
        
        [self showTitle:title];
        
        
        if (rightTitle.length > 0) {
            [self showRightTitle:rightTitle];
        }
        _backClick = handle;
        _rightClick = rightClick;
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick
{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 64)]) {
        self.backgroundColor = COMMON_BLUE_COLOR;
        
        if (show) {
            [self showBackHandle:handle];
        }
        
        [self showTitle:title];
        
        
        [self showRightBtnNorImageName:rightNor highlight:rightHight];
        
        _backClick = handle;
        _rightClick = rightClick;
        
    }
    return self;
}

- (void)showRightTitle:(NSString *)rightTitle
{
    
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    [self.rightBtn setImage:nil forState:UIControlStateHighlighted];
    
    [self.rightBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
    CGSize kTitleSize = [rightTitle getTextSize:kCommonFontSizeSubDesc_14 maxWidth:88];
    _rightBtn.size = CGSizeMake(kTitleSize.width, 44);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    [_rightBtn setFrame:CGRectMake(MAIN_SCREEN_WIDTH - 20 - _rightBtn.size.width, 20, _rightBtn.size.width, _rightBtn.size.height)];
    [_rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)showRightBtnNorImageName:(NSString *)nor highlight:(NSString *)highlight
{
    
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];

    [_rightBtn setImage:[UIImage imageWithName:nor] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageWithName:highlight] forState:UIControlStateHighlighted];
    
    //  设置大小
    //_rightBtn.size = _rightBtn.currentBackgroundImage.size;
    
    //  按钮点击高光
    _rightBtn.showsTouchWhenHighlighted = YES;
    
    //  监听点击事件
    _rightBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH - 40, 22, 40, 40);
    
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(rightHandleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _rightBtn = btn;
    }
    return _rightBtn;
}

- (void)rightHandleClick:(id)sender
{
    if (_rightClick) {
        self.rightClick(sender);
    }
}

- (void)showRightTitle:(NSString *)title rightHandle:(RightClickHandle)handle
{
    [self showRightTitle:title];
    _rightClick = handle;
}

- (void)showRightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight rightHandle:(RightClickHandle)handle
{
    [self showRightBtnNorImageName:rightNor highlight:rightHight];
    _rightClick = handle;
}

- (void)showTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 27, MAIN_SCREEN_WIDTH - 80, 30)];
        label.font = [UIFont boldSystemFontOfSize:kCommonFontSizeTitle_18];
        label.textColor = COMMON_WHITE_COLOR;
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
//        label.adjustsFontSizeToFitWidth = YES;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (void)showBackHandle:(BackClickHandle)handle
{
    [self backBtn];
    _backClick = handle;
}

- (void)showBackTitle:(NSString *)title backHandle:(BackClickHandle)handle
{
    [self.backBtn setImage:nil forState:UIControlStateNormal];
    [self.backBtn setImage:nil forState:UIControlStateHighlighted];
    
    [self.backBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
    CGSize kTitleSize = [title getTextSize:kCommonFontSizeSubDesc_14 maxWidth:88];
    self.backBtn.size = CGSizeMake(kTitleSize.width, 44);
    self.backBtn.center = CGPointMake(36, 38);
    
    [self.backBtn  setTitle:title forState:UIControlStateNormal];
    _backClick = handle;
}

- (void)showBackImageName:(NSString *)backNor backHighlightImageName:(NSString *)backHight backHandle:(BackClickHandle)handle
{
    [self showRightBtnNorImageName:backNor highlight:backHight];
    _backClick = handle;
}

- (void)showBackBtnNorImageName:(NSString *)nor highlight:(NSString *)highlight
{
    
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    
    [self.backBtn setImage:[UIImage imageWithName:nor] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageWithName:highlight] forState:UIControlStateHighlighted];
    
    //  设置大小
    //_rightBtn.size = _rightBtn.currentBackgroundImage.size;
    
    //  按钮点击高光
    self.backBtn.showsTouchWhenHighlighted = YES;
    
    //  监听点击事件
    self.backBtn.center = CGPointMake(6, 22);
    //  设置大小
    self.backBtn.size = CGSizeMake(40, 40);
    
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        //  设置背景图片
        UIButton *backBtn = [[UIButton alloc] init];
        
        [backBtn setImage:[UIImage imageWithName:@"btn_navi_back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageWithName:@"btn_navi_back_selected"] forState:UIControlStateHighlighted];
        backBtn.center = CGPointMake(6, 22);
        //  设置大小
        backBtn.size = CGSizeMake(40, 40);
        //  按钮点击高光
       // backBtn.showsTouchWhenHighlighted = YES;
        
        //  监听点击事件
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:backBtn];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (void)backAction:(id)sender
{
    if (_backClick) {
        self.backClick(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)hideBack
{
    self.backBtn.hidden = YES;
}

- (void)itemWithTaget:(id)taget backHandle:(BackClickHandle)handle
{
    _loginBtn = nil;
    _backClick = handle;
    self.backBtn.hidden = YES;
    self.loginBtn.hidden = NO;
    
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.center = CGPointMake(36, 38);
        //  设置大小
        loginBtn.size = CGSizeMake(40, 40);
        [self addSubview:loginBtn];
        _loginBtn = loginBtn;
    }
    return _loginBtn;
}

- (UIButton *)closeAllBtn
{
    if (!_closeAllBtn) {
        UIButton *closeAllBtn = [[UIButton alloc] init];
        
        [closeAllBtn setImage:[UIImage imageWithName:@"webView_CloseAll"] forState:UIControlStateNormal];
        [closeAllBtn setImage:[UIImage imageWithName:@"CloseAll_Selected"] forState:UIControlStateHighlighted];
        closeAllBtn.center = CGPointMake(55, 22);
        //  设置大小
        closeAllBtn.size = CGSizeMake(40, 40);
        //  按钮点击高光
        // backBtn.showsTouchWhenHighlighted = YES;
        
        //  监听点击事件
        [closeAllBtn addTarget:self action:@selector(closeAllAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeAllBtn];
        _closeAllBtn = closeAllBtn;
    }
    return _closeAllBtn;
}

- (UIView *)closeLine
{
    if (!_closeLine) {
        //  设置背景图片
        UIView *line = [[UIView alloc] init];
        
        line.userInteractionEnabled = NO;
        line.backgroundColor = COMMON_GREY_WHITE_COLOR;
        
        line.center = CGPointMake(47, 32);
        line.size = CGSizeMake(0.5, 20);
        line.alpha = 0.8;
        [self addSubview:line];
        _closeLine = line;
    }
    
    return _closeLine;
}

- (void)closeAllAction:(UIButton *)btn
{
    if (self.closeAllClick) {
        self.closeAllClick(btn);
    }
}

- (void)showCloseAllClickHandle:(CloseAllClickHandle)close
{
    //  中间的竖线
//    self.lineBarBtn = [self itemWithImageName:@"webView_Line"];
    self.closeAllBtn.hidden = NO;
    self.closeLine.hidden = NO;
    _closeAllClick = close;
   
    [self checkoutTitleFrame];
}

//web view 调整title frame
- (void)checkoutTitleFrame
{
    CGSize size = [self.titleLabel.text strSizeWithFont:kCommonFontSizeTitle_18 maxSize:CGSizeMake(MAIN_SCREEN_WIDTH , 30)];
    if (size.width > MAIN_SCREEN_WIDTH - 180) {
        self.titleLabel.frame = CGRectMake(90, 27, MAIN_SCREEN_WIDTH - 90 - 40, 30);
    } else {
        self.titleLabel.frame = CGRectMake(90, 27, MAIN_SCREEN_WIDTH - 180, 30);
    }
}

- (void)hideCloseAll
{
    self.closeAllBtn.hidden = YES;
    self.closeLine.hidden = YES;
}

@end
