//
//  MCCharacterKeyboardView.m
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/19.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import "MCCharacterKeyboardView.h"
#import "MCImageButton.h"
#import "MCKeyboardAccessoryView.h"

@interface MCCharacterKeyboardView ()

typedef NS_ENUM(NSInteger, ShiftClickState) {
    ShiftClickStateDefault = 0,       //默认
    ShiftClickStateOnce,              //单击切换成大写
    ShiftClickStateDouble              //双击固定大写
};
/** 小写字母键盘内容 */
@property (nonatomic, strong) NSMutableArray *lowerCharacterTitle;
/** 大写字母键盘内容 */
@property (nonatomic, strong) NSMutableArray *capitalCharacterTitle;

@property (weak, nonatomic) IBOutlet UIButton *shiftCharacterBtn;
@property (weak, nonatomic) IBOutlet UIButton *shiftNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *shiftSpecialCharacterBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *spaceBtn;
@property (assign,nonatomic) NSInteger shiftClickState;
@property (nonatomic, strong) UIView *longPressGesture;



@end

@implementation MCCharacterKeyboardView


#pragma mark - 完成初始化操作方法，供外部调用
+ (instancetype)initCharacterKeyBoard
{
    
    MCCharacterKeyboardView *keyboardView = [[[NSBundle mainBundle] loadNibNamed:@"MCCharacterKeyboardView"
                                                                           owner:nil
                                                                         options:nil] lastObject];
    
    return  [keyboardView initWithCharacterTitle];
}


#pragma mark - 初始化字母键盘
- (instancetype)initWithCharacterTitle
{

    if (self = [super init]) {
        
        self.lowerCharacterTitle = [[NSMutableArray alloc] initWithObjects:@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"xx",@"123",@"空格",@"*#.",nil];
        self.capitalCharacterTitle = [[NSMutableArray alloc] initWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"xx",@"123",@"空格",@"*#.",nil];
        
        // 没有按切换大小写键
       _shiftClickState = ShiftClickStateDefault;
        
    for (UIButton *btn in self.subviews) {
        NSInteger tagValue = btn.tag;
        if ((tagValue > 800 && tagValue < 820)|| (tagValue > 820 && tagValue < 828)) {
            // 监听点击
            [btn addTarget:self action:@selector(clickCharacterButton:) forControlEvents:UIControlEventTouchUpInside];
            // 添加长摁手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPressGesture:)];
            longPressGesture.minimumPressDuration = 0.1;
            [btn addGestureRecognizer:longPressGesture];
            // 关联放大的图片
            NSString *imageName = @"CharacterKeyBoard_PopOut";
            MCImageButton *button = (MCImageButton *)btn;
            if (button) {
                [button initImageName:imageName];
            }
            
        }
        
        if (tagValue == 820) {
            [btn addTarget:self action:@selector(clickShiftCharacterButton:) forControlEvents:UIControlEventTouchDown];
            
            [btn addTarget:self action:@selector(doubleClickShiftCharacterButton:) forControlEvents:UIControlEventTouchDownRepeat];
          
        }
        if (tagValue == 828) {
            [btn addTarget:self action:@selector(clickCharacterDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            }
        if (tagValue == 829) {
            [btn addTarget:self action:@selector(clickToNumberButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (tagValue == 830) {
            [btn addTarget:self action:@selector(clickSpaceButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (tagValue == 831) {
            [btn addTarget:self action:@selector(clickToSpecialButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
      }
    }
  
    return self;
}

/** 单击了字母键盘的切换大小写按钮 */
- (void)clickShiftCharacterButton:(UIButton *)shiftCharcterBtn {
    if (_shiftClickState == ShiftClickStateDouble) {
        [self performSelector:@selector(doubleClickShiftAction) withObject:nil afterDelay:0.2];
    }else {
        [self performSelector:@selector(clickShiftAction) withObject:nil afterDelay:0.2];
    }

    
}

// 单击shift在大小写之间切换
- (void) clickShiftAction {
    // 单击小写切换大写
 if(_shiftClickState == ShiftClickStateDefault) {
        for (UIButton *btn in self.subviews) {
            
            NSInteger tagValue = btn.tag - 801;
            if (tagValue >= 0 && tagValue <= 30) {
                if( [btn.currentTitle  isEqualToString: self.lowerCharacterTitle[tagValue]]){
                    
                    [btn setTitle:self.capitalCharacterTitle[tagValue] forState:UIControlStateNormal];
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
                }
            }
            
        }
        // 点击切换大小写按钮后更换图片
        [_shiftCharacterBtn setImage:[UIImage imageNamed:@"CharacterKeyBoard_Shift_Big"] forState:UIControlStateNormal];
        _shiftClickState = ShiftClickStateOnce;
     
 }else if (_shiftClickState == ShiftClickStateOnce ){
  // 单击大写切换小写
        for (UIButton *btn in self.subviews) {
            
            NSInteger tagValue = btn.tag - 801;
            if (tagValue >= 0 && tagValue <= 30) {
                if( [btn.currentTitle  isEqualToString: self.capitalCharacterTitle[tagValue]]){
                    
                    [btn setTitle:self.lowerCharacterTitle[tagValue] forState:UIControlStateNormal];
                    
                    
                }
            }
            
        }
        // 点击切换大小写按钮后更换图片
        [_shiftCharacterBtn setImage:[UIImage imageNamed:@"CharacterKeyBoard_Shift_Small"] forState:UIControlStateNormal];
        
        _shiftClickState = ShiftClickStateDefault;
     
 }


}

//双击shift后再单击，从大写切换小写
- (void)doubleClickShiftAction {
    for (UIButton *btn in self.subviews) {
        
        NSInteger tagValue = btn.tag - 801;
        if (tagValue >= 0 && tagValue <= 30) {
            if( [btn.currentTitle  isEqualToString: self.capitalCharacterTitle[tagValue]]){
                
                [btn setTitle:self.lowerCharacterTitle[tagValue] forState:UIControlStateNormal];
                
            }
        }
        
    };
    // 点击切换大小写按钮后更换图片
    [_shiftCharacterBtn setImage:[UIImage imageNamed:@"CharacterKeyBoard_Shift_Small"] forState:UIControlStateNormal];
    
    _shiftClickState = ShiftClickStateDefault;
}


/** 双击了字母键盘的切换大小写按钮 */
- (void)doubleClickShiftCharacterButton:(UIButton *)shiftCharcterBtn {
   
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clickShiftCharacterButton:) object:nil];
    for (UIButton *btn in self.subviews) {
        
        NSInteger tagValue = btn.tag - 801;
        if (tagValue >= 0 && tagValue <= 30) {
            if( [btn.currentTitle  isEqualToString: self.lowerCharacterTitle[tagValue]]){
                
                [btn setTitle:self.capitalCharacterTitle[tagValue] forState:UIControlStateNormal];
                
                btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            }
        }
        
    }
    // 点击切换大小写按钮后更换图片
    [_shiftCharacterBtn setImage:[UIImage imageNamed:@"CharacterKeyBoard_Shift_BigFixed"] forState:UIControlStateNormal];
    _shiftClickState = ShiftClickStateDouble;
    
}


#pragma mark -  ------------------  MCCharacterKeyboardDelegate --------------

#pragma mark - 实现字母键盘点击
/** 点击了字母键盘的字母按钮 */
- (void)clickCharacterButton:(MCImageButton *)charcterBtn
{
    
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didClickCharacterButton:)] && charcterBtn) {
        [self.characterDelegate keyboard:self didClickCharacterButton:charcterBtn];
    }
    if (_shiftClickState == ShiftClickStateOnce) {
        [self clickShiftCharacterButton:_shiftCharacterBtn];
    }
 
}

/** 长按了字母键盘的字母按钮 */
- (void)clickLongPressGesture:(UILongPressGestureRecognizer *)longPressBtn
{
   
    if (longPressBtn.state == UIGestureRecognizerStateBegan ||longPressBtn.state == UIGestureRecognizerStateChanged ) {
        _longPressGesture = longPressBtn.view;
        UIButton *btn = (UIButton*)longPressBtn.view;
        [btn setBackgroundImage:[UIImage imageNamed:@"Custom_CharacterKeyBoard_TouchDown_Icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"CharacterKeyBoard_WhiteBackground"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (longPressBtn.state == UIGestureRecognizerStateEnded || longPressBtn.state == UIGestureRecognizerStateCancelled){
    
        UIButton *btn = (UIButton*)longPressBtn.view;
        [btn setBackgroundImage:[UIImage imageNamed:@"CharacterKeyBoard_WhiteBackground"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"Custom_CharacterKeyBoard_TouchDown_Icon"] forState:UIControlStateHighlighted];
         [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 大写字母状态，长按字母后，返回小写
        if ( _longPressGesture == longPressBtn.view) {
            
            if (_shiftClickState == ShiftClickStateOnce ){
                // 单击大写切换小写
                for (UIButton *btn in self.subviews) {
                    
                    NSInteger tagValue = btn.tag - 801;
                    if (tagValue >= 0 && tagValue <= 30) {
                        if( [btn.currentTitle  isEqualToString: self.capitalCharacterTitle[tagValue]]){
                            
                            [btn setTitle:self.lowerCharacterTitle[tagValue] forState:UIControlStateNormal];
                            
                            
                        }
                    }
                    
                }
                // 点击切换大小写按钮后更换图片
                [_shiftCharacterBtn setImage:[UIImage imageNamed:@"CharacterKeyBoard_Shift_Small"] forState:UIControlStateNormal];
                
                _shiftClickState = ShiftClickStateDefault;
                
            }
        }
        
    }
    
    
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didLongPressCharacterButton:withGesture:)] && longPressBtn) {
        
        [self.characterDelegate keyboard:self didLongPressCharacterButton:(MCImageButton *)longPressBtn.view withGesture:longPressBtn];
    }
    
  
}


/** 点击了字母键盘的删除按钮 */
- (void)clickCharacterDeleteButton:(MCImageButton *)characterDeleteBtn{
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didClickCharacterDeleteBtn:)] && characterDeleteBtn) {
        [self.characterDelegate keyboard:self didClickCharacterDeleteBtn:characterDeleteBtn];
    }
}

/** 点击了字母键盘的切换成数字按钮 */
- (void)clickToNumberButton:(MCImageButton *)toNumberBtn
{
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didClickNumberBtn:)] && toNumberBtn) {
        [self.characterDelegate keyboard:self didClickNumberBtn:toNumberBtn];
    }
    // 切回到小写状态
//    if (_shiftClickState != ShiftClickStateDefault) {
//        [self doubleClickShiftAction];
//    }
    
}
/** 点击了字母键盘的空格按钮 */
- (void)clickSpaceButton:(MCImageButton *)spaceBtn
{
    
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didClickSpaceButton:)] && spaceBtn) {
        [self.characterDelegate keyboard:self didClickSpaceButton:spaceBtn];
    }
}

/** 点击了字母键盘切换成特殊字符按钮 */
- (void)clickToSpecialButton:(MCImageButton *)toSpecialBtn
{
    if ([self.characterDelegate respondsToSelector:@selector(keyboard:didClickSpecialCharacterBtn:)] && toSpecialBtn) {
        [self.characterDelegate keyboard:self didClickSpecialCharacterBtn:toSpecialBtn];
    }
    
    // 切回到小写状态
//    if (_shiftClickState != ShiftClickStateDefault) {
//        [self doubleClickShiftAction];
//    }
}




@end
