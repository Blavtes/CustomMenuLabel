//
//  UMEventIDManager.h
//  HX_GJS
//
//  Created by gjfax on 15/10/29.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MobClick.h"
#import <UMMobClick/MobClick.h>


@interface UMEventIDManager : NSObject


/**
 *  开启友盟统计事件
 *  必须第一执行      appdelegate.m中执行
 *  appKey          友盟appkey
 *  reportPolicy    友盟发送时机策略
 *  channelId       渠道名称,为nil或@""时, 默认为@"App Store"渠道
 */
+ (void)starUMEventWithAppKey:(NSString *)appKey
                    reportPolicy:(ReportPolicy)policy
                       channelId:(NSString *)channeID;

/**
 *  上传事件
 *  eventID         事件ID，存于UMEventDefine.h中
 */
+ (void)sendEvent:(NSString *)eventID;

@end
