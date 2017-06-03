

#import "MCNumberKeyboardView.h"
#import "MCKeyboardAccessoryView.h"

// 键盘整体的高度
static CGFloat const kKeyboardHeigth = 237.0f;

@interface MCNumberKeyboardView ()

/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;
/** ABC按钮 */
@property (nonatomic, weak) UIButton *symbolBtn;

@end


@implementation MCNumberKeyboardView

#pragma mark - 初始化对象方法的实现
- (instancetype)initWithNumberKeyboard
{
    MCNumberKeyboardView *numberKeyboardView = [[MCNumberKeyboardView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kKeyboardHeigth)];
    return numberKeyboardView;
}

#pragma mark - 初始化尺寸
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置view背景颜色
        self.backgroundColor = [UIColor colorWithRed:208/255.0 green:216/255.0 blue:225/255.0 alpha:1];

        // 普通数字按钮
        UIImage *numberImage = [UIImage imageNamed:@"NumberKeyBoard_Number_WhiteBackground"];
        numberImage = [numberImage stretchableImageWithLeftCapWidth:numberImage.size.width * 0.5 topCapHeight:numberImage.size.height * 0.5];
        UIImage *highImage = [UIImage imageNamed:@"NumberKeyBoard_Number_TouchDown"];
        highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
        [self setupTopButtonsWithImage:numberImage highImage:highImage];
        
        
        // 切换到字母键盘按钮
        UIImage *shiftImage = [UIImage imageNamed:@"NumberKeyBoard_Number_GrayBackground"];
        shiftImage = [shiftImage stretchableImageWithLeftCapWidth:shiftImage.size.width * 0.5 topCapHeight:shiftImage.size.height * 0.5];
        self.symbolBtn = [self setupBottomButtonWithTitle:@"ABC" image:shiftImage highImage:highImage];
        self.symbolBtn.contentMode = UIViewContentModeCenter;
        [self.symbolBtn addTarget:self action:@selector(changeToCharacterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 删除按钮
        UIImage *deleteImage = [UIImage imageNamed:@"NumberKeyBoard_Back_Normal"];
        UIImage *deleteHighImage = [UIImage imageNamed:@"NumberKeyBoard_Back_TouchDown"];
        self.deleteBtn = [self setupBottomButtonWithTitle:nil image:deleteImage highImage:deleteHighImage];
        self.deleteBtn.contentMode = UIViewContentModeCenter;
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
       
        
    }
    return self;
}

#pragma mark - 创建顶部数字按钮
- (void)setupTopButtonsWithImage:(UIImage *)image highImage:(UIImage *)highImage {
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM removeAllObjects];
    for (int i = 0 ; i < 10; i++) {
        
        int j = arc4random_uniform(10);
        NSNumber *number = [[NSNumber alloc] initWithInt:j];
        if ([arrM containsObject:number]) {
            i--;
            continue;
        }
        [arrM addObject:number];
    }
    
    for (int i = 0 ; i < 10; i++) {
       
        UIButton *numBtn = [[UIButton alloc] init];
        NSNumber *number = arrM[i];
        NSString *title = number.stringValue;
        [numBtn setTitle:title forState:UIControlStateNormal];
        [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [numBtn setBackgroundImage:image forState:UIControlStateNormal];
        [numBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
//        [numBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numBtn];
    }
}




#pragma mark - 创建底部的删除按钮和切换按钮（带两张背景图片和文字）
- (UIButton *)setupBottomButtonWithTitle:(NSString *)title image:(UIImage *)image  highImage:(UIImage *)highImage{
    
    UIButton *bottomBtn = [[UIButton alloc] init];
    if (title) {
        [bottomBtn setTitle:title forState:UIControlStateNormal];
        bottomBtn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
        [bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (image) {
        [bottomBtn setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    
    if (highImage) {
        [bottomBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    }
    [self addSubview:bottomBtn];
    return bottomBtn;
}

#pragma mark - 布局按钮的位置
- (void)layoutSubviews {

    CGFloat topMargin = 5.0f;
    CGFloat bottomMargin = 3.0f;
    CGFloat leftMargin = 5.0f;
    CGFloat colMargin = 5.0f;
    CGFloat rowMargin = 4.0f;
    
    CGFloat topBtnW = (self.width - 2 * leftMargin - 2 * colMargin) / 3.0f;
    CGFloat topBtnH = (self.height - topMargin - bottomMargin - 3 * rowMargin) / 4.0f;

    NSUInteger count = self.subviews.count;
    
    // 布局数字按钮
    for (NSUInteger i = 0; i < count; i++) {
        if (i == 0 ) { // 0
            UIButton *buttonZero = self.subviews[i];
            buttonZero.height = topBtnH;
            buttonZero.width = topBtnW;
            buttonZero.centerX = self.centerX;
            buttonZero.centerY = self.height - bottomMargin - buttonZero.height * 0.5;
            
            // 符号、文字及删除按钮的位置
            self.deleteBtn.x = CGRectGetMaxX(buttonZero.frame) + colMargin;
            self.deleteBtn.y = buttonZero.y;
            self.deleteBtn.width = buttonZero.width;
            self.deleteBtn.height = buttonZero.height;
            
            self.symbolBtn.x = leftMargin;
            self.symbolBtn.y = buttonZero.y;
            self.symbolBtn.width = buttonZero.width ;
            self.symbolBtn.height = buttonZero.height;
          
        }
        if (i > 0 && i < 10) { // 0 ~ 9
            
            UIButton *topButton = self.subviews[i];
            CGFloat row = (i - 1) / 3;
            CGFloat col = (i - 1) % 3;
            
            topButton.x = leftMargin + col * (topBtnW + colMargin);
            topButton.y = topMargin + row * (topBtnH + rowMargin);
            topButton.width = topBtnW;
            topButton.height = topBtnH;
        }
        
    }
    
}

#pragma mark -     MCNumberKeyboardDelegate

#pragma mark - 监听删除按钮的点击，进行回调
- (void)deleteBtnClick:(UIButton *)deleteBtn {
    
    if ([self.numberDelegate respondsToSelector:@selector(keyboard:didClickDeleteBtn:)] && deleteBtn) {
        [self.numberDelegate keyboard:self didClickDeleteBtn:deleteBtn];
    }
}

#pragma mark - 监听切换成字母按钮的点击，进行回调
- (void)changeToCharacterBtnClick:(UIButton *)toCharacterBtn {
    
    if ([self.numberDelegate respondsToSelector:@selector(keyboard:didClickToCharacterBtn:)] && toCharacterBtn) {
        [self.numberDelegate keyboard:self didClickToCharacterBtn:toCharacterBtn];
    }
}

#pragma mark - 监听数字按钮点击，进行回调
- (void)numBtnClick:(UIButton *)numBtn {
    
    if ([self.numberDelegate respondsToSelector:@selector(keyboard:didClickButton:)] && numBtn) {
        [self.numberDelegate keyboard:self didClickButton:numBtn];
    }
}

@end
