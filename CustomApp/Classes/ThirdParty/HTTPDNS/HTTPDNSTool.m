//
//  HTTPDNSTool.m
//  GjFax
//
//  Created by Blavtes on 2017/7/11.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "HTTPDNSTool.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "NetworkManager.h"
@interface HTTPDNSTool () <HttpDNSDegradationDelegate>

@end

@implementation HTTPDNSTool

+ (void)startHttpDNSService
{
    [[self new] startHttpDNSService];
}

- (void)startHttpDNSService
{
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    // 设置AccoutID
    [httpdns setAccountID:117158];
    // 为HTTPDNS服务设置降级机制
    [httpdns setDelegateForDegradationFilter:(id < HttpDNSDegradationDelegate >)self];
    // 允许返回过期的IP
    [httpdns setExpiredIPEnabled:YES];
    // 打开HTTPDNS Log，线上建议关闭
    //[httpdns setLogEnabled:YES];
    /*
     *  设置HTTPDNS域名解析请求类型(HTTP/HTTPS)，若不调用该接口，默认为HTTP请求；
     *  SDK内部HTTP请求基于CFNetwork实现，不受ATS限制。
     */
    [httpdns setHTTPSRequestEnabled:YES];
    // edited
    NSArray *preResolveHosts = @[@"app.gjfax.com", @"m.gjfax.com"];
    // NSArray* preResolveHosts = @[@"pic1cdn.igetget.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];
    //设置网络切换时是否自动刷新所有域名解析结果
    [httpdns setPreResolveAfterNetworkChanged:YES];
}

- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    DLog(@"Enters Degradation filter.");
    // 根据HTTPDNS使用说明，存在网络代理情况下需降级为Local DNS
    if ([NetworkManager configureProxies]) {
        DLog(@"Proxy was set. Degrade!");
        return YES;
    }
    
    // 假设您禁止"www.taobao.com"域名通过HTTPDNS进行解析
    if ([hostName isEqualToString:@"www.taobao.com"]) {
        DLog(@"The host is in blacklist. Degrade!");
        return YES;
    }
    
    return NO;
}
@end
