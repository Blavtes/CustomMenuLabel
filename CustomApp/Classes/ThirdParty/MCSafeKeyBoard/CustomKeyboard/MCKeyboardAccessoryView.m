

#import "MCKeyboardAccessoryView.h"
#import "UIView+Extension.h"

// 键盘顶部的高度
static CGFloat const kTopKeyboardHeigth = 39.0f;
// 分割线的高度
//static CGFloat const kLineHeight = 1.0f;
// logo图标距离左边边距
static CGFloat const kLogoGap = 7.0f;
// label文字距离logo图标的距离
static CGFloat const kLabelGap = 8.0f;
// 键盘顶端字体
static CGFloat const kLabelFont = 14.0f;


@interface MCKeyboardAccessoryView()


@end

@implementation MCKeyboardAccessoryView



+ (instancetype)initKeyBoardAccessory
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0,
                                                  MAIN_SCREEN_WIDTH, kTopKeyboardHeigth)];
}

#pragma mark - 初始化自定义键盘辅助输入框的尺寸
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 背景颜色
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        
        // 分割线
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
//        line.backgroundColor = [UIColor darkGrayColor];
//        [self addSubview:line];
        
        // 文字
        CGFloat titleX = (0.6*self.frame.size.height + kLabelGap) + kLogoGap *2;
        CGFloat titleY = 0;
        CGFloat titleW = self.width ;
        CGFloat titleH = self.height;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        label.text = @"正在使用广金所安全键盘";
        label.font = [UIFont systemFontOfSize:kLabelFont];
        label.textColor = [UIColor colorWithRed:60/255.0 green:60/255.0  blue:60/255.0  alpha:1.0];
        [self addSubview:label];
        
        
        // 完成按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((315 / 375.0)*self.frame.size.width  , 0, self.frame.size.height, self.frame.size.height)];
        [btn setImage:[UIImage imageNamed:@"AccessoryView_Finish_Normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"AccessoryView_Finish_TouchDown"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(accessoryBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.clipsToBounds = YES;
        
        // logo图标
        UIImage *iconImage = [UIImage imageNamed:@"Custom_KeyBoard_Logo_Icon"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
        iconImageView.frame = CGRectMake(kLogoGap, 0.1*self.frame.size.height, 0.8*self.frame.size.height, 0.8*self.frame.size.height);
        [self addSubview:iconImageView];
        
 
 
    }
    return self;
}

#pragma mark - 监听自定义键盘辅助输入框的点击

- (void)accessoryBtnDidClick:(UIButton *)finishButton {
    
    if ([self.accessaryBtnDelegate respondsToSelector:@selector(accessaryBtn:didClickFinishButton:)]) {
        [self.accessaryBtnDelegate accessaryBtn:self didClickFinishButton:finishButton];
    
    }
}

@end
