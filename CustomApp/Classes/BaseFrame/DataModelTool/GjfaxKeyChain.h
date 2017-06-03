//
//  GjfaxKeyChain.h
//  GjFax
//
//  Created by gjfax on 16/10/17.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface GjfaxKeyChain : NSObject

#pragma mark - 函数

/**
 *  保存到keyChain
 *
 *  @param object 保存的对象
 *  @param key    key
 *
 *  return BOOL     YES为保存成功
 */
+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey;


/**
 *  获取keyChain数据
 *
 *  @param key 特定ID
 *
 *  @return id
 */
+ (id)objectForKey:(NSString *)aKey;

/**
 *  删除keyChain中数据
 *
 *  @param key    key
 *
 *  return BOOL   YES为保存成功
 */
+ (BOOL)removeObjectForKey:(NSString*)key;


#pragma mark - ------------------- 加密、解密 --------------------

/**
 *  加密
 *
 *  @param plaintext 明文
 *
 *  @return 密文 string
 */
+ (NSString *)encryptWithString:(NSString *)plaintext;


/**
 *  解密
 *
 *  @param cryptograph 密文string
 *
 *  @return 明文 string
 */
+ (NSString *)decryptWithString:(NSString *)cryptograph;
@end
