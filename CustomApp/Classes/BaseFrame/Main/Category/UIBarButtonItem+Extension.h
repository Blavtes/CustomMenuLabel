//
//  UIBarButtonItem+Extension.h
//
//  Created by 李涛 on 15/4/26.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  返回一个barBtn
 *
 *  @param imageName          normal图片
 *  @param highlightImageName 高亮图片
 *  @param taget              taget
 *  @param action             SEL
 *
 *  @return
 */
+ (instancetype)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName taget:(id)taget action:(SEL)action;

/**
 *  返回一个barBtn
 */
+ (instancetype)itemWithTitleStr:(NSString *)title target:(id)target action:(SEL)action;

/**
 *  返回一个barBtn
 *
 *  @param title  标题
 *  @param fontSize   标题字体大小
 *  @param target 目标
 *  @param action 事件
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)itemWithTitleStr:(NSString *)title titleFont:(CGFloat)fontSize target:(id)target action:(SEL)action;
@end
