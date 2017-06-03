//
//  BaseNetworkingClient.h
//  HX_GJS
//
//  Created by litao on 16/1/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface BaseNetworkingClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
