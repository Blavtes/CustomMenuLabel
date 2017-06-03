//
//  NSMutableString+SafetyCrash.m
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/6.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSMutableString+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSMutableString (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class stringClass = NSClassFromString(@"__NSCFString");
        
        //replaceCharactersInRange
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(replaceCharactersInRange:withString:) method2Sel:@selector(safetyCrashReplaceCharactersInRange:withString:)];
        
        //insertString:atIndex:
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(insertString:atIndex:) method2Sel:@selector(safetyCrashInsertString:atIndex:)];
        
        //deleteCharactersInRange
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(deleteCharactersInRange:) method2Sel:@selector(safetyCrashDeleteCharactersInRange:)];
    });
}

//=================================================================
//                     replaceCharactersInRange
//=================================================================
#pragma mark - replaceCharactersInRange

- (void)safetyCrashReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    
    @try {
        [self safetyCrashReplaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                     insertString:atIndex:
//=================================================================
#pragma mark - insertString:atIndex:

- (void)safetyCrashInsertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    
    @try {
        [self safetyCrashInsertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                   deleteCharactersInRange
//=================================================================
#pragma mark - deleteCharactersInRange

- (void)safetyCrashDeleteCharactersInRange:(NSRange)range
{
    
    @try {
        [self safetyCrashDeleteCharactersInRange:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

@end
