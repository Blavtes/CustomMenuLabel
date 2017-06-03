//
//  HUDTool.h
//  GjFax
//
//  Created by litao on 15/9/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  HUD工具类 负责整个项目的hud显示 与第三方弱依赖(暂时简单基于MBProgressHUD)
 */

//  显示hud的block
typedef void (^ShowHUDWithBlock)();

@interface HUDTool : NSObject
#pragma mark - hud显示在keyWindow上
/**
 *  显示mbprogresshud on keyWindow
 */
+ (id)showHUDOnKeyWindow:(NSString *)info whileExecutingBlock:(ShowHUDWithBlock)showHUDWithBlock;

/**
 *  keyWindow显示hud - 非block
 *  注意 界面中同时使用两个以上HUD时，调用请保持一致性，都使用window 或者view 方式
 *  该window 加在屏幕最上面一个window上
 *  有输入框和HUD 一起出现的情况，必须使用window 形式显示
 *  @return
 */
+ (id)showHUDOnKeyWindow;
+ (id)showHUDOnKeyWindow:(NSString *)info;

#pragma mark - hud显示在view上
/**
 *  显示mbprogresshud
 *  实际上 加载到 window 上
 *  使用 它 可以点击 导航栏 和 tabbar
 *  该view 加载在屏幕app window上
 *  @param view
 *
 */
+ (id)showHUDOnView;

/**
 *  显示mbprogresshud
 *
 *  @param view
 *
 */
+ (id)showHUDOnViewWithInfo:(NSString *)info;

/**
 *  显示mbprogresshud
 *
 *  @param view
 *
 */
+ (id)showHUDOnViewWithInfo:(NSString *)info
             animated:(BOOL)animated;

/**
 *  显示mbprogresshud - 自定义图片
 *
 *  @param view
 *
 */
//+ (id)showHUDWithDefaultCutomView:(UIView *)view;

/**
 *  显示mbprogresshud - 自定义图片
 *
 *  @param view
 *
// */
//+ (id)showHUDWithCutomView:(UIView *)view
//                    imgStr:(NSString *)imgStr
//                      info:(NSString *)info
//                  animated:(BOOL)animated;

/**
 *  隐藏mbprogresshud
 *
 *  @param view
 *
 */
+ (BOOL)hideHUDOnView;

/**
 *  隐藏mbprogresshud
 *
 *  @param view
 *
 */
+ (void)hideHUDOnViewWithAfterDelay:(NSTimeInterval)delay;

/**
 *  隐藏keyWindow上得hud
 *
 *  @return 隐藏的个数
 */
+ (NSUInteger)hideHUDOnKeyWindow;

+ (void)resetHUD;

@end
