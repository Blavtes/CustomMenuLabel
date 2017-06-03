//
//  UMEventIDManager.m
//  HX_GJS
//
//  Created by gjfax on 15/10/29.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import "UMEventIDManager.h"

@interface UMEventIDManager ()

@end

@implementation UMEventIDManager


+ (void)starUMEventWithAppKey:(NSString *)appKey
                    reportPolicy:(ReportPolicy)policy
                       channelId:(NSString *)channeID
{
    //友盟提供的开启统计事件
//    [MobClick startWithAppkey:appKey reportPolicy:policy channelId:channeID];
    UMConfigInstance.appKey = appKey;
    UMConfigInstance.ePolicy = policy;
    UMConfigInstance.channelId = channeID;
    [MobClick startWithConfigure:UMConfigInstance];
}

+ (void)sendEvent:(NSString *)eventID
{
    [MobClick event:eventID];
}

@end
