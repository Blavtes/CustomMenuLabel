//
//  MyGetRewardInfoService.h
//  GjFax
//
//  Created by Blavtes on 2017/3/29.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "SFRequestService.h"
#import "MyGetRewardInfo.h"

@interface MyGetRewardInfoService : SFRequestService

@property (nonatomic, strong) MyGetRewardInfo *rewardInfo;
//类型（1：注册；2：绑卡；3：投资）
- (void)fetchDataType:(int)type;
@end
