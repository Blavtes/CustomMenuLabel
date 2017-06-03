//
//  NSString+MD5.m
//  HX_GJS
//
//  Created by litao on 16/1/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NSString+MD5.h"
#import "NSData+CommonCrypto.h"

@implementation NSString (MD5)

#pragma mark - MD5加密
- (NSString *)MD5Sum
{
    NSString *retStr = [self MD5SumWithRetType:MD5RetTypeDefault];
    
    return retStr;
}

- (NSString *)MD5SumWithRetType:(MD5RetType)type
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //  This is the md5 call
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *retStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    //  32 或者 16
    switch (type) {
        case MD5RetTypeDefault:
        {
            for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
                [retStr appendFormat:@"%02X", result[i]];
            }
        }
            break;
            
        case MD5RetTypeFor16:
        {
            for(int i = 4; i < CC_MD5_DIGEST_LENGTH - 4; i++) {
                [retStr appendFormat:@"%02X", result[i]];
            }
        }
            break;
    }
    
    return retStr;
}

@end
