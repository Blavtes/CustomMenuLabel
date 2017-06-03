//
//  GJFaxKeyChainTool.h
//  GjFax
//
//  Created by gjfax on 16/9/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户密码
 */
static NSString * const Gjfax_KeyChainID_UserPassWord = @"GJFax_UserPassWord";
/**
 *  用户手机号
 */
static NSString * const Gjfax_KeyChainID_UserMobilePhone = @"GJFax_UserMobilePhone";
/**
 *  用户名称
 */
static NSString * const Gjfax_KeyChainID_UserName = @"GJFax_UserName";



@interface GJFaxKeyChainTool : NSObject



#pragma mark - 用户信息

/**
 *  取出用户登录的密码
 *
 *  @return NSString
 */
+ (NSString *)keyChainAccountPassword;

/**
 *  取出用户登录的手机号
 *
 *  @return NSString
 */
+ (NSString *)keyChainMobilePhone;

/**
 *  取出用户名
 *
 *  @return NSString
 */
+ (NSString *)keyChainUserName;


#pragma mark - 保存

+ (void)setKeyChainMobilePhone:(NSString *)mobilePhone;


+ (void)setKeyChainAccountPassword:(NSString *)accountPassword;

+ (void)setKeyChainUserName:(NSString *)userName;


@end
