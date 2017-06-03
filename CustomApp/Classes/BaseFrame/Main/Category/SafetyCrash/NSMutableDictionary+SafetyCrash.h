//
//  NSMutableDictionary+SafetyCrash.h
//  safetyCrash
//
//  Created by Blavtes on 16/9/22.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end


/**
 *  Can Safety crash method
 *
 *  1. - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 *  2. - (void)removeObjectForKey:(id)aKey
 *
 */
