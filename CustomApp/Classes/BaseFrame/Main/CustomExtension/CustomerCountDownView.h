//
//  CustomerCountDownView.h
//  GjFax
//
//  Created by gjfax on 16/10/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CustomerCountDownViewTimerOverBlock)(void);
typedef void(^CustomerCountDownViewFirstTimerOverBlock)(void);
typedef void(^CustomerCountDownViewSecondTimerOverBlock)(void);
@interface CustomerCountDownView : UIView
// 定时器
@property(nonatomic,strong)NSTimer *timer;
// 倒计时最低限制时间标志
@property (nonatomic, assign) BOOL timeFinished;
// 圆圈固定位置颜色
@property (nonatomic, strong) UIColor *fixedStateColor;
// 圆圈动态转动颜色
@property (nonatomic, strong) UIColor *dynamicStateColor;
// 到达终止时间block
@property (nonatomic, copy) CustomerCountDownViewTimerOverBlock     timerOverBlock;
// 到达第一阶段时间block
@property (nonatomic, copy) CustomerCountDownViewFirstTimerOverBlock     firstTimerOverBlock;
// 到达第二阶段时间block
@property (nonatomic, copy) CustomerCountDownViewSecondTimerOverBlock     secondTimerOverBlock;

// 初始化倒计时页面动画(不分段，相同速度)
-(void)viewOfCountDownWithCirclePoint:(CGPoint)point andCirleRadius:(CGFloat)radius andTimeSize:(CGSize)timeSize andTimeFont:(UIFont *)timeFont andTimeColor:(UIColor *)timeColor andTime:(CGFloat )time andTimeInterval:(CGFloat)timeInterval;


// 初始化倒计时页面动画(分段，不同速度)
- (void)circleWithPoint:(CGPoint)point radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle time:(CFTimeInterval)time timerJudge:(BOOL)isFirst restTime:(CGFloat)restTime ;


- (void)setTimerOverBlock:(CustomerCountDownViewTimerOverBlock)timerOverBlock;
- (void)setFirstTimerOverBlock:(CustomerCountDownViewFirstTimerOverBlock)firstTimerOverBlock;
- (void)setSecondTimerOverBlock:(CustomerCountDownViewSecondTimerOverBlock)secondTimerOverBlock;
@end
