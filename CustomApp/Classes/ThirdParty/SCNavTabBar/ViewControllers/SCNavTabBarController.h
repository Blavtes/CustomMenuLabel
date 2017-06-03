//
//  SCNavTabBarController.h
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import <UIKit/UIKit.h>

//safi 新增回调当前选择的index
typedef void (^didSelectedWithIndexBlock)(NSInteger selectedInt);

@class SCNavTabBar;

@interface SCNavTabBarController : CustomBaseViewController

@property (nonatomic, assign)   BOOL        showArrowButton;            // Default value: YES
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO
@property (nonatomic, assign)   BOOL        equalWidthBtns;             // Default value: NO

@property (nonatomic, assign)   BOOL        isCustomFrame;

@property (nonatomic, strong)   NSArray     *subViewControllers;        // An array of children view controllers

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;

@property (nonatomic, strong)   UIView      *headerV;//积分详情界面上面显示的视图
@property (nonatomic, strong)   UIScrollView *mainView; //可以滚动的scrollView
//safi 新增回调当前选择的index，目前用于 send UMEvent
@property (nonatomic, copy)     didSelectedWithIndexBlock       didSelectedWithIndexBlock;

//  初始化所在标签
@property (nonatomic, assign) int defaultIndex;

//safi 补全
- (void)setDidSelectedWithIndexBlock:(didSelectedWithIndexBlock)didSelectedWithIndexBlock;

/**
 *  Initialize Methods
 *
 *  @param show - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithShowArrowButton:(BOOL)show;

/**
 *  Initialize SCNavTabBarViewController Instance And Show Children View Controllers
 *
 *  @param subViewControllers - set an array of children view controllers
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subViewControllers;

/**
 *  Initialize SCNavTabBarViewController Instance And Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */
- (id)initWithParentViewController:(UIViewController *)viewController;

/**
 *  Initialize SCNavTabBarViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *  @param show           - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */
- (void)addParentController:(UIViewController *)viewController;

- (void)checkoutSelectedItemWithIndex:(int)index;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
