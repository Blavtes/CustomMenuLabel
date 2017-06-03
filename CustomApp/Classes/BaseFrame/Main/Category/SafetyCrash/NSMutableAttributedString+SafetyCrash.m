//
//  NSMutableAttributedString+SafetyCrash.m
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/15.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSMutableAttributedString+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSMutableAttributedString (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteMutableAttributedString = NSClassFromString(@"NSConcreteMutableAttributedString");
        
        //initWithString:
        [SafetyCrash exchangeInstanceMethod:NSConcreteMutableAttributedString method1Sel:@selector(initWithString:) method2Sel:@selector(safetyCrashInitWithString:)];
        
        //initWithString:attributes:
        [SafetyCrash exchangeInstanceMethod:NSConcreteMutableAttributedString method1Sel:@selector(initWithString:attributes:) method2Sel:@selector(safetyCrashInitWithString:attributes:)];
    });
}

//=================================================================
//                          initWithString:
//=================================================================
#pragma mark - initWithString:

- (instancetype)safetyCrashInitWithString:(NSString *)str
{
    id object = nil;
    @try {
        object = [self safetyCrashInitWithString:str];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//=================================================================
//                     initWithString:attributes:
//=================================================================
#pragma mark - initWithString:attributes:

- (instancetype)safetyCrashInitWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
{
    id object = nil;
    
    @try {
        object = [self safetyCrashInitWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

@end
