//
//  CustomNavigationBarButtonItem.h
//  GjFax
//
//  Created by yangyong on 2016/12/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationBarButtonItem : NSObject
/*
 * 自定义导航栏右边按钮 标题 按钮动作 字体默认14 点击高亮
 */
+ (void)customRightItemTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)customRightItemTitle:(NSString *)title target:(id)target fontSize:(int)fontSize highlight:(BOOL)highlighted action:(SEL)action;

/*
 * 自定义导航栏左边按钮 标题 按钮动作 字体默认14 点击高亮
 */
+ (void)customLeftItemTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)customLeftItemTitle:(NSString *)title target:(id)target fontSize:(int)fontSize highlight:(BOOL)highlighted action:(SEL)action;

/*
 * 自定义清除导航栏左边按钮
 */
+ (void)customClearLeftItem;

- (void)customClearLeftItem;

@end
