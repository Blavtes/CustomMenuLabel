//
//  UIButton+Extention.h
//  HX_GJS
//
//  Created by litao on 15/8/27.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickCallback)(UIButton* button);

@interface UIButton (Extention)
/**
 *  返回一个btn
 *
 *  @return
 */
+ (instancetype)btnWithTitle:(NSString *)title rect:(CGRect)rect taget:(id)taget action:(SEL)action;

/**
 *  返回一个btn - 图片
 *
 *  @return
 */
+ (instancetype)btnWithImageName:(NSString *)iconName position:(CGPoint)position taget:(id)taget action:(SEL)action;

#pragma mark - 带icon标题按钮
+ (instancetype)btnWithTitleAndIcon:(NSString *)title
                       withIconName:(NSString *)iconName
                          withFrame:(CGRect)frame
                              taget:(id)taget
                             action:(SEL)action;

/**
 *  设置纯色的背景图
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


/**
 *  增加UIButton的点击事件
 */
- (void)GJSHandleClickEvent:(UIControlEvents)aEvent
                  callBack:(ButtonClickCallback)callBack;
@end
