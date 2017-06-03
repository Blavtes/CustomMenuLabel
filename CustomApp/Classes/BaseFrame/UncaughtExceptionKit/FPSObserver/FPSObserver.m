//
//  FPSObserver.m
//  GjFax
//
//  Created by litao on 2017/3/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "FPSObserver.h"

@interface FPSObserver() {
    NSTimeInterval lastTime;
    NSInteger count;
    float countOfFps;
}

@property (strong, nonatomic) CADisplayLink *displayLink;

@end

@implementation FPSObserver

+ (instancetype)startObserver
{
    static FPSObserver *_observer = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _observer = [[FPSObserver alloc] init];
        _observer->count = 0;
        _observer->countOfFps = 0;
        _observer->lastTime = 0;
        _observer->_displayLink = [CADisplayLink displayLinkWithTarget:_observer selector:@selector(countingFPS:)];
        [_observer->_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    });
    
    return _observer;
}

- (void)countingFPS:(CADisplayLink *)displayLink
{
    if (lastTime == 0) {
        lastTime = _displayLink.timestamp;
        return;
    }
    
    count++;
    NSTimeInterval timeout = _displayLink.timestamp - lastTime;
    if (timeout < 1) {
        return;
    }
    lastTime = _displayLink.timestamp;
    countOfFps = count / timeout;
    count = 0;
}

- (NSInteger)fps
{
    return countOfFps;
}

- (void)dealloc
{
    [_displayLink invalidate];
    _displayLink = nil;
}
@end
