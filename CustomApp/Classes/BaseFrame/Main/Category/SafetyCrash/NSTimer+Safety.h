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

@end

@interface SubTagertProxy : NSObject

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) Class targetClass;
@property (nonatomic, weak) NSDictionary *userInfo;
- (void)fireProxyTimer:(NSDictionary *)userInfo;
@end
