//
//  MyGetRewardInfoService.m
//  GjFax
//
//  Created by Blavtes on 2017/3/29.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "MyGetRewardInfoService.h"
#import "MyGetRewardInfo.h"

@implementation MyGetRewardInfoService

- (void)fetchDataType:(int)type
{
    self.dataParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(type),@"type", nil];
}

- (NSString *)apiUrl
{
    return @"";
}

- (void)unityConstrucSuccessData:(id)resultDic
{
    _rewardInfo = [[MyGetRewardInfo alloc] initWithDic:resultDic];
}

@end
