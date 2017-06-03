//
//  AudioUtil.m
//  HX_GJS
//
//  Created by litao on 16/5/4.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "AudioUtil.h"

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@implementation AudioUtil
+ (AudioUtil *)sharedInstance
{
    // 1.定义一个静态变量来保存你类的实例确保在你的类里面保持全局
    static AudioUtil *_sharedInstance = nil;
    
    // 2.定义一个静态的dispatch_once_t变量来确保这个初始化存在一次
    static dispatch_once_t oncePredicate;
    
    // 3.用GCD来执行block初始化实例
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AudioUtil alloc] init];
        
    });
    
    return _sharedInstance;
}

#pragma mark - 震动
- (void)startAudioVibrate
{
    //  震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
