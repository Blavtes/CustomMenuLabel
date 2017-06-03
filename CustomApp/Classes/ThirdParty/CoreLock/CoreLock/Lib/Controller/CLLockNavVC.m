//
//  CLLockNavVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/28.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockNavVC.h"

@interface CLLockNavVC ()

@end

@implementation CLLockNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - 设置手势密码导航栏风格
/**
 *  在程序运行过程中 会在你程序中每个类调用一次initialize
 *  在这里设置Navigation相应主题
 */
+ (void)initialize
{
    //DLog(@"CustomNavigationController initialize class--%@", [self class]);
    //  设置UINavigationBar的主题
    [self setupNavigationBarTheme];
    
    //  设置UINavigationItem的主题
    [self setupNavigationItemTheme];
}

/**
 *  设置UINavigationBar的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    //  设置naviBar背景图片 - UIBarMetricsDefault/UIBarMetricsCompact
    if (isRetina) {
        [appearance setBackgroundImage:[UIImage imageNamed:@"navi_background_for_iphone4s"] forBarMetrics:UIBarMetricsDefault];
        appearance.barStyle = UIBarStyleBlack;
    } else {
        //  去掉导航栏的边界灰线
        [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        if (IOS7 && IOS_VERSION >= 8.0 && FourInch) {
            //  ios7以上关闭透明度
#pragma mark -- bug fix - ios8.0以后才设置
            appearance.translucent = NO;
        }
        appearance.barTintColor = COMMON_BLUE_GREEN_COLOR;
    }
    //  去掉下方shadow线
    [appearance setShadowImage:[[UIImage alloc] init]];
    
    //  设置文字属性 去掉阴影
    NSMutableDictionary *textDic = [NSMutableDictionary dictionary];
    textDic[UITextAttributeTextColor] = [UIColor whiteColor];
    //  过期 : 并不代表不能用, 仅仅是有最新的方案可以取代它
    //  UITextAttributeFont  --> NSFontAttributeName(iOS7)
    textDic[UITextAttributeFont] = CommonNavigationTitleFont;
    //  取消阴影就是将offset设置为0
    textDic[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textDic];
}

/**
 *  设置UINavigationItem的主题
 */
+ (void)setupNavigationItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:15];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[UITextAttributeTextColor] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[UITextAttributeTextColor] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
