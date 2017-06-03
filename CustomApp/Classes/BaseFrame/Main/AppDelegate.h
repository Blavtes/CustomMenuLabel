//
//  AppDelegate.h
//  HX_GJS
//
//  Created by ZXH on 15/3/14.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//  根tabbar视图
@property (nonatomic, strong) CustomTabBarViewController *customTabBarVc;
@end

