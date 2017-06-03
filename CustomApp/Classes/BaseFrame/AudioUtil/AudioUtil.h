//
//  AudioUtil.h
//  HX_GJS
//
//  Created by litao on 16/5/4.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioUtil : NSObject

/**
 *  单例
 *
 *  @return
 */
+ (instancetype)sharedInstance;

#pragma mark - 震动
- (void)startAudioVibrate;

@end
