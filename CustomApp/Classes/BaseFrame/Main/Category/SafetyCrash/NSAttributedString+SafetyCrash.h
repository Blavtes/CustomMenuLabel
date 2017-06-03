//
//  NSAttributedString+SafetyCrash.h
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/15.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end

/**
 *  Can Safety crash method
 *
 *  1.- (instancetype)initWithString:(NSString *)str
 *  2.- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr
 *  3.- (instancetype)initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
 *
 *
 */
