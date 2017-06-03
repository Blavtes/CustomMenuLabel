//
//  GjfaxKeyChain.m
//  GjFax
//
//  Created by gjfax on 16/10/17.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GjfaxKeyChain.h"
#import "CryptUtil.h"

@interface GjfaxKeyChain ()


@end


@implementation GjfaxKeyChain


/**
 *  根据标识符 获取keyChain数据
 *
 *  @param key 特定ID
 *
 *  @return NSMutableDictionary
 */
+ (NSMutableDictionary *)keyChainQuery:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            key, (__bridge id)kSecAttrService,
            key, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

/**
 *  保存到keyChain
 *
 *  @param object 保存的对象
 *  @param key    key
 *
 *  return BOOL     YES为保存成功
 */
+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey
{
    NSMutableDictionary *keychainQuery = [self keyChainQuery:aKey];
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:anObject]
                      forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    
    if (status == 0) {
        return YES;
    }
    NSLog(@"保存用户信息到keychain失败");
    return NO;
}


/**
 *  获取keyChain数据
 *
 *  @param key 特定ID
 *
 *  @return id
 */
+ (id)objectForKey:(NSString *)aKey
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self keyChainQuery:aKey];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue
                      forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne
                      forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Keychain Unarchive of %@ failed: %@", aKey, e);
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    if (!ret || [ret isNullStr]) {
        ret = nil;
    }
    
    return ret;
}


/**
 *  删除keyChain中数据
 *
 *  @param key    key
 *
 *  return BOOL   YES为保存成功
 */
+ (BOOL)removeObjectForKey:(NSString*)key
{
    NSMutableDictionary *keychainQuery = [self keyChainQuery:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
    if (status == 0) {
        return YES;
    }
    
    NSLog(@"删除keychain 数据失败 key=%@", key);
    return NO;
}


#pragma mark - ------------------- 加密、解密 --------------------

/**
 *  加密
 *
 *  @param plaintext 明文
 *
 *  @return 密文 string
 */
+ (NSString *)encryptWithString:(NSString *)plaintext
{
    if (plaintext && ![plaintext isNullStr]) {
        NSString *cryptograph = CryptUtil->encryptDES128WithMD5(plaintext, kCryptKey, kIvValue);
        return cryptograph;
    }
    return @"";
}

/**
 *  解密
 *
 *  @param cryptograph 密文string
 *
 *  @return 明文 string
 */
+ (NSString *)decryptWithString:(NSString *)cryptograph
{
    if (cryptograph && ![cryptograph isNullStr]) {
        NSString *plaintext = CryptUtil->decryptDES128WithMD5(cryptograph, kCryptKey, kIvValue);
        return plaintext;
    }
    return @"";
}
@end
