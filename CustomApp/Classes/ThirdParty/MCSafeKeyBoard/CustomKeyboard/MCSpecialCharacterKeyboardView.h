//
//  MCSpecialCharacterKeyboardView.h
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/18.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCImageButton.h"

@class MCSpecialCharacterKeyboardView;
@protocol MCSpecialCharacterKeyboardDelegate <NSObject>
@optional
/** 点击了特殊字符键盘的字符按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickSpecialCharacterButton:(MCImageButton *)specialCharacterBtn;
/** 长按了字母键盘的字母按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didLongPressSpecialCharacterButton:(MCImageButton *)longPressBtn withGesture:(UIGestureRecognizer *)gesture;
/** 点击了特殊字符键盘的删除按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickDeleteButton:(MCImageButton *)deleteBtn;
/** 点击了特殊字符键盘的切换成数字按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickToNumberButton:(MCImageButton *)toNumberBtn;
/** 点击了特殊字符键盘的切换成字母按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickToCharacterButton:(MCImageButton *)toCharacterBtn;
@end


@interface MCSpecialCharacterKeyboardView : UIView
/** 代理属性 */
@property (nonatomic, weak) id <MCSpecialCharacterKeyboardDelegate>specialCharacterDelegate;
/** 初始化方法 */
+ (instancetype)initSpecialCharacterKeyBoard;

@end
