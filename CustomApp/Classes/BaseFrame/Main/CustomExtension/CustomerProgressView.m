//
//  CustomerProgressView.m
//  HX_GJS
//
//  Created by litao on 15/8/12.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "CustomerProgressView.h"

//  把角度转换成PI的方式
#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface CustomerProgressView ()
{
    //  属性
}
//  进度
@property (nonatomic, assign) CGFloat lastProgress;
@end

@implementation CustomerProgressView
/**
 懒加载
 */
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor ? lineColor : COMMON_BLUE_COLOR;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth ? lineWidth : 2;
}

- (void)setCircleWidth:(CGFloat)circleWidth
{
    _circleWidth = circleWidth ? circleWidth : self.bounds.size.width;
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle ? startAngle : 0;
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle ? endAngle : 360;
}

- (void)setDuration:(CGFloat)duration
{
    _duration = duration ? duration : 1.5f;
}

#pragma mark - view
/**
 *  添加子view
 *
 *  @param frame
 *
 */
- (id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        //  创建一个shape layer
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [[UIColor clearColor] CGColor];
        //  透明度
        _progressLayer.opacity = 1.0;
        //  指定线的边缘是圆的
        _progressLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_progressLayer];
    }
    
    return self;
}

/**
 *  动态表示进度
 */
- (void)setAnimatedPercent:(CGFloat)percent animated:(BOOL)animated
{
    //  初始化信息
    [self initProgressCircle];
    
    if (animated) {
        //  有动作
        _curPercent += 0.01f;
        _progressLayer.path = [self progressPath];
        if (_curPercent != _lastProgress && _curPercent < 0.675f) {
            CGFloat fromValue = _lastProgress / _curPercent;
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.delegate = self.delegate;
            pathAnimation.duration = _duration;
            pathAnimation.fromValue = @(fromValue);
            pathAnimation.toValue = @(1.0f);
            [_progressLayer addAnimation:pathAnimation forKey:@"processAnimation"];
        }
        _lastProgress = _curPercent;
    } else {
        //  无动作（其实是极短动作）
//        [CATransaction begin];
//        [CATransaction setDisableActions:animated];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//        [CATransaction setAnimationDuration:1.0f];
//        _progressLayer.strokeEnd = 1;//percent * .01f;
//        [CATransaction commit];
    }
}

/**
 获取当前路径
 */
- (CGPathRef)progressPath
{
    CGFloat offset = degreesToRadians(_startAngle);
    CGFloat endAngle = _curPercent * 2 * M_PI + offset;
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_progressLayer.frame.size.width * .5f, _progressLayer.frame.size.height * .5f) radius:(_circleWidth - _lineWidth) * .5f startAngle:offset endAngle:endAngle clockwise:YES];
    
    //  起点终点处理
    arcPath.lineCapStyle = kCGLineCapRound;
    arcPath.lineJoinStyle = kCGLineCapRound;
    
    return arcPath.CGPath;
}

/**
 *  初始化圆弧属性
 */
- (void)initProgressCircle
{
    //  指定path的渲染颜色
    _progressLayer.strokeColor = [_lineColor CGColor];
    //  线的宽度
    _progressLayer.lineWidth = _lineWidth;
    
    //  构建圆形
    UIBezierPath *layerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_progressLayer.frame.size.width * .5f, _progressLayer.frame.size.height * .5f) radius:(_circleWidth - _lineWidth) * .5f startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
    
    //  起点终点处理
    layerPath.lineCapStyle = kCGLineCapRound;
    layerPath.lineJoinStyle = kCGLineCapRound;
    //  把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的
    _progressLayer.path =[layerPath CGPath];
}
@end
