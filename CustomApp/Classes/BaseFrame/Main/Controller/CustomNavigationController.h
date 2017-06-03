//
//  CustomNavigationController.h
//
//  Created by 李涛 on 15/4/26.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UINavigationController

//重置animation fromgesture
- (void)setCurAnimating:(BOOL)animation;
- (void)setFromGesture:(BOOL)fromGesture;

@end
