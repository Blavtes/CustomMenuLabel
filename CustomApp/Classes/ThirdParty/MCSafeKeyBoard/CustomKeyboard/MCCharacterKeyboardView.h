//
//  MCCharacterKeyboardView.h
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/19.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCImageButton.h"

@class MCCharacterKeyboardView;
@protocol MCCharacterKeyboardDelegate <NSObject>
@optional


/** 点击了字母键盘的字母按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickCharacterButton:(MCImageButton *)characterBtn;
/** 长按了字母键盘的字母按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didLongPressCharacterButton:(MCImageButton *)characterBtn withGesture:(UIGestureRecognizer *)gesture;
/** 点击了字母键盘的删除按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickCharacterDeleteBtn:(MCImageButton *)characterDeleteBtn;
/** 点击了字母键盘的切换成数字按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickNumberBtn:(MCImageButton *)toNumberBtn;
/** 点击了字母键盘的空格按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickSpaceButton:(MCImageButton *)spaceBtn;
/** 点击了字母键盘切换成特殊字符按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickSpecialCharacterBtn:(MCImageButton *)toSpecialCharacerBtn;

@end

@interface MCCharacterKeyboardView : UIView

/** 字母键盘代理属性 */
@property (nonatomic, weak) id<MCCharacterKeyboardDelegate> characterDelegate;

/** 初始化类方法 */
+ (instancetype)initCharacterKeyBoard;


@end
