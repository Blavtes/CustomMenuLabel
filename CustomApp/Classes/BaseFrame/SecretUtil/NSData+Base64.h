//
//  NSData+Base64.h
//  HX_GJS
//
//  Created by litao on 16/1/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

- (NSString *)dataToBase64StrWithLength:(NSUInteger)length;

- (NSString *)dataToHexStr;
@end