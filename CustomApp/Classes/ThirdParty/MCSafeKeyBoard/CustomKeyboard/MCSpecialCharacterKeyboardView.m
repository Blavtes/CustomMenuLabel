//
//  MCSpecialCharacterKeyboardView.m
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/18.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import "MCSpecialCharacterKeyboardView.h"
#import "MCImageButton.h"

@implementation MCSpecialCharacterKeyboardView

#pragma mark - 完成初始化操作方法，供外部调用

+ (instancetype)initSpecialCharacterKeyBoard
{
    MCSpecialCharacterKeyboardView *keyboardView = [[[NSBundle mainBundle] loadNibNamed:@"MCSpecialCharacterKeyboardView"
                                                                                  owner:nil
                                                                                options:nil] lastObject];
    
    return  [keyboardView initWithSpecialCharacterTitle];
}

#pragma mark - 初始化特殊字符键盘
- (instancetype)initWithSpecialCharacterTitle
{
    if (self = [super init]) {
    for (UIButton *btn in self.subviews) {
        NSInteger tagValue = btn.tag;
        if ((tagValue > 850 && tagValue < 879)|| (tagValue > 880 && tagValue < 888)) {
            [btn addTarget:self action:@selector(clickSpecialCharacterBtn:) forControlEvents:UIControlEventTouchUpInside];
            // 添加长摁手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickSpecialCharacterLongPressGesture:)];
            longPressGesture.minimumPressDuration = 0.1;
            [btn addGestureRecognizer:longPressGesture];
            NSString *imageName = @"CharacterKeyBoard_PopOut";
                // 长按后显示放大图片
            MCImageButton *button = (MCImageButton *)btn;
            if (button) {
                [button initImageName:imageName];
            }
//            NSLog(@"%ld",(long)btn.tag);
            
        }
        if (tagValue == 879) {
            [btn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (tagValue == 880) {
            [btn addTarget:self action:@selector(clickToNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (tagValue == 888) {
            [btn addTarget:self action:@selector(clickToCharacterBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
     
     }
        
    }
        
    return self;
}


#pragma mark - MCSpecialCharacterKeyboardDelegate

#pragma mark - 实现特殊字符键盘点击
/** 点击了特殊字符键盘的字符按钮 */
- (void)clickSpecialCharacterBtn:(MCImageButton *)specialCharacterBtn{
    
    if ([self.specialCharacterDelegate respondsToSelector:@selector(keyboard:didClickSpecialCharacterButton:)] && specialCharacterBtn) {
        [self.specialCharacterDelegate keyboard:self didClickSpecialCharacterButton:specialCharacterBtn];
    }
    
}

/** 长按了特殊字符键盘的字母按钮 */
- (void)clickSpecialCharacterLongPressGesture:(UILongPressGestureRecognizer *)longPressBtn
{

    if (longPressBtn.state == UIGestureRecognizerStateBegan ||longPressBtn.state == UIGestureRecognizerStateChanged ) {
        UIButton *btn = (UIButton*)longPressBtn.view;
        [btn setBackgroundImage:[UIImage imageNamed:@"Custom_CharacterKeyBoard_TouchDown_Icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"CharacterKeyBoard_WhiteBackground"] forState:UIControlStateHighlighted];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (longPressBtn.state == UIGestureRecognizerStateEnded || longPressBtn.state == UIGestureRecognizerStateCancelled){
        
        UIButton *btn = (UIButton*)longPressBtn.view;
        [btn setBackgroundImage:[UIImage imageNamed:@"CharacterKeyBoard_WhiteBackground"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"Custom_CharacterKeyBoard_TouchDown_Icon"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
       
    if ([self.specialCharacterDelegate respondsToSelector:@selector(keyboard:didLongPressSpecialCharacterButton:withGesture:)] && longPressBtn) {
        
        [self.specialCharacterDelegate keyboard:self didLongPressSpecialCharacterButton:(MCImageButton *)longPressBtn.view withGesture:longPressBtn];
        
    }
    
}
/** 点击了特殊字符键盘的删除按钮 */
- (void)clickDeleteBtn:(MCImageButton *)deleteBtn
{
    if ([self.specialCharacterDelegate respondsToSelector:@selector(keyboard:didClickDeleteButton:)] && deleteBtn) {
        [self.specialCharacterDelegate keyboard:self didClickDeleteButton:deleteBtn];
    }
    
}
/** 点击了特殊字符键盘的切换到数字键盘按钮 */
- (void)clickToNumberBtn:(MCImageButton *)toNumberBtn
{
    if ([self.specialCharacterDelegate respondsToSelector:@selector(keyboard:didClickToNumberButton:)] && toNumberBtn) {
        [self.specialCharacterDelegate keyboard:self didClickToNumberButton:toNumberBtn];
    }
    
}

/** 点击了特殊字符键盘的切换到字母键盘按钮 */
- (void)clickToCharacterBtn:(MCImageButton *)toCharacterBtn
{
    if ([self.specialCharacterDelegate respondsToSelector:@selector(keyboard:didClickToCharacterButton:)] && toCharacterBtn) {
        [self.specialCharacterDelegate keyboard:self didClickToCharacterButton:toCharacterBtn];
    }
    
}

@end
