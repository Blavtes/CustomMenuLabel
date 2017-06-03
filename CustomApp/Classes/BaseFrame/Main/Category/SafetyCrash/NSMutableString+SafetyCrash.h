//
//  NSMutableString+SafetyCrash.h
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/6.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end


/**
 *  Can Safety crash method
 *
 *  1. 由于NSMutableString是继承于NSString,所以这里和NSString有些同样的方法就不重复写了
 *  2. - (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
 *  3. - (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc
 *  4. - (void)deleteCharactersInRange:(NSRange)range
 *
 */



