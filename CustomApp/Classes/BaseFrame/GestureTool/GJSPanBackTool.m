//
//  GJSPanBackTool.m
//  GjFax
//
//  Created by gjfax on 2017/2/28.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "GJSPanBackTool.h"

@implementation GJSPanBackTool

/** 添加向右拖动返回手势 */

- (void)creatPanGestureRecognizer:(UIViewController *)selfVC taget:(id)taget action:(SEL)action {
    
    id target = selfVC.navigationController.interactivePopGestureRecognizer.delegate;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:action];
    
    pan.delegate = (id)selfVC;
    
    selfVC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [selfVC.view addGestureRecognizer:pan];
    
    _pan = pan;
    
}

@end
