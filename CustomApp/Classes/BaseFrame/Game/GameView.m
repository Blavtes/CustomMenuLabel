//
//  GameView.m
//  ResetApp
//
//  Created by Blavtes on 23/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import "GameView.h"
#import "PointView.h"
#import "LineInfo.h"
#import "NSTimer+Safety.h"
#import <objc/runtime.h>

static float kWidth = 25;
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_X (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define COMMON_GREY_WHITE_COLOR RGBColor(241, 241, 241)
static float kTopHeight = 28;
@implementation GameView

//  等级，星级
- (instancetype)initWithFrame:(CGRect)frame level:(int)level rank:(YYRankType)rank
{
    if (self = [super initWithFrame:frame]) {
        [self config];
        [self configPointArrLevel:level rank:rank];
        _currentLevel = level;
        _currentRankType = rank;
        [self configTime];
        [self configHomeCenter];
        [self back];
    }
    return self;
}

- (void)back
{
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(5, kTopHeight, 40, 40);
    [self addSubview:btn];
    btn.alpha = 0.1f;
    [btn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backClick:(id)sender
{
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)configTime
{
    UIImageView *timeIcon = [UIImageView new];
    timeIcon.image = [UIImage imageNamed:@"home_time"];
    timeIcon.frame = CGRectMake(45, kTopHeight, 25, 25);
    [self addSubview:timeIcon];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(67, kTopHeight - 2, 60, 30)];
    timeLable.text = @"00'00";
    timeLable.textColor = [UIColor whiteColor];
    timeLable.font = [UIFont systemFontOfSize:12];
    [self addSubview:timeLable];
    
    _timeLable = timeLable;
    _timeCount = 0;
    __weak typeof(self) weakSelf = self;
    [NSTimer SafetyTimerWithTimeInterval:1 repeats:YES target:self block:^(NSTimer *timer) {
        [weakSelf timeReflsh];
    }];
}

- (void)configHomeCenter
{
    UIButton *home = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30, kTopHeight, 20, 20)];
//    [home setImage:[UIImage imageNamed:@"home_center"] forState:UIControlStateNormal];
    [home setBackgroundImage:[UIImage imageNamed:@"more_home"] forState:UIControlStateNormal];
    [home addTarget:self action:@selector(homeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:home];
}

- (void)homeClick:(UIButton *)btn
{
    NSLog(@"homeClick");
    [self showLevelBgView];
}

- (void)showLevelBgView
{
    if (!_levelBgView) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400);
        view.layer.zPosition = 20;
        [self addSubview:view];
        view.backgroundColor = COMMON_GREY_WHITE_COLOR;
        view.userInteractionEnabled = YES;
        _levelBgView  = view;
    }
    [UIView animateWithDuration:1 animations:^{
        _levelBgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 + 400/ 2);

    }];
    [_levelBgView removeAllSubviews];
    [self configLevelView];
}



- (void)configLevelView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width - 10, _levelBgView.frame.size.height - 10)];
    scroll.contentSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width - 10, 22 * 40);
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 6; j++) {
            int x = 40 * j  + ([UIScreen mainScreen].bounds.size.width  - 40 * 6 ) / 2 ;
            int y = 40 * i + 20;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
             btn.tag = i * 6 + j + 1;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            
            if ((i == 0 && j == 0) || [self getConfigFlag:i * 6 + j + 1 rank:_currentRankType]) {
                [btn setTitle:[NSString stringWithFormat:@"%d",i * 6 + j +1] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(levelSeleck:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [UIColor blackColor];
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"lock_le"] forState:UIControlStateNormal];
            }
           
            [scroll addSubview:btn];
        }
    }
    [_levelBgView addSubview:scroll];
}

- (void)levelSeleck:(UIButton *)sender
{
    NSLog(@"levelSeleck %ld",sender.tag);
    if (self.seleckLevelBlock) {
        self.seleckLevelBlock((int)sender.tag, _currentLevel);
        [self hiddenBgView];
    }
}

- (void)hiddenBgView
{
    [UIView animateWithDuration:1 animations:^{
        _levelBgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height  + 400/ 2);
    }];
}

- (void)dealloc
{
    NSLog(@"### dealloc");
}

- (void)timeReflsh
{
    NSLog(@"NNN timeReflsh");
    _timeCount += 1;
    _timeLable.text = [self timeStr:_timeCount];
}

- (NSString *)timeStr:(int)timeout
{
    NSString *timeoutStr = [[NSString alloc] init];
    int seconds = (int)(timeout % 60);
    int hours = (int)(timeout / (60 * 60));
    int minutes = (int)(timeout / 60 - hours * 60);
     if (hours <= 99 && hours > 0) {
        timeoutStr = [NSString stringWithFormat:@"%.2d'%.2d\"", minutes, seconds];
    } else if (minutes > 0) {
        timeoutStr = [NSString stringWithFormat:@"%.2d'%.2d\"", minutes, seconds];
    } else {
        timeoutStr = [NSString stringWithFormat:@"00'%.2d\"", seconds];
    }
    return timeoutStr;
}

- (void)config
{
    _poingtArray = [NSMutableArray arrayWithCapacity:1];
    _lineArray = [NSMutableArray arrayWithCapacity:1];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, IS_IPHONE_X ? kTopHeight * 2:kTopHeight, 40, 20);
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    [self.layer addSublayer:label.layer];
    _lineTipsLabel = label;
    
}

- (CGPoint)randomPoint
{
    CGPoint point = CGPointMake(kWidth, kWidth);
    point.x = MAX(arc4random() % ((int)[UIScreen mainScreen].bounds.size.width - 20), (arc4random() % 5 + 1) * 20);
    point.y = MAX(arc4random() % ((int)[UIScreen mainScreen].bounds.size.height - 30), (arc4random() % 5 + 1) * 50);
    NSLog(@"x, y %f,%f",point.x, point.y);
    return point;
}

// 4，3
- (void)configPointArrLevel:(int)level rank:(YYRankType)rankType
{
    int rank = 2;
    switch (rankType) {
        case YYDefalutRank:
            rank = 4;
            break;
        case YYSimpleRank:
            rank = 5;
            break;
        case YYGeneralRank:
            rank = 6;
            break;
        case YYDifficultyRank:
            rank = 7;
            break;
        case YYAnomalyRank:
            rank = 8;
            break;
        default:
            rank = 8;
            break;
    }
    //11 ，7 ， 4
    int pointCount = rank + (level > 0 ? level : 0);
    int lineCount = pointCount + level + 1;
    for (int i = 0; i < pointCount; i++) {
        PointView *pointView = [PointView new];
        pointView.backgroundColor = [UIColor blackColor];
        pointView.layer.cornerRadius = kWidth / 2;
        pointView.layer.masksToBounds = YES;
        pointView.flag = i;
        pointView.text.text = [NSString stringWithFormat:@"%d",i + 1];
        pointView.frame = CGRectMake(0, 0, kWidth, kWidth);
        pointView.center = [self randomPoint];
        
        [_poingtArray addObject:pointView];
        pointView.layer.zPosition  = 12;
        [self.layer addSublayer:pointView.layer];
    }
    
    for (int i = 1; i < _poingtArray.count ; i++) {
        LineInfo *line = [LineInfo new];
        line.startView = _poingtArray[i - 1];
        line.endView = _poingtArray[i];
        [line.path moveToPoint:line.startView.center];
        [line.path addLineToPoint:line.endView.center];
        line.lineLayer.path = line.path.CGPath;
        line.lineLayer.zPosition  = 10;
        
        [self.layer addSublayer:line.lineLayer];
        [_lineArray addObject:line];
    }
    
    for (NSInteger i = (lineCount - _poingtArray.count); i < lineCount; i++) {
        int index1 = rand() % _poingtArray.count;
        int index2 = rand() % _poingtArray.count;
        if (index1 == index2) {
            i--;
            continue;
        }
        LineInfo *line = [LineInfo new];
        line.startView = _poingtArray[index1];
        line.endView = _poingtArray[index2];
        [line.path moveToPoint:line.startView.center];
        [line.path addLineToPoint:line.endView.center];
        line.lineLayer.path = line.path.CGPath;
        line.lineLayer.zPosition  = 10;
        BOOL fillter = NO;
        for (int j = 0; j < _lineArray.count; j++) {
            LineInfo *tmp = _lineArray[j];
            if ([tmp isEqual:line]) {
                fillter = YES;
                i++;
                break;
            }
        }
        if (!fillter) {
            [self.layer addSublayer:line.lineLayer];
            [_lineArray addObject:line];
        }
        
    }
    [self checkoutLineColor:NO];
    
    //    NSLog(@"point %@",_poingtArray);
}

- (BOOL)judgeLineIntersectWithOne:(LineInfo *)lineOne  two:(LineInfo *)two
{
    
    return [self segmentsIntersectWithOne:lineOne two:two];
}

- (int)dblcmpA:(double)a B:(double)b
{
    if (fabs(a-b) <= 1e-6) {
        return 0;
    }
    if (a > b) {
        return 1;
    }
    return -1;
}

//***************点积判点是否在线段上***************
- (double)dot:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2
{
    return x1 * x2 + y1 * y2;
}

//求a点是不是在线段bc上，>0不在，=0与端点重合，<0在。
- (int)pointOnLinePoint:(CGPoint)a pointB:(CGPoint)b pointC:(CGPoint)c
{
    return [self dblcmpA:[self dot:b.x-a.x y1:b.y-a.y x2:c.x-a.x y2:c.y-a.y] B:0];
}

- (double)crossX1:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2
{
    return x1*y2 - x2*y1;
}
//ab与ac的叉积
- (double)abCrossAc:(CGPoint)a pointB:(CGPoint)b pointC:(CGPoint)c
{
    return [self crossX1:b.x - a.x y1:b.y-a.y x2:c.x - a.x y2:c.y -a.y];
}

//求ab是否与cd相交，交点为p。1规范相交，0交点是一线段的端点，-1不相交。
- (BOOL)abCosscd:(CGPoint)a pointB:(CGPoint)b pointC:(CGPoint)c pointD:(CGPoint)d
{
    double s1 = 0;
    double s2 = 0;
    double s3 = 0;
    double s4 = 0;
    int d1 = 0;
    int d2 = 0;
    int d3 = 0;
    int d4 = 0;
    CGPoint p = CGPointZero;
    s1 = [self abCrossAc:a pointB:b pointC:c];
    s2 = [self abCrossAc:a pointB:b pointC:d];
    s3 = [self abCrossAc:c pointB:d pointC:a];
    s4 = [self abCrossAc:c pointB:d pointC:b];
    d1 = [self dblcmpA:s1 B:0];
    d2 = [self dblcmpA:s2 B:0];
    d3 = [self dblcmpA:s3 B:0];
    d4 = [self dblcmpA:s4 B:0];
    
    //如果规范相交则求交点
    if ((d1^d2)==-2 && (d3^d4)==-2)
    {
        p.x=(c.x*s2-d.x*s1)/(s2-s1);
        p.y=(c.y*s2-d.y*s1)/(s2-s1);
        //        NSLog(@"交点 %f %f",p.x,p.y);
        return YES;
    }
    //交点为端点
    if (d1 == 0 && [self pointOnLinePoint:c pointB:a pointC:b] <= 0) {
        p = c;
        
    } else if (d2 == 0 && [self pointOnLinePoint:d pointB:a pointC:b] <= 0) {
        p = d;

    } else if (d3 == 0 && [self pointOnLinePoint:a pointB:c pointC:d] <= 0) {
        p = a;
        
    } else if (d4 == 0 && [self pointOnLinePoint:b pointB:c pointC:d] <= 0) {
        p = b;
        
    }
    //    -1不相交
    return NO;
}

#pragma mark ------------ 判断两条直线是否相交
- (BOOL)segmentsIntersectWithOne:(LineInfo *)lineOne  two:(LineInfo *)two
{
    return [self abCosscd:lineOne.startView.center pointB:lineOne.endView.center pointC:two.startView.center pointD:two.endView.center];
}

//找到触摸的点
- (PointView *)findPoint:(CGPoint)point
{
    PointView *findView  = nil;
    CGPoint pointLine = point;
    for (PointView *view in _poingtArray) {
        pointLine = [view.layer convertPoint:point fromLayer:self.layer]; //get layer using containsPoint:
        
        if ([view.layer containsPoint:pointLine]) {
            findView = view;
            break;
        }
    }
    return findView;
}

//改变相交线的位置颜色
- (void)changeLine:(BOOL)checkoutWin
{
    for (LineInfo *info in _lineArray) {
        if (info.startView.flag == _movePoint.flag) {
            [info.path removeAllPoints];
            
            [info.path moveToPoint:info.startView.center];
            [info.path addLineToPoint:info.endView.center];
            info.lineLayer.path = info.path.CGPath;
            info.lineLayer.zPosition = 10;
            [self.layer addSublayer:info.lineLayer];
            
        } else if (info.endView.flag == _movePoint.flag) {
            [info.path removeAllPoints];
            
            [info.path moveToPoint:info.startView.center];
            [info.path addLineToPoint:info.endView.center];
            info.lineLayer.path = info.path.CGPath;
            info.lineLayer.zPosition = 10;
            [self.layer addSublayer:info.lineLayer];
            
        }
    }
    [self checkoutLineColor:checkoutWin];
}

//改变相交线的颜色
- (void)checkoutLineColor:(BOOL)checkoutWin
{
    NSInteger count = _lineArray.count;
    for (int i = 0; i < _lineArray.count; i++) {
        LineInfo *start = _lineArray[i];
        BOOL judge = NO;
        for (int j = 0; j < _lineArray.count; j++) {
            if (i == j) {
                continue;
            }
            
            LineInfo *end = _lineArray[j];
            if ([self judgeLineIntersectWithOne:start two:end]) {
                
                judge = YES;
            }
        }
        if (judge) {
            
            start.lineLayer.strokeColor = [UIColor blackColor].CGColor;
            count += 1;
            NSLog(@"flog %d",start.startView.flag);
        } else {
            count -= 1;
            start.lineLayer.strokeColor = [UIColor greenColor].CGColor;
        }
    }
    //    NSLog(@"count %ld",(long)count);
    _lineTipsLabel.text = [NSString stringWithFormat:@"%d/%d",(int)count / 2,(int)_lineArray.count];
    if (count <= 0 && checkoutWin) {
        if (_winBlock) {
            self.winBlock(_currentLevel,_currentRankType);
            [self configWinCount:_currentLevel rank:_currentRankType count:_timeCount];
            [self configFlag:_currentLevel rank:_currentRankType];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiddenBgView];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    PointView *view = [self findPoint:point];
//        NSLog(@"touchesBegan %@",view);
    _movePoint = view;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    point.x = MIN(MAX(10, point.x), [UIScreen mainScreen].bounds.size.width - 10);
    point.y = MIN(MAX(30, point.y), [UIScreen mainScreen].bounds.size.height - 10);
    _movePoint.center = point;
    [self changeLine:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    point.x = MIN(MAX(10, point.x), [UIScreen mainScreen].bounds.size.width - 10);
    point.y = MIN(MAX(30, point.y), [UIScreen mainScreen].bounds.size.height - 10);
    _movePoint.center = point;
    [self changeLine:YES];
    //    NSLog(@"touchesEnded");
    _movePoint = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configFlag:(int)level rank:(int)rank
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:YES forKey:[NSString stringWithFormat:@"flag_leve_%d_rank_%d",level,rank]];
    [def synchronize];
}

- (BOOL)getConfigFlag:(int)level rank:(int)rank
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def boolForKey:[NSString stringWithFormat:@"flag_leve_%d_rank_%d",level,rank]];
}

- (void)configWinCount:(int)level rank:(int)rank count:(int)count
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger time = [def integerForKey:[NSString stringWithFormat:@"win_leve_%d_rank_%d_count_%d",level,rank,count]];
    if (time > 0 && count < time) {
        [def setInteger:count forKey:[NSString stringWithFormat:@"win_leve_%d_rank_%d_count_%d",level,rank,count]];
        [def synchronize];
    }
}

- (NSInteger)getConfigWinCount:(int)level rank:(int)rank count:(int)count
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:[NSString stringWithFormat:@"win_leve_%d_rank_%d_count_%d",level,rank,count]];
}

@end
