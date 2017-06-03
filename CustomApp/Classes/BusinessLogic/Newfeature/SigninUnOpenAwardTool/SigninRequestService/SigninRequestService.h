//
//  SigninRequestService.h
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestService.h"

typedef NS_ENUM(NSInteger, SigninType) {
    SigninTypeDefault    =   0,         //默认 取数据
    SigninTypeShowText,                 //取数据 并 展示签到提示语
};

@interface SigninRequestService : SFRequestService

@property (nonatomic, assign) SigninType          signinType;

#pragma mark - 未改版完成，后续将改为model
@property (nonatomic, strong) NSDictionary          *resultDic;

/*
 *  请求签到特殊方法。已含流程
 */
+ (void)startSiginRequestWithShowText;
@end
