//
//  GJSSwipeBackTool.h
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJSSwipeBackTool : NSObject

@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;

/** 添加右滑手势 */
- (void)creatSwipeGestureRecognizer:(UIView *)view taget:(id)taget action:(SEL)action;


@end
