//
//  LocationTool.h
//  GjFax
//
//  Created by Blavtes on 2017/4/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTool : NSObject
@property (nonatomic, strong) CLLocationManager * locationManager;

+ (LocationTool*)shareManager;
//用户状态 
+ (BOOL)locationUserStatus;
//是否能使用位置
+ (BOOL)getLocationServicesEnabled;
//位置信息；服务器关闭，用户拒绝 授权
+ (void)setLocationServicesEnabled:(BOOL)enabled;

/**
 *  上传定理位置数据
 */
- (void)submitCollectionData;

@end

@interface LocationModel : NSObject
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *locationDes;
@property (nonatomic, strong) NSString *latitude; //经纬度
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *city;
+ (LocationModel *)shareManager;
@end
