//
//  CryptUtil.h
//  HX_GJS
//
//  Created by litao on 16/3/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kCryptKey = @"gjfax123";
static NSString * const kIvValue = @"ujhfwe9ihv0as89w";
//static NSString * const kCryptKey = @"b4c23a5606e84bb1a9b0ed524933d6bc";
//static NSString * const kIvValue = @"d9c17ba62f9242a1";
static NSString * const kSecurityCode = @"0";
static NSString * const kSecurityType = @"0";

/**
 *  函数名隐藏在结构体里，以函数指针成员的形式存储
 */
typedef struct _cryptFuncUtil
{
#pragma mark - AES-MD5-128加密
    NSString* (*encryptDES128WithMD5)(NSString *cryptStr, NSString *MD5Key, NSString *cryptIv);
    NSString* (*decryptDES128WithMD5)(NSString *base64EncodedStr, NSString *MD5Key, NSString *cryptIv);
    
#pragma mark - AES-SHA-256加密
    NSString* (*encryptDES256WithSHA)(NSString *cryptStr, NSString *SHAKey);
    NSString* (*decryptDES256WithSHA)(NSString *base64EncodedStr, NSString *SHAKey);
    
}CryptUtil_t;

#pragma mark - 宏定义

#define CryptUtil ([_CryptUtil sharedUtil])

@interface _CryptUtil : NSObject

#pragma mark - 单例
+ (CryptUtil_t *)sharedUtil;

@end
