//
//  ThreeDTouchTool.h
//  HX_GJS
//
//  Created by gjfax on 16/4/15.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeDTouchTool : NSObject

/*
 *  初始化列表item
 */
+ (void)initApplicationShortcutItem;

/*
 *  点击item后的跳转事件
 */
+ (void)clickShorycutItemJump:(UIApplicationShortcutItem*)ShortcutItem;
@end
