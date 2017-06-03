//
//  GJSNumKeyBoardField.h
//  HX_GJS
//
//  Created by gjfax on 16/2/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityNumberKeyBoardView.h"


/*
 *  回调字符串长度
 */
typedef void(^returnTextNumberBlock)(NSInteger textNum);

@interface GJSNumKeyBoardField : UIView

/*
 *  keyBoard Text
 */
@property (nonatomic, strong) NSString              *text;

@property (nonatomic, copy)   returnTextNumberBlock     block;

/*
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame curView:(UIView *)curView;

/*
 *  实时监听输入数量回调
 */
- (void)returnTextNumberBlcok:(returnTextNumberBlock)block;

/*
 *  重置
 */
- (void)resetKeyBoardText;

/*
 *  键盘下移
 */
- (void)keyBoardResignFirstResponder;

/*
 *  键盘上移移
 */
- (void)keyBoardBecomeFirstResponder;
@end
