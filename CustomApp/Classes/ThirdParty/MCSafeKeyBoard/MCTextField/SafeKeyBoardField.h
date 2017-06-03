//
//  SafeKeyBoardField.h
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/31.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SafeKeyBoardField;

typedef void(^keyBoardReturnStringBlock)(SafeKeyBoardField *textField, NSString *string);

/*
 *  键盘类型
 */
typedef NS_ENUM(NSInteger, SafeKeyBoardType) {
    SafeKeyBoardTypeNumber           =  10001,  //数字键盘
    SafeKeyBoardTypeCharacter        =  10002,  //字母键盘
    SafeKeyBoardTypeSpecialCharacter =  10003,  //特殊字符键盘
};

@interface SafeKeyBoardField : UITextField


/*
 *  键盘类型
 */
@property (nonatomic, assign) SafeKeyBoardType  safeKeyBoardType;
/*
 *  禁止空格  默认 NO，即可使用空格
 */
@property (nonatomic, assign) BOOL              forbidSpace;
/*
 *  禁止剪贴板  默认 NO，即可使用剪贴板
 */
@property (nonatomic, assign) BOOL              forbidClipboard;
/*
 *  禁止数字键盘  默认 NO，即可使用数字键盘
 */
@property (nonatomic, assign) BOOL              forbidNumber;
/*
 *  禁止字母键盘  默认 NO，即可使用字母键盘
 */
@property (nonatomic, assign) BOOL              forbidABC;
/*
 *  禁止特殊字符键盘  默认 NO，即可使用特殊字符键盘
 */
@property (nonatomic, assign) BOOL              forbidSpecialCharacter;

@property (nonatomic, copy)   keyBoardReturnStringBlock         returnBlock;

/*
 *  键盘类型    若不设置，将初始化系统键盘
 */
- (void)setSafeKeyBoardType:(SafeKeyBoardType)safeKeyBoardType;

/*
 *  监听block，当输入变化时
 */
- (void)shouldChangeCharacters:(keyBoardReturnStringBlock)returnBlock;
@end
