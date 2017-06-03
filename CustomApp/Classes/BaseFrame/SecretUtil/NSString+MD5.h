//
//  NSString+MD5.h
//  HX_GJS
//
//  Created by litao on 16/1/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MD5RetType) {
    MD5RetTypeDefault = 0,  //  默认32位
    MD5RetTypeFor16         //  16位
};

@interface NSString (MD5)

#pragma mark - MD5加密
- (NSString *)MD5Sum;
- (NSString *)MD5SumWithRetType:(MD5RetType)type;

@end
