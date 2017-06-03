//
//  CryptUtil.m
//  HX_GJS
//
//  Created by litao on 16/3/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CryptUtil.h"

#pragma mark - AES-MD5-128加密
static NSString * _encryptDES128WithMD5(NSString *cryptStr, NSString *MD5Key, NSString *cryptIv)
{
    if (!cryptStr || [cryptStr isNilObj]) {
        return @"";
    }
    NSString *keyWithMD5 = [MD5Key MD5SumWithRetType:MD5RetTypeFor16];
    NSData *encryptedData = [[cryptStr dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataUsingKey:keyWithMD5 iv:cryptIv error:nil];
    
    NSString *base64EncodedString = [encryptedData dataToBase64StrWithLength:[encryptedData length]];
    
    return base64EncodedString;
}

static NSString * _decryptDES128WithMD5(NSString *base64EncodedStr, NSString *MD5Key, NSString *cryptIv)
{
    if (!base64EncodedStr || [base64EncodedStr isNilObj]) {
        return @"";
    }
    NSData *encryptedData = [base64EncodedStr strToBase64Data];
    NSString *keyWithMD5 = [MD5Key MD5SumWithRetType:MD5RetTypeFor16];
    
    NSData *decryptedData = [encryptedData decryptedAES128DataUsingKey:keyWithMD5 iv:cryptIv error:nil];
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

#pragma mark - AES-SHA-256加密
static NSString * _encryptDES256WithSHA(NSString *cryptStr, NSString *SHAKey)
{
    if (!cryptStr || [cryptStr isNilObj]) {
        return @"";
    }
    NSData *encryptedData = [[cryptStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[SHAKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    NSString *base64EncodedString = [encryptedData dataToBase64StrWithLength:[encryptedData length]];
    
    return base64EncodedString;
}

static NSString * _decryptDES256WithSHA(NSString *base64EncodedStr, NSString *SHAKey)
{
    if (!base64EncodedStr || [base64EncodedStr isNilObj]) {
        return @"";
    }
    NSData *encryptedData = [base64EncodedStr strToBase64Data];
    
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[SHAKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

static CryptUtil_t * cryptFuncUtil = NULL;

@implementation _CryptUtil
+ (CryptUtil_t *)sharedUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cryptFuncUtil = malloc(sizeof(CryptUtil_t));
        cryptFuncUtil->encryptDES128WithMD5 = _encryptDES128WithMD5;
        cryptFuncUtil->decryptDES128WithMD5 = _decryptDES128WithMD5;
        cryptFuncUtil->encryptDES256WithSHA = _encryptDES256WithSHA;
        cryptFuncUtil->decryptDES256WithSHA = _decryptDES256WithSHA;
    });
    
    return cryptFuncUtil;
}

#pragma mark - 释放
+ (void)destroy
{
    cryptFuncUtil ? free(cryptFuncUtil) : 0;
    cryptFuncUtil = NULL;
}
@end
