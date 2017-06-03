//
//  CustomTextField.m
//
//  Created by litao on 15/7/30.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "CustomTextField.h"

static CGFloat const CommonLeftRange = 10.0f;

@interface CustomTextField () <UITextFieldDelegate>
{
    NSString *textStr;//手机号规则 text 加空格
}
@end

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withLeftIconView:nil withRightIconView:nil];
    
    if (self) {
        //
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withLeftIconView:(UIView *)leftIconView
{
    self = [self initWithFrame:frame withLeftIconView:leftIconView withRightIconView:nil];
    if (self) {
        //  custom setting
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withRightIconView:(UIView *)rightIconView
{
    self = [self initWithFrame:frame withLeftIconView:nil withRightIconView:rightIconView];
    if (self) {
        //  custom setting
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withLeftIconView:(UIView *)leftIconView withRightIconView:(UIView *)rightIconView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = kCommonBtnRad;
        self.layer.masksToBounds = YES;
        self.backgroundColor = COMMON_WHITE_COLOR;
        self.delegate = self;
        _isLimitLength = NO;
        _curTextFieldType = CustomTextFieldTypeDefault;
        _curTextFieldVerifyType = CustomTextFieldVerifyTypeDefault;
        
        if (leftIconView) {
            self.leftView = leftIconView;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        
        if (rightIconView) {
            self.rightView = rightIconView;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
        
        //  一键清除
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return self;
}


/**
 *  重写textRectForBounds
 */
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super textRectForBounds:bounds];
    textRect.origin.x += CommonLeftRange;
    return textRect;
}

/**
 *  重写editingRectForBounds
 */
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect editRect = [super editingRectForBounds:bounds];
    editRect.origin.x += CommonLeftRange;
    return editRect;
}

#pragma mark - 懒加载
- (void)setCurTextFieldType:(CustomTextFieldType)curTextFieldType
{
    _curTextFieldType = curTextFieldType ? curTextFieldType : CustomTextFieldTypeDefault;
    
    if (_curTextFieldType != CustomTextFieldTypeDefault && _isLimitLength) {
        [self addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (void)setIsLimitLength:(BOOL)isLimitLength
{
    _isLimitLength = isLimitLength ? isLimitLength : NO;
}

#pragma mark - 监听
- (void)textChanged:(id)sender
{
    if (_curTextFieldVerifyType == CustomTextFieldVerifyTypePhone) {
        
        [self formatToPhone:sender];
    } else if (_curTextFieldVerifyType == CustomTextFieldVerifyTypeIdentityCard) {
        
        [self formatToIdentityCard:sender];
    } else if (_curTextFieldVerifyType == CustomTextFieldVerifyTypeBankCard) {
        
        [self formatToBankCard:sender];
    } else {
        if (self.text.length > _curTextFieldType) {
            self.text = [self.text substringWithRange:NSMakeRange(0, _curTextFieldType)];
            self.textFieldContent = self.text;
            //  提示信息
            switch (_curTextFieldType) {
                case CustomTextFieldTypeDefault:
                {
                    //
                }
                    break;
                    
                case CustomTextFieldTypePhoneCode:
                {
                    Show_iToast(FMT_STR(@"验证码不能超过%lu位!", (unsigned long)CustomTextFieldTypePhoneCode));
                }
                    break;
                    
                case CustomTextFieldTypeNewPayPwd:
                {
                    Show_iToast(FMT_STR(@"密码不能超过%lu位!", (unsigned long)CustomTextFieldTypeNewPayPwd - 1));
                }
                    break;
                    
                case CustomTextFieldTypePhoneNo:
                {
                    Show_iToast(FMT_STR(@"手机号码不能超过%lu位!", (unsigned long)CustomTextFieldTypePhoneNo));
                }
                    break;
                    
                case CustomTextFieldTypePassword:
                {
                    Show_iToast(FMT_STR(@"密码不能超过%lu位!", (unsigned long)CustomTextFieldTypePassword));
                }
                    break;
                    
                case CustomTextFieldTypeInviteCode:
                {
                    Show_iToast(FMT_STR(@"邀请码不能超过%lu位!", (unsigned long)CustomTextFieldTypeInviteCode));
                    break;
                }
            }
            
        }
    }
}
    //身份证 6 4 4 4
- (void)formatToIdentityCard:(UITextField *)textField
{
    if (textField.text.length > 21) {
        textField.text = [textField.text substringToIndex:21];
        Show_iToast(FMT_STR(@"身份证长度不能超过18位!"));
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];

    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    if (currentStr.length == 18 && [[currentStr substringFromIndex:17] isEqualToString:@"x"]) {
        currentStr = [currentStr stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
    }
        //正在执行删除操作时为0，否则为1
    _textFieldContent = currentStr;
    
    textField.text = [self checkIdentityCardRuleString:currentStr];
    
        // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = [self changeIdentityCardStringPosition:currentStr preStr:preStr position:targetCursorPosition];
    
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    textStr = textField.text;
}
    //添加空格
- (NSMutableString *)checkIdentityCardRuleString:(NSString *)currentStr
{
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 6 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 10 && currentStr.length > 5) {
        spaceCount = 1;
    }else if (currentStr.length < 14 && currentStr.length > 9) {
        spaceCount = 2;
    } else if (currentStr.length < 19 && currentStr.length > 13) {
        spaceCount = 3;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 6)], @" "];
        } else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(6, 4)], @" "];
        } else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(10, 4)], @" "];
        } else if (i == 3) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(14, 4)], @" "];
        }
    }
        //DLog(@"tempStr 1 %@ count %d",tempStr,spaceCount);
    if (currentStr.length == 18) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(14, 4)], @" "];
            //DLog(@"tempStr 18 %@",tempStr);
    }
    if (currentStr.length < 7) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 6, currentStr.length % 6)]];
            //DLog(@"tempStr <7 %@",tempStr);
    } else if (currentStr.length > 6 && currentStr.length < 15) {
        
        NSString *str = [currentStr substringFromIndex:6];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            //DLog(@"tempStr <16 %@ str %@",tempStr,str);
    }else if(currentStr.length > 14 && currentStr.length < 21) {
        NSString *str = [currentStr substringFromIndex:14];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 18) {
            [tempStr deleteCharactersInRange:NSMakeRange(21, 1)];
        }
            //DLog(@"tempStr <21 %@",tempStr);
    }
    return tempStr;
}
    //改变输入位置
- (NSUInteger)changeIdentityCardStringPosition:(NSString *)currentStr
                                    preStr:(NSString *)preStr
                                  position:(NSUInteger )targetCursorPosition
{
    int editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    } else {
        editFlag = 1;
        
    }
    NSUInteger curTargetCursorPosition = targetCursorPosition;

    if (editFlag == 0) {
            //删除
        if (targetCursorPosition == 7 || targetCursorPosition == 12 || targetCursorPosition == 17) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
            //添加
        if (currentStr.length == 7 || currentStr.length == 11 || currentStr.length == 15) {
            if (targetCursorPosition != 8 && targetCursorPosition != 13 && targetCursorPosition != 18) {
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
    }
    return curTargetCursorPosition;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    DLog(@"textFieldDidBeginEditing");
}
    //银行卡 4 4 4
- (void)formatToBankCard:(UITextField *)textField
{
    if (textField.text.length > 23) {
        textField.text = [textField.text substringToIndex:23];
        Show_iToast(FMT_STR(@"银行卡号长度不能超过19位!"));
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //DLog(@"currentStr %@ len %d tag %d %@",currentStr,currentStr.length,targetCursorPosition,preStr);
        //正在执行删除操作时为0，否则为1
    _textFieldContent = currentStr;
   
    textField.text = [self checkBankCardRuleString:currentStr];
    
        // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = [self changeBankCardStringPosition:currentStr preStr:preStr position:targetCursorPosition];
    
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    textStr = textField.text;
}
    //改变输入位置
- (NSUInteger)changeBankCardStringPosition:(NSString *)currentStr
                                 preStr:(NSString *)preStr
                               position:(NSUInteger )targetCursorPosition
{
    int editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    } else {
        editFlag = 1;
        
    }
    
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
            //删除
        if (targetCursorPosition == 5 || targetCursorPosition == 10 || targetCursorPosition == 15 || targetCursorPosition == 20) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
            //添加
        if (currentStr.length == 5 || currentStr.length == 9 || currentStr.length == 13 || currentStr.length == 17) {
            if (targetCursorPosition != 21 && targetCursorPosition != 16 && targetCursorPosition != 11 && targetCursorPosition != 6) {
                curTargetCursorPosition = targetCursorPosition + 1;

            }
        }
    }
    return curTargetCursorPosition;
}

    //添加空格
- (NSMutableString *)checkBankCardRuleString:(NSString *)currentStr
{
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 4 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 8 && currentStr.length > 3) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 7) {
        spaceCount = 2;
    } else if (currentStr.length < 16 && currentStr.length > 11) {
        spaceCount = 3;
    } else if (currentStr.length < 20 && currentStr.length > 15) {
        spaceCount = 4;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 4)], @" "];
        } else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(4, 4)], @" "];
        } else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(8, 4)], @" "];
        } else if (i == 3) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(12, 4)], @" "];
        } else if (i == 4) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(16, currentStr.length - 16)], @" "];
        }
            //DLog(@"temp %@",tempStr);
    }
    
    if (currentStr.length < 5) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 4, currentStr.length % 4)]];
            //DLog(@"tempStr <7 %@",tempStr);
    } else if (currentStr.length > 4 && currentStr.length < 9) {
        
        NSString *str = [currentStr substringFromIndex:4];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            //DLog(@"tempStr <8 %@ str %@",tempStr,str);
    } else if (currentStr.length > 8 && currentStr.length < 13) {
        NSString *str = [currentStr substringFromIndex:8];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            //DLog(@"tempStr <12 %@ str %@",tempStr,str);
    } else if (currentStr.length > 12 && currentStr.length < 17) {
        
        NSString *str = [currentStr substringFromIndex:12];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            //DLog(@"tempStr <17 %@ str %@",tempStr,str);
    }else if(currentStr.length > 16 && currentStr.length < 20) {
        NSString *str = [currentStr substringFromIndex:16];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            //        if (currentStr.length == 19) {
            //            [tempStr deleteCharactersInRange:NSMakeRange(23, 1)];
            //        }
            //DLog(@"tempStr <21 %@",tempStr);
    }
    return tempStr;
}
    //手机号344
- (void)formatToPhone:(UITextField *)textField
{
        //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
        Show_iToast(FMT_STR(@"手机号长度不能超过11位!"));
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //DLog(@"currentStr %@",currentStr);
        //正在执行删除操作时为0，否则为1
    _textFieldContent = currentStr;

    NSUInteger curTargetCursorPosition = [self changePhoneStringPosition:currentStr preStr:preStr position:targetCursorPosition];

    
    textField.text = [self checkPhoneRuleString:currentStr];
   
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    textStr = textField.text;
}

- (NSUInteger)changePhoneStringPosition:(NSString *)currentStr
                           preStr:(NSString *)preStr
                         position:(NSUInteger )targetCursorPosition
{
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
        // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
            //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
            //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            if (targetCursorPosition != 5 && targetCursorPosition != 10) {
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
    }
    return curTargetCursorPosition;
}

- (NSMutableString *)checkPhoneRuleString:(NSString *)currentStr
{
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length < 13) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }

    return tempStr;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textStr = self.text;
    
    //DLog(@"textFiled1 %@ \textFiled2 %@\n textFiled3 %@",textField.text,textStr,_textFieldContent);

    return YES;
}

@end
