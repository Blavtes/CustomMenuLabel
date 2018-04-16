//
//  BaseNetworkingClient.h
//  HX_GJS
//
//  Created by litao on 16/1/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface BaseNetworkingClient : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype)sharedClient;
+ (instancetype)sharedClientHttpDNS:(NSString*)ip host:(NSString *)host;
- (void)configHttpDNSIP:(NSString*)ip path:(NSString*)path host:(NSString *)host;
+ (NSString *)getHostIP;
@end

