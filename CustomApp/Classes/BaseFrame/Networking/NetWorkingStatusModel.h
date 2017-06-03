//
//  NetWorkingStatusModel.h
//  GjFax
//
//  Created by gjfax on 17/1/6.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCellularData.h>
#import "Reachability.h"

@interface NetWorkingStatusModel : NSObject


/**
    组合 ：
    1、networkAuthState ＝ 0时， networkStatus != 0 ?  有网络 ： 无网络
    2、networkAuthState ＝ 1时， networkStatus == 2 ?  有网络 ： 无网络
    3、networkAuthState ＝ 2时， networkStatus != 0 ?  有网络 ： 无网络
 */

/**
 *  联网状态
 typedef NS_ENUM(NSUInteger, CTCellularDataRestrictedState) {
	kCTCellularDataRestrictedStateUnknown,      //  未知，不进行操作
	kCTCellularDataRestricted,                  //  关闭蜂窝网络
	kCTCellularDataNotRestricted                //  已开启 无线 and 蜂窝网络
 };
 */
@property (nonatomic, assign) CTCellularDataRestrictedState       networkAuthState;


/**
 *  网络状态
     typedef NS_ENUM(NSInteger, NetworkStatus) {
         // Apple NetworkStatus Compatible Names.
         NotReachable = 0,              //  无网络
         ReachableViaWWAN = 1           //  蜂窝网络
         ReachableViaWiFi = 2,          //  wifi

     };
 */
@property (nonatomic, assign) NetworkStatus                       networkStatus;



+ (instancetype)manager;

@end
