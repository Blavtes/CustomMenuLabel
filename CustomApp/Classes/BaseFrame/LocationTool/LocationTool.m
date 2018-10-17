//
//  LocationTool.m
//  GjFax
//
//  Created by Blavtes on 2017/4/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "LocationTool.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

//static LocationTool *myLocationManager;

@interface LocationTool () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, copy) void(^complete)(CLLocation *location);
@end

@implementation LocationTool

+ (LocationTool*)shareManager
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

+ (void)setLocationServicesEnabled:(BOOL)enabled
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enabled forKey:@"CLLocationManager_ServicesEnabled"];
    [defaults synchronize];
}

+ (BOOL)getLocationServicesEnabled
{
    NSUserDefaults *user =  [NSUserDefaults standardUserDefaults];
    BOOL value = [user boolForKey:@"CLLocationManager_ServicesEnabled"];
    return value;
}

//开始定位
- (instancetype)init {
    if (self = [super init]) {
    
        if ([CLLocationManager locationServicesEnabled]) {
            [LocationTool setLocationServicesEnabled:YES];
            //        CLog(@"--------开始定位");
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.delegate = self;
            //控制定位精度,越高耗电量越
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            // 总是授权
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            self.locationManager.distanceFilter = 10.0f;
            [self.locationManager startUpdatingLocation];
            NSString *string = [self getIPWithHostName:@"app.gjfax.com"];
            
            DLog(@"ip -> %@",string );
            [LocationModel shareManager].ip = string;
            
        } else {
            [LocationTool setLocationServicesEnabled:NO];
        }
    }
    return self;
}

+ (BOOL)locationUserStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        return NO;
    } else {
        [[LocationTool shareManager] submitCollectionData];
        return YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        BLYLogWarn(@"=== 定位信息异常： 访问被拒绝 === ");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        BLYLogWarn(@"=== 定位信息异常： 无法获取位置信息 ===  ");
    }
}

//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        return;
    }
    CLLocation *newLocation = locations[0];
    [LocationModel shareManager].latitude = FMT_STR(@"%f",newLocation.coordinate.latitude);
    [LocationModel shareManager].longitude = FMT_STR(@"%f",newLocation.coordinate.longitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            DLog(@"位置：%@",placemark.name);
            DLog(@"国家：%@",placemark.country);
            DLog(@"城市：%@",placemark.locality);
            DLog(@"区：%@",placemark.subLocality);
            DLog(@"街道：%@",placemark.thoroughfare);
            DLog(@"子街道：%@",placemark.subThoroughfare);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            DLog(@"city = %@", city);
            [LocationModel shareManager].locationDes = [NSString stringWithFormat:@"%@%@%@%@%@",placemark.country,city,placemark.subLocality,placemark.thoroughfare,placemark.name];
            BLYLogWarn(@"[LocationModel shareManager].locationDes = %@", [LocationModel shareManager].locationDes);
            [LocationModel shareManager].city = city;
            
        }
        else if (error == nil && [array count] == 0)
        {
            DLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            DLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)startLocation:(void(^)(CLLocation *location))complete
{
    self.complete = complete;
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
}

- (void)stopLocation
{
    [_locationManager stopUpdatingLocation];
    [_locationManager startUpdatingHeading];
}

- (void)startMonitoringSignificantLocationChanges:(void(^)(NSString *locationStr))complete
{
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoringSignificantLocationChanges
{
    [_locationManager stopMonitoringSignificantLocationChanges];
}

//根据域名获取ip地址
-(NSString*)getIPWithHostName:(const NSString*)strHostName
{
    const char* szname = [strHostName UTF8String];
    struct hostent* phot ;
    @try {
        phot = gethostbyname(szname);
    } @catch (NSException *e) {
        return nil;
    }
  
    struct in_addr ip_addr;
    if(phot) {
        memcpy(&ip_addr,phot->h_addr_list[0],4);
        //void *memcpy(void *dest, const void *src, size_t n);
        //从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中
        //h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    } else {
        return nil;
    }
    char ip[20] = {0};
    
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));//将二进制整数转换为点分十进制
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}

#pragma mark - 上传数据
/**
 *  上传数据
 */
- (void)submitCollectionData
{
    if ([[LocationModel shareManager].city length] == 0) {
        return;
    }
    //  转换成参数
    NSMutableDictionary *location = [[NSMutableDictionary alloc] init];
    
    [location setObjectJudgeNil:[LocationModel shareManager].city forKey:@"city"];
    [location setObjectJudgeNil:[LocationModel shareManager].longitude forKey:@"lon"];
    [location setObjectJudgeNil:[LocationModel shareManager].latitude forKey:@"lat"];
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:location forKey:@"location"];
    
    [HttpTool postUrl:GJS_CollectData params:reqDic success:^(id responseObj) {
        //  加载完成
        [self reqSubmitCollectionData_callBack:responseObj];
        
    } failure:^(NSError *error) {
        //
        DLog(@"%@",error);
    }];
}

- (void)reqSubmitCollectionData_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"errorCode"]);
    NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
    
#pragma mark - 上传成功
    if ([[retStatusStr lowercaseString] isEqualToString:kInterfaceRetStatusSuccess]) {
        DLog(@"[定理位置采集用户数据]-->上传成功");
        
    } else {
        DLog(@"[定理位置采集用户数据]-->上传失败[%@][%@]", retCodeStr, retNoteStr);
    }
}

@end

static LocationModel *myLocationModel;

@implementation LocationModel

+ (LocationModel *)shareManager
{
    @synchronized (self) {
        if (myLocationModel == nil) {
            myLocationModel = [[LocationModel alloc] init];
        }
    }
    return myLocationModel;
}

- (void)setLocationDes:(NSString *)locationDes
{
    NSString *ld = [self replaceUnicode:locationDes];
    if (ld.length > 0) {
        _locationDes = ld;
    } else {
        _locationDes = locationDes;
    }
}

- (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络连接/或者连接wifi-网络不通";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                }
                    break;
                default:
                    state = @"网络状态获取失败";
                    break;
            }
        }
        //根据状态选择
    }
    return state;
}

- (NSString *)description
{
    NSString *desStr =  FMT_STR(@"[address:%@]-[longitude,latitude:%@,%@]-[ip:%@]-[network:%@]",self.locationDes,_longitude,_latitude,_ip,[self getNetWorkStates]);
    DLog(@"%@",desStr);
    return desStr;
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    //    NSLog(@"%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
@end
