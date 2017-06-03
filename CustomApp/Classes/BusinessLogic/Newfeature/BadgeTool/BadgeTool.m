//
//  BadgeTool.m
//  HX_GJS
//
//  Created by litao on 15/9/17.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "BadgeTool.h"

#import "HttpTool.h"
#import "CgiDefine.h"

static NSString * const ServerTime = @"2014-04-18";

@interface BadgeTool () {
    //  小红点沙盒
    NSUserDefaults *badgeUserDefaults;
    //  系统公告数组
    NSMutableArray *oldNewsCenterArray;
    //  新闻动态数组
    NSMutableArray *oldNewInfomationArray;
    //  活动中心数组
    NSMutableArray *oldActCenterArray;
}

@end

@implementation BadgeTool
#pragma mark - 单例
/**
 *  创建单例
 */
+ (BadgeTool *)sharedInstance
{
    // 1.定义一个静态变量来保存你类的实例确保在你的类里面保持全局
    static BadgeTool *_sharedInstance = nil;
    
    // 2.定义一个静态的dispatch_once_t变量来确保这个初始化存在一次
    static dispatch_once_t oncePredicate;
    
    // 3.用GCD来执行block初始化实例
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[BadgeTool alloc] init];
        //  沙盒
        _sharedInstance->badgeUserDefaults = [NSUserDefaults standardUserDefaults];
        //  系统公告数组
        _sharedInstance->oldNewsCenterArray = [NSMutableArray array];
        //  新闻动态数组
        _sharedInstance->oldNewInfomationArray = [NSMutableArray array];
        //  活动中心数组
        _sharedInstance->oldActCenterArray = [NSMutableArray array];
        // 公开的沙盒
        _sharedInstance->_latestDateUserDefaults = [NSUserDefaults standardUserDefaults];
    });
    
    return _sharedInstance;
}

#pragma mark - 存储 - 获取沙盒中数组信息
/**
 *  根据类型获取type-array
 *
 *  @param badgeType
 *
 *  @return
 */
- (void)setDataArrayWithType:(NSArray *)dataArray badgeType:(BadgeTypeForBool)badgeType
{
    NSString *keyStr = FMT_STR(@"badgeType_%d_array", badgeType);
    
    [badgeUserDefaults removeObjectForKey:keyStr];
    
    [badgeUserDefaults setObject:dataArray forKey:keyStr];
    
    [badgeUserDefaults synchronize];
}

/**
 *  根据类型获取type-array
 *
 *  @param badgeType
 *
 *  @return
 */
- (NSArray *)getDataArrayWithType:(BadgeTypeForBool)badgeType
{
    NSArray *dataArray = [badgeUserDefaults objectForKey:FMT_STR(@"badgeType_%d_array", badgeType)];
    
    if (!dataArray) {
        dataArray = [NSArray array];
    }
    
    return dataArray;
}

#pragma mark - 网络请求小红相关信息
/**
 *  网络请求小红相关信息
 */
- (void)reqBadgeInfo
{
    //  请求系统公告小红点信息
    [self reqBadgeForNewsCenter];
    //  请求新闻动态小红点信息
    [self reqBadgeForNewInfomation];
    //  请求活动中心小红点信息
    [self reqBadgeForActCenter];
}

/**
 *  请求系统公告小红点信息
 */
- (void)reqBadgeForNewsCenter
{
    //  获取保存数据信息
    oldNewsCenterArray = [[NSMutableArray alloc] initWithArray:[self getDataArrayWithType:isShowNewsCenterType]];
    //  请求
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:ServerTime forKey:@"messageTime"];
    [dic setObject:@"0" forKey:@"type"];
    
    [HttpTool postUrl:HX_NEWSLIST_URL params:dic success:^(id responseObj) {
        //加载完成
        [self reqBadgeForNewsCenter_callBack:responseObj];
    } failure:^(NSError *error) {
        //  ---
    }];
}

/**
 *  数据解析
 *
 *  @param data
 */
- (void)reqBadgeForNewsCenter_callBack:(id)data
{
    if (data) {
        NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
        
        NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
        //        NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
        //        NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
        
        if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccessUpperCase]) {
            
            BOOL newMsg =  [[[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"newMsg"] boolValue];
            NSString *lastDate = [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"latestDate"];
            [self saveLastDate:lastDate andKey:@"oldKeyStrNewsCenter"];
            if (![self getIsShowBadgeWithType:isShowActCenterType])
            {
                if (newMsg) {
                    if (![lastDate isEqualToString:[self getLastDate:@"newKeyStrNewsCenter"]]) {
                        //  显示系统公告小红点
                        [self setBadgeIsShow:YES keyBadgeType:isShowNewsCenterType];
                    } else {
                        //  不显示系统公告小红点
                        [self setBadgeIsShow:NO keyBadgeType:isShowNewsCenterType];
                    }
                } else {
                    //  不显示系统公告小红点
                    [self setBadgeIsShow:NO keyBadgeType:isShowNewsCenterType];
                }
            }
            
        }
    } else {
        //[HttpTool handleErrorCodeFromServer:retCodeStr withNote:retNoteStr];
    }
}


/**
 *  请求新闻动态小红点信息
 */
- (void)reqBadgeForNewInfomation
{
    //  获取保存数据信息
    oldNewInfomationArray = [[NSMutableArray alloc] initWithArray:[self getDataArrayWithType:isShowNewInfomationType]];
    //  请求
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:ServerTime forKey:@"messageTime"];
    [dic setObject:@"1" forKey:@"type"];
    
    [HttpTool postUrl:HX_NEWSLIST_URL params:dic success:^(id responseObj) {
        //加载完成
        [self reqBadgeForNewInfomation_callBack:responseObj];
        
    } failure:^(NSError *error) {
        //  ---
    }];
}

/**
 *  数据解析
 *
 *  @param data
 */
- (void)reqBadgeForNewInfomation_callBack:(id)data
{
    if (data) {
        
        NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
        
        NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
        //        NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
        //        NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
        
        if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccessUpperCase]) {
            
            BOOL newMsg = [[[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"newMsg"] boolValue];
            NSString *lastDate = [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"latestDate"];
            [self saveLastDate:lastDate andKey:@"oldKeyStrNewInfomation"];
            if (![self getIsShowBadgeWithType:isShowActCenterType])
            {
                if (newMsg) {
                    if (![lastDate isEqualToString:[self getLastDate:@"newKeyStrNewInfomation"]]) {
                        //  显示系统公告小红点
                        [self setBadgeIsShow:YES keyBadgeType:isShowNewInfomationType];
                    } else {
                        //  不显示系统公告小红点
                        [self setBadgeIsShow:NO keyBadgeType:isShowNewInfomationType];
                    }
                } else {
                    //  不显示系统公告小红点
                    [self setBadgeIsShow:NO keyBadgeType:isShowNewInfomationType];
                }
            }
            
        }
    } else {
        //[HttpTool handleErrorCodeFromServer:retCodeStr withNote:retNoteStr];
    }
}


/**
 *  请求活动中心小红点信息
 */
- (void)reqBadgeForActCenter
{
    //  获取保存数据信息
    oldActCenterArray = [[NSMutableArray alloc] initWithArray:[self getDataArrayWithType:isShowActCenterType]];
    //  请求
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    
    [dic setObject:ServerTime forKey:@"messageTime"];
    [dic setObject:@"2" forKey:@"type"];
    
    [HttpTool postUrl:HX_NEWSLIST_URL params:dic success:^(id responseObj) {
        //加载完成
        [self reqBadgeForActCenter_callBack:responseObj];
    } failure:^(NSError *error) {
        //  ---
    }];
}

/**
 *  数据解析
 *
 *  @param data
 */
- (void)reqBadgeForActCenter_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    if (data) {
        
        NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
        //        NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
        //        NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
        
        if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccessUpperCase]) {
            BOOL newMsg = [[[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"newMsg"] boolValue];
            NSString *lastDate = [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"latestDate"];
            [self saveLastDate:lastDate andKey:@"oldKeyStrActCenter"];
            if (![self getIsShowBadgeWithType:isShowActCenterType])
            {
                if (newMsg) {
                    if (![lastDate isEqualToString:[self getLastDate:@"newKeyStrActCenter"]]) {
                        //  显示系统公告小红点
                        [self setBadgeIsShow:YES keyBadgeType:isShowActCenterType];
                    } else {
                        //  不显示系统公告小红点
                        [self setBadgeIsShow:NO keyBadgeType:isShowActCenterType];
                    }
                } else {
                    //  不显示系统公告小红点
                    [self setBadgeIsShow:NO keyBadgeType:isShowActCenterType];
                }
            }
            //  重新赋值
            //                oldActCenterArray = [[NSMutableArray alloc] initWithArray:newDataArray];
            //                [self setDataArrayWithType:oldActCenterArray badgeType:isShowActCenterType];
        }
    } else {
        //[HttpTool handleErrorCodeFromServer:retCodeStr withNote:retNoteStr];
    }
}
//}

#pragma mark - 信息存取 - 沙盒足够
/**
 *  保存小红点信息
 *
 *  @param infoObj
 *  @param keyBadgeType
 */
- (void)setBadgeIsShow:(BOOL)isShow keyBadgeType:(BadgeTypeForBool)keyBadgeType
{
    NSNumber *infoObj = [[NSNumber alloc] initWithBool:isShow];
    //  按照类型类存储
    NSString *keyStr = FMT_STR(@"BadgeType_%d", keyBadgeType);
    //DLog(@"\nSet ==> [key = %@, value = %@]", keyStr, infoObj);
    //  存储沙盒
    [badgeUserDefaults removeObjectForKey:keyStr];
    
    [badgeUserDefaults setObject:infoObj forKey:keyStr];
    
    [badgeUserDefaults synchronize];
}

/**
 *  获取是否显示小红点信息
 *
 *  @param keyBadgeType
 *
 *  @return
 */
- (BOOL)getIsShowBadgeWithType:(BadgeTypeForBool)keyBadgeType
{
    //  更多模块类型单独处理
    if (keyBadgeType == isShowMoreTabbarType) {
        //  处理三个
        //  系统公告
        NSString *keyStrNewsCenter = FMT_STR(@"BadgeType_%d", isShowNewsCenterType);
        NSNumber *boolNewsCenter = [badgeUserDefaults objectForKey:keyStrNewsCenter];
        
        //  新闻动态
        NSString *keyStrNewInfomation = FMT_STR(@"BadgeType_%d", isShowNewInfomationType);
        NSNumber *boolNewInfomation = [badgeUserDefaults objectForKey:keyStrNewInfomation];
        
        //  活动中心
        NSString *keyStrActCenter = FMT_STR(@"BadgeType_%d", isShowActCenterType);
        NSNumber *boolActCenter = [badgeUserDefaults objectForKey:keyStrActCenter];
        
        return ([boolNewsCenter boolValue] || [boolNewInfomation boolValue] || [boolActCenter boolValue]);
    }
    //  按照类型类存储
    NSString *keyStr = FMT_STR(@"BadgeType_%d", keyBadgeType);
    NSNumber *boolStr = [badgeUserDefaults objectForKey:keyStr];
    //DLog(@"\nGet ==> [key = %@, value = %@]", keyStr, boolStr);
    
    return [boolStr boolValue];
}

/**
 *  保存小红点信息
 *
 *  @param value
 *  @param badgeType
 */
- (void)setBadgeValue:(NSString *)value keyBadgeType:(BadgeTypeForValue)badgeType
{
    //  按照类型类存储
    NSString *keyStr = FMT_STR(@"BadgeTypeValue_%d", badgeType);
    //  存储沙盒
    [badgeUserDefaults removeObjectForKey:keyStr];
    
    [badgeUserDefaults setObject:value forKey:keyStr];
    
    [badgeUserDefaults synchronize];
}

/**
 *  获取小红点信息
 *
 *  @param badgeType
 *
 *  @return
 */
- (NSString *)getBadgeValueWithType:(BadgeTypeForValue)badgeType
{
    //  按照类型类存储
    NSString *keyStr = FMT_STR(@"BadgeTypeValue_%d", badgeType);
    NSString *value = [badgeUserDefaults objectForKey:keyStr];
    
    if (!value || [value isNullStr]) {
        value = @"";
    }
    
    return value;
}
#pragma mark - 保存时间 oldKey - Value
- (void)saveLastDate:(NSString *)lastDate andKey:(NSString *)oldKeyStr
{
    [self.latestDateUserDefaults setObject:lastDate forKey:oldKeyStr];
    
    [self.latestDateUserDefaults synchronize];
}

#pragma mark - 取值时间 newKey - Value
-(NSString *)getLastDate:(NSString *)newKeyStr
{
    NSString *value = [self.latestDateUserDefaults objectForKey:newKeyStr];
    
    return value;
}




#pragma mark - 小红点比对逻辑
/**
 *  比较
 *
 *  @param array1
 *  @param array2
 *
 *  @return
 */
-(BOOL)CompareArrayIsEqual:(NSArray *)srcArray and:(NSArray *)destArray
{
    BOOL isE = NO;
    
    for (NSDictionary *dic1 in srcArray) {
        
        for (NSDictionary *dic2 in destArray) {
            //  根据mId判断
            NSString *str1 = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"id"]];
            NSString *str2 = [NSString stringWithFormat:@"%@",[dic2 objectForKey:@"id"]];
            
            if ([str1 isEqualToString:str2]) {
                isE = YES;
                break;
            } else {
                isE = NO;
            }
        }
    }
    
    return isE;
}

#pragma mark - 小红点相关
/**
 * 自定义小红点
 */
+(UILabel*)redPointLabel:(CGRect)rect
{
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.backgroundColor = COMMON_RED_COLOR;
    label.clipsToBounds =YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = label.width * .5f;
    
    return label;
}

@end
