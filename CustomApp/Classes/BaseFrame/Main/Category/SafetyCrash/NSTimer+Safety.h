//
//  NSTimer+Safety.h
//  safetyCrashDemo
//
//  Created by Blavtes on 2017/3/28.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Safety)
+ (void)safetyCrashExchangeMethod;

/**
 手动调用 带block 安全方法
 */
+ (NSTimer *)SafetyTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats target:(id)aTarget  block:(void (^)(NSTimer * timer))block;
+ (NSTimer *)SafetyScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
@end

@interface SubTagertProxy : NSObject

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) Class targetClass;
@property (nonatomic, weak) NSDictionary *userInfo;
@property (nonatomic, copy) void (^block)(NSTimer *timer);
- (void)fireProxyTimer:(NSDictionary *)userInfo;
@end
