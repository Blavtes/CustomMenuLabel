//
//  HttpParamsSetting.m
//  YiYunMi
//
//  Created by litao on 15/9/8.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "HttpParamsSetting.h"
#import "CommonMethod.h"
//#import "AESCrypt.h"
#import "CryptUtil.h"

@implementation HttpParamsSetting
#pragma mark - 自定义参数字典封装
/**
 *  请求参数封装
 *
 *  @param dicParams    标准json格式参数字典
 *
 *  @return mutableDic
 */
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)dicParams
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    //  sortDic
    retDic = [self dicParamsSetting:nil dicParams:dicParams security:nil];
    
    return retDic;
}

/**
 *  请求参数封装
 *
 *  @param src          请求来源
 *  @param dicParams    标准json格式参数字典
 *  @param securityCode 安全码
 *
 *  @return mutableDic
 */
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)srcDic
                                dicParams:(NSMutableDictionary *)dicParams
                                 security:(NSMutableDictionary *)securityDic
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    //  origin - 渠道等参数
    if (!srcDic) {
        //  orgin
        NSMutableDictionary *originDic = [[NSMutableDictionary alloc] init];
        [originDic setObject:Gjfax_iOS_PlatformStr forKey:@"platform"];
        [originDic setObject:Gjfax_iOS_ChannelStr forKey:@"channel"];
        [originDic setObject:Gjfax_iOS_ApiVersion forKey:@"apiVersion"];
        [originDic setObject:[CommonMethod appVersion] forKey:@"appVersion"];
        [originDic setObject:[CommonMethod UUIDWithKeyChain] forKey:@"uuid"];
        [originDic setObject:[CommonMethod strTimeIntervalSince1970] forKey:@"timestamp"];
#pragma mark - 手机型号 - 系统号
        [originDic setObject:[CommonMethod deviceType] forKey:@"phoneType"];
        NSString *sysVersion = FMT_STR(@"%@_%@", [[UIDevice currentDevice] systemName],
                                       [[UIDevice currentDevice] systemVersion]);
        [originDic setObject:sysVersion forKey:@"sysVersion"];
        
        [retDic setObject:originDic forKey:@"origin"];
    } else {
        [retDic setObject:srcDic forKey:@"origin"];
    }
    
    //  param - 参数
    NSString *cryptedStr = [self fetchCryptedParamStr:dicParams];
    [retDic setObjectJudgeNil:cryptedStr forKey:@"param"];
    
    //  security - 校验参数
    if (!securityDic) {
        //  security
        NSMutableDictionary *securityDicDefault = [[NSMutableDictionary alloc] init];
        [securityDicDefault setObject:kSecurityType forKey:@"secType"];
        [securityDicDefault setObject:kSecurityCode forKey:@"secCode"];
        
        [retDic setObject:securityDicDefault forKey:@"security"];
    } else {
        [retDic setObject:securityDic forKey:@"security"];
    }
    
    return retDic;
}

#pragma mark - 复杂参数
+ (NSMutableDictionary *)dicParamsSetting:(NSMutableDictionary *)srcDic
                         paramsJSONString:(NSString *)paramsJSONString
                                 security:(NSMutableDictionary *)securityDic
{
    NSMutableDictionary *retDic = [[NSMutableDictionary alloc] init];
    
    //  origin - 渠道等参数
    if (!srcDic) {
        //  orgin
        NSMutableDictionary *originDic = [[NSMutableDictionary alloc] init];
        [originDic setObject:Gjfax_iOS_PlatformStr forKey:@"platform"];
        [originDic setObject:Gjfax_iOS_ChannelStr forKey:@"channel"];
        [originDic setObject:Gjfax_iOS_ApiVersion forKey:@"apiVersion"];
        [originDic setObject:[CommonMethod appVersion] forKey:@"appVersion"];
        [originDic setObject:[CommonMethod UUIDWithKeyChain] forKey:@"uuid"];
        [originDic setObject:[CommonMethod strTimeIntervalSince1970] forKey:@"timestamp"];
        
        [retDic setObject:originDic forKey:@"origin"];
    } else {
        [retDic setObject:srcDic forKey:@"origin"];
    }
    
    //  param - 参数
    NSString *cryptedStr = [self fetchCryptedParamStrForJSONString:paramsJSONString];
    [retDic setObjectJudgeNil:cryptedStr forKey:@"param"];
    
    //  security - 校验参数
    if (!securityDic) {
        //  security
        NSMutableDictionary *securityDicDefault = [[NSMutableDictionary alloc] init];
        [securityDicDefault setObject:kSecurityType forKey:@"secType"];
        [securityDicDefault setObject:kSecurityCode forKey:@"secCode"];
        
        [retDic setObject:securityDicDefault forKey:@"security"];
    } else {
        [retDic setObject:securityDic forKey:@"security"];
    }
    
    return retDic;
}

#pragma mark - 组装返回结果
+ (NSDictionary *)dicFromServerRet:(id)responseObject
{
    NSMutableDictionary *retDic = [NSMutableDictionary dictionary];
    
    NSDictionary *retInfoDic = [responseObject objectForKey:@"retInfo"];
    NSString *cryptedResultStr = [responseObject objectForKey:@"result"];
    
    if ((retInfoDic == nil) && (cryptedResultStr == nil)) {
        return nil;
    } else {
    
        [retDic setObjectJudgeNil:retInfoDic forKey:@"retInfo"];
        
        NSString *resultJsonStr = [HttpParamsSetting jsonStrWithCryptedStr:[cryptedResultStr JSONString]];
        //  转换成字符串[0x0不调用isNilObj函数]
        resultJsonStr = FMT_STR(@"%@", resultJsonStr);
        
        if ([resultJsonStr isNilObj] || [resultJsonStr isEqualToString:@"{}"]) {
            [retDic setObjectJudgeNil:[NSNull null] forKey:@"result"];
        } else {
            id resultDic = [resultJsonStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            
            [retDic setObjectJudgeNil:resultDic forKey:@"result"];
        }
    }
    
    return retDic;
}

#pragma mark - 加解密
+ (NSString *)jsonStrWithCryptedStr:(NSString *)cryptedStr
{
    //NSString *resultJsonStr = [AESCrypt decryptDES128WithMD5:cryptedStr password:kCryptKey iv:kIvValue];
    NSString *resultJsonStr = CryptUtil->decryptDES128WithMD5(cryptedStr, kCryptKey, kIvValue);
    
    return resultJsonStr;
}

+ (NSString *)md5StrWithDic:(NSDictionary *)dic
{
    NSMutableString *enumStr = [[NSMutableString alloc] initWithCapacity:[dic JSONString].length];
    //  iphone5及以下机型通过[NSArray arrayWithArray:[dic allKeys]]获取的键是逆序的 - 导致前后台签名不一致
    NSArray *keyArray = @[@"origin", @"param", @"security"];
    //NSArray *keyArray = [NSArray arrayWithArray:[dic allKeys]];
    BOOL isSetFirstOne = NO;
    for (int index = 0; index < keyArray.count; index++) {
        
        NSString *keyStr = keyArray[index];
        id objValue = [dic objectForKey:keyStr];
        
        if (![objValue isNilObj]) {
            
            if (!isSetFirstOne) {
                
                if ([objValue isKindOfClass:[NSDictionary class]]) {
                    [enumStr appendFormat:@"%@=%@", keyStr, [objValue JSONString]];
                } else {
                    [enumStr appendFormat:@"%@=%@", keyStr, objValue];
                }
                
                isSetFirstOne = YES;
                
            } else {
                
                if ([objValue isKindOfClass:[NSDictionary class]]) {
                    [enumStr appendFormat:@"&%@=%@", keyStr, [objValue JSONString]];
                } else {
                    [enumStr appendFormat:@"&%@=%@", keyStr, objValue];
                }
            }
        }
        
    }
    
    [enumStr appendFormat:@"&key=%@", kCryptKey];
    
    //DLog(@"[cryptedReqDicJSONString--->\n]%@\n[md5StrWithDic--->]\n%@", enumStr, [enumStr MD5SumWithRetType:MD5RetTypeDefault]);
    
    return [enumStr MD5SumWithRetType:MD5RetTypeDefault];
}

#pragma mark - 获取加密后的参数数据
+ (NSString *)fetchCryptedParamStr:(NSDictionary *)dicParams
{
    NSString *cryptedStr = @"";
    if (dicParams) {
        //  测试用参数
        //NSDictionary *testDic = @{@"pageSize":@"20", @"pageNum":@"1"};
        //  加密
        NSString *paramStr = [dicParams JSONString];
        //cryptedStr = [AESCrypt encryptDES128WithMD5:paramStr password:kCryptKey iv:kIvValue];
        cryptedStr = CryptUtil->encryptDES128WithMD5(paramStr, kCryptKey, kIvValue);
        //DLog(@"[paramDicJSONString--->]\n%@\n[crypted paramDicJSONString--->]\n%@", paramStr, cryptedStr);
    }
    
    return cryptedStr;
}

+ (NSString *)fetchCryptedParamStrForJSONString:(NSString *)paramsJSONString
{
    NSString *cryptedStr = @"";
    if (paramsJSONString) {
        //  测试用参数
        //NSDictionary *testDic = @{@"pageSize":@"20", @"pageNum":@"1"};
        //  加密
        NSString *paramStr = [paramsJSONString JSONString];
        //cryptedStr = [AESCrypt encryptDES128WithMD5:paramStr password:kCryptKey iv:kIvValue];
        cryptedStr = CryptUtil->encryptDES128WithMD5(paramStr, kCryptKey, kIvValue);
        //DLog(@"[paramDicJSONString--->]\n%@\n[crypted paramDicJSONString--->]\n%@", paramStr, cryptedStr);
    }
    
    return cryptedStr;
}
@end
