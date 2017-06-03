//
//  SafeKeyBoardField.m
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/31.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import "SafeKeyBoardField.h"
#import "MCKeyboardAccessoryView.h"        // 头部工具栏
#import "MCNumberKeyboardView.h"           // 数字键盘
#import "MCCharacterKeyboardView.h"        // 字母键盘
#import "MCSpecialCharacterKeyboardView.h" // 特殊符号键盘
#import "MCImageButton.h"                  // 放大图片



@interface SafeKeyBoardField () <MCNumberKeyboardDelegate, MCCharacterKeyboardDelegate, MCKeyboardAccessoryViewDelegate, MCSpecialCharacterKeyboardDelegate>

@property (nonatomic, strong) MCNumberKeyboardView      *numberKeyBoard;// 数字键盘
@property (nonatomic, strong) MCCharacterKeyboardView   *characterKeyboard;// 字母键盘
@property (nonatomic, strong) MCSpecialCharacterKeyboardView    *specialCharacterKeyboard;// 特殊符号键盘
@property (nonatomic, strong) MCKeyboardAccessoryView   *topAccessorKeyBoard;// 头部工具栏
@property (nonatomic, strong) UIView                    *gestureView;

@end

@implementation SafeKeyBoardField


- (void)dealloc
{
    [_numberKeyBoard removeFromSuperview];
    _numberKeyBoard = nil;
    [_gestureView removeFromSuperview];
    _gestureView = nil;
    [_characterKeyboard removeFromSuperview];
    _characterKeyboard = nil;
    [_specialCharacterKeyboard removeFromSuperview];
    _specialCharacterKeyboard = nil;
    [_topAccessorKeyBoard removeFromSuperview];
    _topAccessorKeyBoard = nil;
}

#pragma mark - 键盘处理事件
/*
 *  键盘切换
 */
- (void)changeKeyBoard:(SafeKeyBoardType)keyBoardType
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (keyBoardType == SafeKeyBoardTypeNumber) {
            self.inputView = self.numberKeyBoard;
            
        }else if (keyBoardType == SafeKeyBoardTypeCharacter) {
            self.inputView = self.characterKeyboard;
            
        }else if (keyBoardType == SafeKeyBoardTypeSpecialCharacter) {
            
            self.inputView = self.specialCharacterKeyboard;
        }
//        [self resignFirstResponder];
//        [self becomeFirstResponder];
        [self reloadInputViews];
    }];
    
    
}

/*
 *  键盘禁止
 */

- (void)forbidKeyBoardType:(SafeKeyBoardType)keyBoardType
{
    if (keyBoardType == SafeKeyBoardTypeNumber) {
        
        _forbidNumber = YES;
        
        
    }else if (keyBoardType == SafeKeyBoardTypeCharacter) {
        
        _forbidABC = YES;
        
    }else if (keyBoardType == SafeKeyBoardTypeSpecialCharacter) {
        
        _forbidSpecialCharacter = YES;
    }
}

/*
 *  删除事件
 */
- (void)deleteAction
{
    NSUInteger length = self.text.length;
    if (length == 0 ) {
        return;
    }
    NSRange range = NSMakeRange(0, length - 1);
    self.text = [self.text substringWithRange:range];
    if (_returnBlock) {
        _returnBlock(self, nil);
    }
}


/*
 *  输入事件 可以是空格 @" "
 */
- (void)inputString:(NSString *)string
{
    self.text = [self.text stringByAppendingString:string];
    if (_returnBlock) {
        _returnBlock(self, string);
    }
}

/*
 *  监听block，当输入变化时
 */
- (void)shouldChangeCharacters:(keyBoardReturnStringBlock)returnBlock
{
    _returnBlock = returnBlock;
}

#pragma mark - 禁止进入粘贴板
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (isPad) {
        return YES;
    }
    if (self.forbidClipboard) {
        [self resignFirstResponder];
    }
    return !self.forbidClipboard;
}

#pragma mark -- --------------- Delegate ----------------

#pragma mark -  MCNumberKeyboardDelegate

/** 点击了数字键盘数字按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickButton:(UIButton *)button
{
    [self inputString:button.currentTitle];
}

/** 点击了数字键盘删除按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickDeleteBtn:(UIButton *)deleteBtn
{
    [self deleteAction];
}

/** 点击了切换成字母键盘按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickToCharacterBtn:(UIButton *)toCharacerBtn
{
    if(!_forbidABC) {
        [self changeKeyBoard:SafeKeyBoardTypeCharacter];
    }
}



#pragma mark - MCCharacterKeyboardDelegate

/** 点击了字母键盘的字母按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickCharacterButton:(UIButton *)characterBtn
{
    [self inputString:characterBtn.currentTitle];
}
/** 长按了字母键盘的字母按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didLongPressCharacterButton:(MCImageButton *)characterBtn withGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _gestureView = gesture.view;
    }

    // 只有长按字母键并且手势状态开始时，才进行密码拼接
    if(gesture.state == UIGestureRecognizerStateBegan && characterBtn) {
        
        [characterBtn showImageViewWithLabelName:characterBtn.currentTitle];
        [self inputString:characterBtn.currentTitle];
        
    }else {

        [characterBtn hideImageViewWithLabelName:characterBtn.currentTitle];
    }
}
/** 点击了字母键盘的删除按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickCharacterDeleteBtn:(UIButton *)characterDeleteBtn
{
     [self deleteAction];
}

/** 点击了字母键盘的空格按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickSpaceButton:(UIButton *)spaceBtn
{
    if (!self.forbidSpace) {
        [self inputString:@" "];
    }
    
}
/** 点击了字母键盘切换成特殊字符按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickSpecialCharacterBtn:(UIButton *)toSpecialCharacerBtn
{
    if(!_forbidSpecialCharacter) {
        [self changeKeyBoard:SafeKeyBoardTypeSpecialCharacter];
    }
}

/** 点击了字母键盘的切换成数字按钮 */
- (void)keyboard:(MCCharacterKeyboardView *)keyboard didClickNumberBtn:(UIButton *)toNumberBtn
{
    if (!_forbidNumber) {
        [self changeKeyBoard:SafeKeyBoardTypeNumber];
    }
  
}



#pragma mark - MCKeyboardAccessoryViewDelegate

/** 点击了完成按钮 */
- (void)accessaryBtn:(MCKeyboardAccessoryView *)keyboard didClickFinishButton:(UIButton *)finishButton
{
    [self resignFirstResponder];
}



#pragma mark - MCSpecialCharacterKeyboardDelegate

/** 点击了特殊字符键盘的字符按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickSpecialCharacterButton:(UIButton *)specialCharacterBtn
{
    [self inputString:specialCharacterBtn.currentTitle];
}
/** 长按了字母键盘的字母按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didLongPressSpecialCharacterButton:(MCImageButton *)longPressBtn withGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _gestureView = gesture.view;
    }
    //    NSLog(@"UIGestureRecognizer %ld %@",(long)gesture.state,gesture.view);
    // 只有长按字母键并且手势状态开始时，才进行密码拼接
    if(gesture.state == 1 && longPressBtn) {
        
        [longPressBtn showImageViewWithLabelName:longPressBtn.currentTitle];
        
    }else {
        if (gesture.state == UIGestureRecognizerStateEnded && _gestureView == gesture.view) {
            
            [self inputString:longPressBtn.currentTitle];
        }
        [longPressBtn hideImageViewWithLabelName:longPressBtn.currentTitle];
    }
}


/** 点击了特殊字符键盘的删除按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickDeleteButton:(UIButton *)deleteBtn
{
     [self deleteAction];
}


/** 点击了特殊字符键盘的切换成数字按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickToNumberButton:(UIButton *)toNumberBtn
{
    if (!_forbidNumber) {
        [self changeKeyBoard:SafeKeyBoardTypeNumber];
    }
    
}


/** 点击了特殊字符键盘的切换成字母按钮 */
- (void)keyboard:(MCSpecialCharacterKeyboardView *)keyboard didClickToCharacterButton:(UIButton *)toCharacterBtn
{
    if (!_forbidSpecialCharacter) {
        [self changeKeyBoard:SafeKeyBoardTypeCharacter];
    }
    
}

#pragma mark - ---------------  Getter && Setter ------------

/*
 *  键盘类型    若不设置，将初始化系统键盘
 */
- (void)setSafeKeyBoardType:(SafeKeyBoardType)safeKeyBoardType
{
    _safeKeyBoardType = safeKeyBoardType;
    if (safeKeyBoardType == SafeKeyBoardTypeNumber) {
        self.inputView = self.numberKeyBoard;
        
    }else if (safeKeyBoardType == SafeKeyBoardTypeCharacter) {
        self.inputView = self.characterKeyboard;
        
    }else if (safeKeyBoardType == SafeKeyBoardTypeSpecialCharacter) {
        
        self.inputView = self.specialCharacterKeyboard;
    }
    self.inputAccessoryView = self.topAccessorKeyBoard;
}

// 数字键盘
- (MCNumberKeyboardView *)numberKeyBoard
{
    if (!_numberKeyBoard) {
        _numberKeyBoard = [[MCNumberKeyboardView alloc] initWithNumberKeyboard];
        _numberKeyBoard.numberDelegate = self;
    }
    return _numberKeyBoard;
}

//  字母键盘
- (MCCharacterKeyboardView *)characterKeyboard
{
    if (!_characterKeyboard) {
        
        _characterKeyboard = [MCCharacterKeyboardView initCharacterKeyBoard];
        _characterKeyboard.characterDelegate = self;
    }
    return _characterKeyboard;
}

// 特殊字符键盘初始化
- (MCSpecialCharacterKeyboardView *)specialCharacterKeyboard
{
    if (!_specialCharacterKeyboard) {
        _specialCharacterKeyboard = [MCSpecialCharacterKeyboardView initSpecialCharacterKeyBoard];
        _specialCharacterKeyboard.specialCharacterDelegate = self;

    }
    return _specialCharacterKeyboard;
}

//  头部工具栏
- (MCKeyboardAccessoryView *)topAccessorKeyBoard
{
    if (!_topAccessorKeyBoard) {
        _topAccessorKeyBoard = [MCKeyboardAccessoryView initKeyBoardAccessory];
        _topAccessorKeyBoard.accessaryBtnDelegate = self;
    }
    return _topAccessorKeyBoard;
}
@end
