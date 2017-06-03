//
//  GJSSwipeBackTool.m
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GJSSwipeBackTool.h"

@implementation GJSSwipeBackTool

/** 添加右滑手势 */
- (void)creatSwipeGestureRecognizer:(UIView *)view taget:(id)taget action:(SEL)action
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:taget action:action];
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [view addGestureRecognizer:swipe];
    _swipe = swipe;
}

@end
