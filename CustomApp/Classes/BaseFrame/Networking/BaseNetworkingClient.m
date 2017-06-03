//
//  BaseNetworkingClient.m
//  HX_GJS
//
//  Created by litao on 16/1/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseNetworkingClient.h"

static CGFloat const kCommonNetworkingTimeout = 30.0f;

@implementation BaseNetworkingClient

+ (instancetype)sharedClient
{
    static BaseNetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseNetworkingClient alloc] initWithBaseURL:[NSURL URLWithString:GJS_HOST_NAME]];
        //  设置返回格式
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        //  设置请求格式
        [_sharedClient.requestSerializer setValue:@"zh-CN,en;" forHTTPHeaderField:@"Accept-Language"];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.requestSerializer.timeoutInterval = kCommonNetworkingTimeout;
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
