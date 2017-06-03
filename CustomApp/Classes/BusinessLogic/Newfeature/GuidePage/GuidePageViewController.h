//
//  GuidePageViewController.h
//  HX_GJS
//
//  Created by litao on 16/3/12.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController

#pragma mark - 单例
+ (instancetype)sharedInstance;

+ (void)show;

+ (void)hide;

- (void)fetchGuideData;

@end
