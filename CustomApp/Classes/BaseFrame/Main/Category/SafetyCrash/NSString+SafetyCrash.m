//
//  NSString+SafetyCrash.m
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/5.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSString+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSString (safetyCrash)

+ (void)safetyCrashExchangeMethod {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class stringClass = NSClassFromString(@"__NSCFConstantString");
        
        //characterAtIndex
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(characterAtIndex:) method2Sel:@selector(safetyCrashCharacterAtIndex:)];
        
        //substringFromIndex
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(substringFromIndex:) method2Sel:@selector(safetyCrashSubstringFromIndex:)];
        
        //substringToIndex
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(substringToIndex:) method2Sel:@selector(safetyCrashSubstringToIndex:)];
        
        //substringWithRange:
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(substringWithRange:) method2Sel:@selector(safetyCrashSubstringWithRange:)];
        
        //stringByReplacingOccurrencesOfString:
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(stringByReplacingOccurrencesOfString:withString:) method2Sel:@selector(safetyCrashStringByReplacingOccurrencesOfString:withString:)];
        
        //stringByReplacingOccurrencesOfString:withString:options:range:
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) method2Sel:@selector(safetyCrashStringByReplacingOccurrencesOfString:withString:options:range:)];
        
        //stringByReplacingCharactersInRange:withString:
        [SafetyCrash exchangeInstanceMethod:stringClass method1Sel:@selector(stringByReplacingCharactersInRange:withString:) method2Sel:@selector(safetyCrashStringByReplacingCharactersInRange:withString:)];
    });
    
}

//=================================================================
//                           characterAtIndex:
//=================================================================
#pragma mark - characterAtIndex:

- (unichar)safetyCrashCharacterAtIndex:(NSUInteger)index
{
    unichar characteristic;
    @try {
        characteristic = [self safetyCrashCharacterAtIndex:index];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to return a without assign unichar.";
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return characteristic;
    }
}

//=================================================================
//                           substringFromIndex:
//=================================================================
#pragma mark - substringFromIndex:

- (NSString *)safetyCrashSubstringFromIndex:(NSUInteger)from
{
    NSString *subString = nil;
    
    @try {
        subString = [self safetyCrashSubstringFromIndex:from];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

//=================================================================
//                           substringToIndex
//=================================================================
#pragma mark - substringToIndex

- (NSString *)safetyCrashSubstringToIndex:(NSUInteger)to
{
    NSString *subString = nil;
    
    @try {
        subString = [self safetyCrashSubstringToIndex:to];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

//=================================================================
//                           substringWithRange:
//=================================================================
#pragma mark - substringWithRange:

- (NSString *)safetyCrashSubstringWithRange:(NSRange)range
{
    NSString *subString = nil;
    
    @try {
        subString = [self safetyCrashSubstringWithRange:range];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        subString = nil;
    } @finally {
        return subString;
    }
}

//=================================================================
//                stringByReplacingOccurrencesOfString:
//=================================================================
#pragma mark - stringByReplacingOccurrencesOfString:

- (NSString *)safetyCrashStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self safetyCrashStringByReplacingOccurrencesOfString:target withString:replacement];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

//=================================================================
//  stringByReplacingOccurrencesOfString:withString:options:range:
//=================================================================
#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:

- (NSString *)safetyCrashStringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self safetyCrashStringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

//=================================================================
//       stringByReplacingCharactersInRange:withString:
//=================================================================
#pragma mark - stringByReplacingCharactersInRange:withString:

- (NSString *)safetyCrashStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    NSString *newStr = nil;
    
    @try {
        newStr = [self safetyCrashStringByReplacingCharactersInRange:range withString:replacement];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        newStr = nil;
    } @finally {
        return newStr;
    }
}

@end
