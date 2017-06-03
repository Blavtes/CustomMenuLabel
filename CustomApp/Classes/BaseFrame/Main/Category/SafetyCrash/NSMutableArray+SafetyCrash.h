//
//  NSMutableArray+SafetyCrash.h
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end


/**
 *  Can Safety crash method
 *
 *  1. - (id)objectAtIndex:(NSUInteger)index
 *  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  3. - (void)removeObjectAtIndex:(NSUInteger)index
 *  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  5. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 */
