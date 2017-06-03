//
//  GJFaxKeyChainTool.m
//  GjFax
//
//  Created by gjfax on 16/9/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GJFaxKeyChainTool.h"
#import "GjfaxKeyChain.h"

@implementation GJFaxKeyChainTool

#pragma mark - ------------- Getter -----------------
/**
 *  取出用户登录的手机号
 *
 *  @return NSString
 */
+ (NSString *)keyChainMobilePhone
{
    NSString *account = [GjfaxKeyChain objectForKey:Gjfax_KeyChainID_UserMobilePhone];
    NSString *info = [GjfaxKeyChain decryptWithString:account];
    
    return info;
}


/**
 *  取出用户登录的密码
 *
 *  @return NSString
 */
+ (NSString *)keyChainAccountPassword
{
    NSString *password = [GjfaxKeyChain objectForKey:Gjfax_KeyChainID_UserPassWord];
    NSString *info = [GjfaxKeyChain decryptWithString:password];
    
    return info;
}


/**
 *  取出用户名
 *
 *  @return NSString
 */
+ (NSString *)keyChainUserName
{
    
    NSString *userName = [GjfaxKeyChain objectForKey:Gjfax_KeyChainID_UserName];
    NSString *info = [GjfaxKeyChain decryptWithString:userName];
    
    return info;
}


#pragma mark - -------------------- Setter ----------------

/**
 *  保存 手机号、登录密码, 传空不保存
 *
 *  @param mobilePhone     手机号
 *  @param accountPassword 登录密码
 *  @param userName        用户名
 */


+ (void)setKeyChainMobilePhone:(NSString *)mobilePhone
{
    //保存帐号    信息加密后再存储
    if (mobilePhone && ![mobilePhone isNullStr]) {
        [GjfaxKeyChain setObject:NSStringSafety([GjfaxKeyChain encryptWithString:mobilePhone])
                          forKey:Gjfax_KeyChainID_UserMobilePhone];
                                                                          
    }
}

+ (void)setKeyChainAccountPassword:(NSString *)accountPassword
{
    //保存密码
    if (accountPassword && ![accountPassword isNullStr]) {
        [GjfaxKeyChain setObject:NSStringSafety([GjfaxKeyChain encryptWithString:accountPassword])
                          forKey:Gjfax_KeyChainID_UserPassWord];
    }
}

+ (void)setKeyChainUserName:(NSString *)userName
{
    //用户名
    if (userName && ![userName isNullStr]) {
        [GjfaxKeyChain setObject:NSStringSafety([GjfaxKeyChain encryptWithString:userName])
                          forKey:Gjfax_KeyChainID_UserName];
    }
}



@end
