//
//  NetWorkingStatusModel.m
//  GjFax
//
//  Created by gjfax on 17/1/6.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "NetWorkingStatusModel.h"

#define BASESDK_VERSION_GREATER_9_0 (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0)


@implementation NetWorkingStatusModel


+ (instancetype)manager
{
    static NetWorkingStatusModel *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {

#if BASESDK_VERSION_GREATER_9_0
        __weak typeof(self) weakSelf = self;

        //监控网络是否可用， 设置后，系统会弹框
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        self.networkAuthState = state;

        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            //状态改变时进行相关操作
            
            weakSelf.networkAuthState = state;
            switch (state) {
                case kCTCellularDataRestricted:

                    NSLog(@"kCTCellularDataRestricted");
                    break;
                case kCTCellularDataNotRestricted:
                    NSLog(@"kCTCellularDataNotRestricted");

                    break;
                case kCTCellularDataRestrictedStateUnknown:
                    NSLog(@"kCTCellularDataRestrictedStateUnknown");

                    break;
                default:
                    break;
            }
        };
#endif
        //  实时监听网络状态
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        self.networkStatus = [reach currentReachabilityStatus];
        reach.reachableBlock = ^(Reachability * reachability)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.networkStatus = [reachability currentReachabilityStatus];
                
//                NSString *string = FMT_STR(@" netStatus = %@  networkAuthState = %@", @(weakSelf.networkStatus), @(weakSelf.networkAuthState));
//                NSLog(@"%@", string);
            });
        };
        
        reach.unreachableBlock = ^(Reachability * reachability)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.networkStatus = [reachability currentReachabilityStatus];
//                NSString *string = FMT_STR(@" netStatus = %@  networkAuthState = %@", @(weakSelf.networkStatus), @(weakSelf.networkAuthState));
//                NSLog(@"%@", string);
            });
        };  
        
        [reach startNotifier];
        
    }
    return self;
}

@end
