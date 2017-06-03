//
//  NSTimer+Safety.m
//  safetyCrashDemo
//
//  Created by Blavtes on 2017/3/28.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "NSTimer+Safety.h"
#import "SafetyCrash.h"
#import <objc/runtime.h>

@implementation NSTimer (Safety)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //swizz
        [SafetyCrash exchangeClassMethod:[self class] method1Sel:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) method2Sel:@selector(SafetyScheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
        [SafetyCrash exchangeClassMethod:[self class] method1Sel:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) method2Sel:@selector(SafetyTimerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)SafetyScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    if (yesOrNo) {
        SubTagertProxy *pro = [SubTagertProxy new];
        
        NSTimer *timer = [self SafetyScheduledTimerWithTimeInterval:ti target:pro selector:@selector(fireProxyTimer:) userInfo:userInfo repeats:yesOrNo];
        pro.timer = timer;
        pro.target = aTarget;
        pro.selector = aSelector;
        pro.targetClass = [aTarget class];
        pro.userInfo = userInfo;
        return timer;
    }
   
    return [self SafetyScheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)SafetyTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    if (yesOrNo) {
        SubTagertProxy *pro = [SubTagertProxy new];
        
        NSTimer *timer = [self SafetyTimerWithTimeInterval:ti target:pro selector:@selector(fireProxyTimer:) userInfo:userInfo repeats:yesOrNo];
        pro.timer = timer;
        pro.target = aTarget;
        pro.selector = aSelector;
        pro.targetClass = [aTarget class];
        pro.userInfo = userInfo;
        return timer;
    }
    
    return [self SafetyTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

@end

@implementation SubTagertProxy

- (void)fireProxyTimer:(NSDictionary *)userInfo
{
    if (_target == nil) {
        [_timer invalidate];
    } else {
        if (_selector) {
            [_target performSelector:_selector withObject:_userInfo];
        }
    }
}

@end
