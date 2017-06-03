//
//  MyAccountInfoRequestService.h
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestService.h"


typedef NS_ENUM(NSInteger, MyAccountInfoType) {
    MyAccountInfoTypeDefault    =   0,         //默认 取数据
    MyAccountInfoTypeUnOpenAward,              //取数据 并 处理待拆奖励
};

@interface MyAccountInfoRequestService : SFRequestService

@property (nonatomic, assign) MyAccountInfoType         myAccountInfoType;



/*
 *  待拆奖励，已含流程,不含结果回调
 */
+ (void)startCheckUnOpenAward;
@end
