//
//  GJSPanBackTool.h
//  GjFax
//
//  Created by gjfax on 2017/2/28.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJSPanBackTool : NSObject

/** 向右拖动返回手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

/** 添加向右拖动手势 */
- (void)creatPanGestureRecognizer:(UIViewController *)selfVC taget:(id)taget action:(SEL)action;
@end
