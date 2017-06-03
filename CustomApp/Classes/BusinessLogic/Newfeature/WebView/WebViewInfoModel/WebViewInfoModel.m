//
//  WebViewInfoModel.m
//  GjFax
//
//  Created by gjfax on 17/4/1.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "WebViewInfoModel.h"

@implementation WebViewInfoModel

#pragma mark - 单例
+ (WebViewInfoModel *)manager
{
    static WebViewInfoModel *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WebViewInfoModel alloc] init];
        _sharedInstance.webReg = [[WebReg alloc] init];
        _sharedInstance.webLogin = [[WebLogin alloc] init];
        _sharedInstance.termProDetail = [[TermProDetail alloc] init];
        _sharedInstance.transProDetail = [[TransProDetail alloc] init];
        _sharedInstance.getShareInfo = [[GetShareInfo alloc] init];
    });
    
    return _sharedInstance;
}

+ (void)cleanWebViewInfoData
{
    [[self manager] GJSResetAllProperty];
}

@end

@implementation WebReg

@end

@implementation WebLogin

@end

@implementation TermProDetail

@end

@implementation TransProDetail

@end

@implementation GetShareInfo

@end
