//
//  UpdateTool.m
//  HX_GJS
//
//  Created by litao on 15/9/18.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "UpdateTool.h"
#import "HttpTool.h"
#import "CgiDefine.h"
#import "HostSetting.h"

static NSString * const UPDATE_KEY = @"isUpdate";
static NSString * const FORCE_KEY = @"isForce";
static NSString * const UPDATE_MSG_KEY = @"updateMsg";

@interface UpdateTool () <NSXMLParserDelegate>{
    //  升级沙盒
    NSUserDefaults *updateUserDefaults;
}
//  解析出得数据，内部是字典类型
@property (strong ,nonatomic) NSMutableArray * notes;
//  当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName;
@end

@implementation UpdateTool

#pragma mark - 单例
/**
 *  创建单例
 */
+ (UpdateTool *)sharedInstance
{
    // 1.定义一个静态变量来保存你类的实例确保在你的类里面保持全局
    static UpdateTool *_sharedInstance = nil;
    
    // 2.定义一个静态的dispatch_once_t变量来确保这个初始化存在一次
    static dispatch_once_t oncePredicate;
    
    // 3.用GCD来执行block初始化实例
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[UpdateTool alloc] init];
        //  沙盒
        _sharedInstance->updateUserDefaults = [NSUserDefaults standardUserDefaults];
        //  数组
        _sharedInstance->_notes = [NSMutableArray array];
        //  tag
        _sharedInstance->_currentTagName = nil;
    });
    
    return _sharedInstance;
}

#pragma mark - 升级信息网络请求相关信息
/**
 *  获取升级相关消息
 */
- (void)reqUpdateInfo
{
    [HttpTool postUrl:GJS_CheckUpdate params:nil success:^(id responseObj) {
        //加载完成
        [self reqUpdateInfo_callBack:responseObj];
    } failure:^(NSError *error) {
        //  ---
    }];
}

- (void)reqUpdateInfo_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
    //        NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
    //        NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
    
    if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccess]) {
        
        NSDictionary *resultDic = [body objectForKeyForSafetyDictionary:@"result"];
        
        [self checkUUpData:resultDic];
    } else {
        //
    }
}

#pragma mark [检查升级]
- (void)checkUUpData:(NSDictionary *)resultDic
{
    NSDictionary *appInfoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appInfoDic objectForKey:@"CFBundleShortVersionString"];
    //DLog(@"cur AppVersion [%@]", appVersion);
#pragma mark - 先判断标志位 -> 控制是否强制 --> 有无关闭按钮
    //  升级级别 0：普通升级，小红点提示；1：建议升级，弹出框提示；2：强制升级
    NSString *updateLv = FMT_STR(@"%@", [resultDic objectForKeyForSafetyValue:@"updateLevel"]);
    if ([updateLv isEqualToString:@"2"]) {
        [self setIsForce:YES];
    } else {
        [self setIsForce:NO];
    }
    
    if ([[resultDic objectForKeyForSafetyValue:@"haveNewVersion"] boolValue]) {
        [self setIsUpdate:YES];
        [self setUpdateDescMsg:[resultDic objectForKeyForSafetyValue:@"desc"]];
        //  通知弹窗
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkIsUpdate" object:nil];
    } else {
        [self setIsUpdate:NO];
    }
}

#pragma mark - 方法
/**
 *  更新信息
 */
- (void)setUpdateDescMsg:(NSString *)msg
{
    [updateUserDefaults removeObjectForKey:UPDATE_MSG_KEY];
    [updateUserDefaults setObject:msg forKey:UPDATE_MSG_KEY];
    
    [updateUserDefaults synchronize];
}

- (NSString *)getUpdateDescMsg
{
    return [updateUserDefaults objectForKey:UPDATE_MSG_KEY];
}

/**
 *  保存是否需要更新
 */
- (void)setIsUpdate:(BOOL)isUpdate
{
    [updateUserDefaults removeObjectForKey:UPDATE_KEY];
    [updateUserDefaults setBool:isUpdate forKey:UPDATE_KEY];
    
    [updateUserDefaults synchronize];
}

/**
 *  获取是否需要更新
 */
- (BOOL)getIsUpdate
{
    return [updateUserDefaults boolForKey:UPDATE_KEY];
}

/**
 *  保存是否需要强制
 */
- (void)setIsForce:(BOOL)isForce
{
    [updateUserDefaults removeObjectForKey:FORCE_KEY];
    [updateUserDefaults setBool:isForce forKey:FORCE_KEY];
    
    [updateUserDefaults synchronize];
}

/**
 *  获取是否需要强制
 */
- (BOOL)getIsForce
{
    return [updateUserDefaults boolForKey:FORCE_KEY];
}
@end
