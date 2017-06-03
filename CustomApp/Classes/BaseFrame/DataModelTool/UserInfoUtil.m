//
//  UserInfoUtil.m
//  HX_GJS
//
//  Created by litao on 16/1/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "UserInfoUtil.h"
#import "UserInfoTypeDefine.h"
#import "CryptUtil.h"
#import "GJFaxKeyChainTool.h"

#pragma mark - 具体值类型
static void _setUserInfoWithValue(UserInfoValueType infoType, NSString *info)
{
//#ifdef DEBUG
//#else
    //  如果是保存到keyChain则直接返回
    if (infoType == UserInfoValueTypeUserName) {
        [GJFaxKeyChainTool setKeyChainUserName:info];
        return ;
    } else if (infoType == UserInfoValueTypeMobilePhone) {
        [GJFaxKeyChainTool setKeyChainMobilePhone:info];
        return ;
    } else if (infoType == UserInfoValueTypeLoginPwd) {
        [GJFaxKeyChainTool setKeyChainAccountPassword:info];
        return ;
    }
//#endif
    //  信息加密后再存储
    NSString *cryptedInfo = @"";
    if (info && ![info isNilObj]) {
        cryptedInfo = CryptUtil->encryptDES128WithMD5(info, kCryptKey, kIvValue);
    }
    
    NSString *key = FMT_STR(@"UserInfoValueType_%ld", (long)infoType);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults setObject:cryptedInfo forKey:key];
    [userDefaults synchronize];
}

static NSString* _getUserInfoWithValue(UserInfoValueType infoType)
{
//#ifdef DEBUG
//#else
    //  从keyChain中取出 直接返回
    if (infoType == UserInfoValueTypeUserName) {
        return [GJFaxKeyChainTool keyChainUserName];;
    } else if (infoType == UserInfoValueTypeMobilePhone) {
        return [GJFaxKeyChainTool keyChainMobilePhone];;
    } else if (infoType == UserInfoValueTypeLoginPwd) {
        return [GJFaxKeyChainTool keyChainAccountPassword];;
    }
//#endif
    
    NSString *key = FMT_STR(@"UserInfoValueType_%ld", (long)infoType);
    //  信息取出来后要经过解密
    NSString *cryptedInfo = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *info = @"";
    if (cryptedInfo && ![cryptedInfo isNilObj]) {
        //  如果检测到位数小于24位【加密后信息固定24位】就特殊处理
        if (cryptedInfo.length < 24) {
            info = cryptedInfo;
            //  再将信息加密存储一次 保证下次取出能够正常
            UserInfoUtil->setUserInfoWithValue(infoType, info);
        } else {
            info = CryptUtil->decryptDES128WithMD5(cryptedInfo, kCryptKey, kIvValue);
        }
    }
    
    return info;
}

#pragma mark - bool类型
static void _setUserInfoWithBool(UserInfoBoolType infoType, BOOL info)
{
    NSString *key = FMT_STR(@"UserInfoBoolType_%ld", (long)infoType);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults setBool:info forKey:key];
    [userDefaults synchronize];
}

static BOOL _getUserInfoWithBool(UserInfoBoolType infoType)
{
    NSString *key = FMT_STR(@"UserInfoBoolType_%ld", (long)infoType);
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

#pragma mark - 清空
static void _clearGJSUserInfo(BOOL all)
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in [userDefaults dictionaryRepresentation]) {
        //  判断是否需要永久保存的【app存在的情况下】
        if ([key isEqualToString:FMT_STR(@"UserInfoBoolType_%ld", UserInfoBoolTypeFirstLaunched)] ||
            [key isEqualToString:FMT_STR(@"UserInfoBoolType_%ld", UserInfoBoolTypeIsAlreadyEnterApp)] ||
            [key isEqualToString:FMT_STR(@"UserInfoBoolType_%ld", UserInfoBoolTypeIsAlreadyLogined)] ||
             [key isEqualToString:FMT_STR(@"UserInfoBoolType_%ld", UserInfoBoolTypeFirstGotoNewYearsAction)]
            ) {
            continue;
        }
        [userDefaults removeObjectForKey:key];
        [userDefaults synchronize];
    }
}


static UserInfoUtil_t * funcUtil = NULL;

@implementation _UserInfoUtil
+ (UserInfoUtil_t *)sharedUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        funcUtil = malloc(sizeof(UserInfoUtil_t));
        funcUtil->setUserInfoWithValue = _setUserInfoWithValue;
        funcUtil->getUserInfoWithValue = _getUserInfoWithValue;
        funcUtil->setUserInfoWithBool = _setUserInfoWithBool;
        funcUtil->getUserInfoWithBool = _getUserInfoWithBool;
        funcUtil->clearGJSUserInfo = _clearGJSUserInfo;
    });
    
    return funcUtil;
}

+ (void)destroy
{
    funcUtil ? free(funcUtil) : 0;
    funcUtil = NULL;
}
@end
