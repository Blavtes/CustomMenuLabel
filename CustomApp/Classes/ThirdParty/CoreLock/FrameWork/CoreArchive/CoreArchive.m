//
//  ToolArc.m
//  私人通讯录
//
//  Created by muxi on 14-9-3.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "CoreArchive.h"
#import "CryptUtil.h"

@implementation CoreArchive

#pragma mark - 偏好类信息存储
//  保存普通对象
+ (void)setStr:(NSString *)str key:(NSString *)key
{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //  信息加密后再存储
    NSString *cryptedInfo = @"";
    if (str && ![str isNilObj]) {
        cryptedInfo = CryptUtil->encryptDES128WithMD5(str, kCryptKey, kIvValue);
    }
    
    //保存
    [defaults setObject:cryptedInfo forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//  读取
+ (NSString *)strForKey:(NSString *)key
{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //  信息取出来后要经过解密
    NSString *cryptedInfo = [defaults objectForKey:key];
    NSString *info = @"";
    if (cryptedInfo && ![cryptedInfo isNilObj]) {
        //  如果检测到位数小于24位【加密后信息固定24位】就特殊处理
        if (cryptedInfo.length < 24) {
            info = FMT_STR(@"%@", cryptedInfo);
            //  再将信息加密存储一次 保证下次取出能够正常
            [CoreArchive setStr:info key:key];
        } else {
            info = CryptUtil->decryptDES128WithMD5(cryptedInfo, kCryptKey, kIvValue);
        }
    }
    
    return info;

}

//  删除
+ (void)removeStrForKey:(NSString *)key
{
    
    [self setStr:nil key:key];

}

//  保存int
+ (void)setInt:(NSInteger)i key:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setInteger:i forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//  读取
+ (NSInteger)intForKey:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSInteger i=[defaults integerForKey:key];
    
    return i;
}

//  保存float
+ (void)setFloat:(CGFloat)floatValue key:(NSString *)key
{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setFloat:floatValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//  读取
+ (CGFloat)floatForKey:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat floatValue=[defaults floatForKey:key];
    
    return floatValue;
}


//  保存bool
+ (void)setBool:(BOOL)boolValue key:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setBool:boolValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//  读取
+ (BOOL)boolForKey:(NSString *)key
{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    BOOL boolValue=[defaults boolForKey:key];
    
    return boolValue;
}




#pragma mark - 文件归档
//  归档
+ (BOOL)archiveRootObject:(id)obj toFile:(NSString *)path
{
   return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

// 删除
+ (BOOL)removeRootObjectWithFile:(NSString *)path
{
    return [self archiveRootObject:nil toFile:path];
}

//  解档
+ (id)unarchiveObjectWithFile:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

@end
