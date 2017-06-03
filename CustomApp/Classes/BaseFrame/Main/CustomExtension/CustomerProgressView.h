//
//  CustomerProgressView.h
//  HX_GJS
//
//  Created by litao on 15/8/12.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义进度圈
 */
@interface CustomerProgressView : UIView
//  代理
@property (weak, nonatomic) id delegate;
//  layer
@property (nonatomic, readonly) CAShapeLayer *trackLayer;
@property (nonatomic, readonly) CAShapeLayer *progressLayer;
//  圆弧直径
@property (nonatomic, assign) CGFloat circleWidth;
//  线宽
@property (nonatomic, assign) CGFloat lineWidth;
//  开始角度
@property (nonatomic, assign) CGFloat startAngle;
//  结束角度
@property (nonatomic, assign) CGFloat endAngle;
//  弧线颜色
@property (nonatomic, strong) UIColor *lineColor;
//  画线时间
@property (nonatomic, assign) CGFloat duration;
//  当前进度
@property (nonatomic, assign) CGFloat curPercent;

/**
 *  动态表示进度
 */
- (void)setAnimatedPercent:(CGFloat)percent animated:(BOOL)animated;
@end
