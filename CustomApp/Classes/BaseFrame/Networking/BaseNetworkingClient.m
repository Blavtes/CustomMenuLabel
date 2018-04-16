//
//  BaseNetworkingClient.m
//  HX_GJS
//
//  Created by litao on 16/1/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseNetworkingClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
static CGFloat const kCommonNetworkingTimeout = 30;

//@implementation BaseNetworkingClient
//
//+ (instancetype)sharedClient
//{
//    static BaseNetworkingClient *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//        config.timeoutIntervalForRequest = kCommonNetworkingTimeout;
//
//        _sharedClient = [[BaseNetworkingClient alloc] initWithBaseURL:[NSURL URLWithString:GJS_HOST_NAME] sessionConfiguration:config];
//        //  设置返回格式
//        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
//        //  设置请求格式
//        [_sharedClient.requestSerializer setValue:@"zh-CN,en;" forHTTPHeaderField:@"Accept-Language"];
//        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
////        _sharedClient.requestSerializer.timeoutInterval = kCommonNetworkingTimeout;
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _sharedClient.operationQueue.maxConcurrentOperationCount = 10;
//    });
//
//    return _sharedClient;
//}
//
//@end
@interface BaseNetworkingClient ()

@property (nonatomic, strong) NSString             *lastIP;
@property (nonatomic, strong) NSString             *host;
@end


@implementation BaseNetworkingClient

+ (instancetype)sharedClient
{
    static BaseNetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BaseNetworkingClient alloc] init];
        _sharedClient.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:GJS_HOST_NAME]];
        _sharedClient.manager.requestSerializer.timeoutInterval = kCommonNetworkingTimeout;
        //  设置返回格式
        _sharedClient.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        //  设置请求格式
        [_sharedClient.manager.requestSerializer setValue:@"zh-CN,en;" forHTTPHeaderField:@"Accept-Language"];
        _sharedClient.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //        self.manager.requestSerializer.timeoutInterval = kCommonNetworkingTimeout;
        _sharedClient.manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.manager.operationQueue.maxConcurrentOperationCount = 10;
        _sharedClient.lastIP = @"";
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        // 状态消失的延时，默认为0.17秒。当调用不同接口时，关闭动画效果
        [AFNetworkActivityIndicatorManager sharedManager].completionDelay = 0.0;
        // 状态开启延时，默认为1s，当接口小于1s内返回结果，没必要开启效果
        [AFNetworkActivityIndicatorManager sharedManager].activationDelay = 0.0;
    });
    
    return _sharedClient;
}

+ (NSString *)getHostIP
{
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    NSString *host = @"app.gjfax.com";
    NSString *originalUrl = [NSString stringWithFormat:@"https://%@/",host];
    NSURL* url = [NSURL URLWithString:originalUrl];
    [httpdns setHTTPSRequestEnabled:YES];
    NSString * ip = [httpdns getIpByHostAsyncInURLFormat:url.host];
    if (ip) {
        return FMT_STR(@"https://%@/APP_SERVER/",ip);
    }
    return FMT_STR(@"https://116.7.236.212/APP_SERVER/");
}

static BaseNetworkingClient *_sharedClientHTTPDNS = nil;

+ (instancetype)sharedClientHttpDNS:(NSString *)ip host:(NSString *)host
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        _sharedClientHTTPDNS = [[BaseNetworkingClient alloc] init];
        
        _sharedClientHTTPDNS.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self getHostIP]]];
        _sharedClientHTTPDNS.manager.requestSerializer.timeoutInterval = kCommonNetworkingTimeout;
        _sharedClientHTTPDNS.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
        //  设置请求格式
        [_sharedClientHTTPDNS.manager.requestSerializer setValue:@"zh-CN,en;" forHTTPHeaderField:@"Accept-Language"];
        _sharedClientHTTPDNS.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sharedClientHTTPDNS.manager.requestSerializer setValue:host forHTTPHeaderField:@"host"];
        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [security setValidatesDomainName:NO];
        _sharedClientHTTPDNS.manager.securityPolicy = security;
        _sharedClientHTTPDNS.manager.operationQueue.maxConcurrentOperationCount = 10;
        _sharedClientHTTPDNS.lastIP = ip;
        _sharedClientHTTPDNS.host = host;
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        // 状态消失的延时，默认为0.17秒。当调用不同接口时，关闭动画效果
        [AFNetworkActivityIndicatorManager sharedManager].completionDelay = 0.0;
        // 状态开启延时，默认为1s，当接口小于1s内返回结果，没必要开启效果
        [AFNetworkActivityIndicatorManager sharedManager].activationDelay = 0.0;
    });
    
    return _sharedClientHTTPDNS;
}

- (instancetype)initHttpDNS
{
    if (self = [super init]) {
        _lastIP = @"";
    }
    return self;
}


- (void)configHttpDNSIP:(NSString*)ip path:(NSString*)path host:(NSString *)host
{
    
    if ([_lastIP isEqualToString:ip] && [_host isEqualToString:host]) {
        return;
    }
    _lastIP = ip;
    _sharedClientHTTPDNS = nil;
    [BaseNetworkingClient sharedClientHttpDNS:ip host:host];
    
}
@end

