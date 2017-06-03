//
//  CustomerCountDownView.m
//  GjFax
//
//  Created by gjfax on 16/10/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomerCountDownView.h"

@interface CustomerCountDownView () <CAAnimationDelegate>
@property(nonatomic,strong)UILabel *textLabel;
// 圆心
@property (nonatomic, assign) CGPoint point;
// 半径
@property (nonatomic, assign) CGFloat radius;
// 剩余时间
@property (nonatomic, assign) CGFloat restTime;
// 总时间
@property (nonatomic, assign) CGFloat totalTime;
// 最小时间间隔
@property (nonatomic, assign) CGFloat timeInterval;

@end


@implementation CustomerCountDownView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// point:        圆心位置坐标
// radius:       圆半径
// timeSize:     显示时间字体
// timeColor:    显示时间颜色
// time:         倒计时时间
// timeInterval: 最小时间间隔
-(void)viewOfCountDownWithCirclePoint:(CGPoint)point andCirleRadius:(CGFloat)radius andTimeSize:(CGSize)timeSize andTimeFont:(UIFont *)timeFont andTimeColor:(UIColor *)timeColor andTime:(CGFloat )time andTimeInterval:(CGFloat)timeInterval{

    self.textLabel = [[UILabel alloc]init];
    
    self.textLabel.center = point;
    self.textLabel.bounds = CGRectMake(0, 0, timeSize.width, timeSize.height);
    _restTime = time;
    _totalTime = time;
    _timeInterval = timeInterval;
    _point = point;
    _radius = radius;
    NSString *timeMsg = [NSString stringWithFormat:@"%i",(int)time];
    NSString *timeMsgStr = [timeMsg stringByAppendingString:@"s"];
    self.textLabel.text = timeMsgStr;
    self.textLabel.font = timeFont;
    self.textLabel.textColor = timeColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
  
    
    [self addSubview:self.textLabel];
//    self.timeFinished = NO;
    //通过NSTimer设置倒计时
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    self.timer = timer;
}

//时间的倒计时
-(void)countTime{
    
    if (_restTime <= 0) {
        
        [self.timer invalidate];
        self.timer = nil;
        if (_timerOverBlock) {
            _timerOverBlock();
        }
    }else{
        
        _restTime = _restTime - _timeInterval;
        NSString *timeMsg = [NSString stringWithFormat:@"%i",(int)_restTime];
        NSString *timeMsgStr = [timeMsg stringByAppendingString:@"s"];
        self.textLabel.text = timeMsgStr;
//        if (restTime  > 12) {
//        self.timeFinished = YES;
//        }
        [self setNeedsDisplay];
        
    }
    
    
}

// 匀速不分段情况下，需要打开下列方法（若分段情况下打开会有一个黑点出现）
//- (void)drawRect:(CGRect)rect {
//    //开启上下文(是一个范围区间)
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(0 , 2*_radius ), NO, 0.0);
//    //设置路径圆心
//    
//    CGPoint center = CGPointMake(_point.x, _point.y);
//    
//    //设置路径1
//    UIBezierPath *backPath = [UIBezierPath bezierPathWithArcCenter:center  radius:_radius - 5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    backPath.lineWidth = 4;
//    [_fixedStateColor setStroke];
//    [backPath stroke];
//    
//    //设置路径2
//    //开始角度为270°，即为上端，结束角度为开始角度 + 休息总时间 / 360° * 当前剩余时间
//    CGFloat startAngle = M_PI*2 - M_PI/2;
//    CGFloat endAngle = startAngle + (360 / _totalTime  * (_totalTime - _restTime))  * (M_PI * 2 / 360) ;
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:_radius - 5 startAngle:startAngle endAngle:endAngle clockwise:YES];
//    path.lineWidth = 4;
//    
//    
//    //非填充路径
//    [_dynamicStateColor setStroke];
//    [path stroke];
//    
//    //获取图片并显示
//    UIImage *CirImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageView *cirImgView = [[UIImageView alloc]initWithImage:CirImg];
//    cirImgView.frame = CGRectMake(_point.x - _radius  , _point.y - _radius , 2*_radius  , 2* _radius );
//    cirImgView.image = CirImg;
//    [self addSubview:cirImgView];
//    
//    
//    //关闭上下文
//    UIGraphicsEndImageContext();
//    
//}


- (void)setTimerOverBlock:(CustomerCountDownViewTimerOverBlock)timerOverBlock
{
    _timerOverBlock = timerOverBlock;
}

- (void)setFirstTimerOverBlock:(CustomerCountDownViewFirstTimerOverBlock)firstTimerOverBlock {
    _firstTimerOverBlock = firstTimerOverBlock;
}

- (void)setSecondTimerOverBlock:(CustomerCountDownViewSecondTimerOverBlock)secondTimerOverBlock {
    _secondTimerOverBlock = secondTimerOverBlock;
}

// point:           圆心
// radius:          半径
// startAngle:      开始角度
// endAngle:        终止角度
// time:            持续时间
// isFirst:         是否第一次进入倒计时
// restTime:        剩余倒计时时间

- (void)circleWithPoint:(CGPoint)point radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle time:(CFTimeInterval)time timerJudge:(BOOL)isFirst restTime:(CGFloat)restTime
{
   
    _totalTime = restTime;
    //圆圈路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;  //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor;//线条颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;   //填充颜色
    shapeLayer.lineWidth = 3.0;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 0.0;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (shapeLayer.strokeEnd == 1.0)
    {
        [animation setFromValue:@1.0];
        [animation setToValue:@0.0];
    }
    else
    {
        [animation setFromValue:@0.0];
        [animation setToValue:@1.0];
    }
    
    [animation setDuration:time];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;//当动画结束后,layer会一直保持着动画最后的状态
    animation.delegate = self;
    [shapeLayer addAnimation:animation forKey:@"Circle"];
    if (isFirst) {
        _restTime = restTime;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitTime) userInfo:nil repeats:YES];
        self.timer = timer;
    }
  
   
      
}

-(void)waitTime{
    if (_restTime <= 0) {
        
        [self.timer invalidate];
        self.timer = nil;
        if (_timerOverBlock) {
            _timerOverBlock();
        }
    } else {
        _restTime --;
        
        if ((_restTime > _totalTime - 6) && (_restTime <= _totalTime - 3) && _firstTimerOverBlock) {
            _firstTimerOverBlock();
            
        };
        
        if ((_restTime > 0) && (_restTime <= _totalTime - 6) && _secondTimerOverBlock) {
                _secondTimerOverBlock();
            
        };
        
    }
}
@end
