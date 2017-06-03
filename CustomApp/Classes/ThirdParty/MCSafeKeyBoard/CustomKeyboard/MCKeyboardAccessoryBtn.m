

#import "MCKeyboardAccessoryBtn.h"
#import "UIView+Extension.h"

// 键盘顶部的高度
static CGFloat const kTopKeyboardHeigth = 50.0f;
// 分割线的高度
static CGFloat const kLineHeight = 1.0f;
// logo图标距离左边边距
static CGFloat const kLogoGap = 5.0f;
// label文字距离logo图标的距离
static CGFloat const kLabelGap = 10.0f;
// 键盘顶端字体
static CGFloat const kLabelFont = 18.0f;


@interface MCKeyboardAccessoryBtn()
// 分割线属性
@property (nonatomic, weak) UIView *line;
@end

@implementation MCKeyboardAccessoryBtn



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
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:248/255.0 alpha:1];
        
        // 分割线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:line];
        self.line = line;
        
       // titleLabel文字
        NSString *btnTitle = @"正在使用广金所安全键盘";
        [self setTitle:btnTitle forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:kLabelFont];
        [self setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0  blue:60/255.0  alpha:1.0] forState:UIControlStateNormal];
        
       // image背景图片
//        UIImage *image = [UIImage imageNamed:@"login_c_character_keyboardLoginButton"];
//        image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.1  topCapHeight:image.size.height * 0.1 ];
//        [self setImage:image forState:UIControlStateNormal];
//        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        // 完成按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((315 / 375.0)*self.frame.size.width  , 0, self.frame.size.height, self.frame.size.height)];
        [btn setImage:[UIImage imageNamed:@"Custom_KeyBoard_Down_Icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(accessoryBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.clipsToBounds = YES;
        
        // logo图标
        UIImage *iconImage = [UIImage imageNamed:@"Custom_KeyBoard_Logo_Icon"];
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
        iconImageView.frame = CGRectMake(kLogoGap, 0.2*self.frame.size.height, 0.6*self.frame.size.height, 0.6*self.frame.size.height);
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

#pragma mark -  布局自定义键盘辅助输入框的子控件
- (void)layoutSubviews {
    [super layoutSubviews];
     self.line.frame = CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight);

    CGFloat titleX = 0.6*self.height + kLabelGap;
    CGFloat titleY = 0;
    CGFloat titleW = self.width ;
    CGFloat titleH = self.height;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.width ;
    CGFloat imageH = self.height;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
}


@end
