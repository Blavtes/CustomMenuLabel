//
//  NSObject+SafetyCrash.m
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/11.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSObject+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSObject (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //setValue:forKey:
        [SafetyCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKey:) method2Sel:@selector(safetyCrashSetValue:forKey:)];
        
        //setValue:forKeyPath:
        [SafetyCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forKeyPath:) method2Sel:@selector(safetyCrashSetValue:forKeyPath:)];
        
        //setValue:forUndefinedKey:
        [SafetyCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValue:forUndefinedKey:) method2Sel:@selector(safetyCrashSetValue:forUndefinedKey:)];
        
        //setValuesForKeysWithDictionary:
        [SafetyCrash exchangeInstanceMethod:[self class] method1Sel:@selector(setValuesForKeysWithDictionary:) method2Sel:@selector(safetyCrashSetValuesForKeysWithDictionary:)];
        
        //forwardingTargetForSelector:
         [SafetyCrash exchangeInstanceMethod:[self class] method1Sel:@selector(forwardingTargetForSelector:) method2Sel:@selector(SafetyforwardingTargetForSelector:)];
    });
}

//=================================================================
//                         setValue:forKey:
//=================================================================
#pragma mark - setValue:forKey:

- (void)safetyCrashSetValue:(id)value forKey:(NSString *)key
{
    @try {
        [self safetyCrashSetValue:value forKey:key];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                     setValue:forKeyPath:
//=================================================================
#pragma mark - setValue:forKeyPath:

- (void)safetyCrashSetValue:(id)value forKeyPath:(NSString *)keyPath
{
    @try {
        [self safetyCrashSetValue:value forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                     setValue:forUndefinedKey:
//=================================================================
#pragma mark - setValue:forUndefinedKey:

- (void)safetyCrashSetValue:(id)value forUndefinedKey:(NSString *)key
{
    @try {
        [self safetyCrashSetValue:value forUndefinedKey:key];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                  setValuesForKeysWithDictionary:
//=================================================================
#pragma mark - setValuesForKeysWithDictionary:

- (void)safetyCrashSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    @try {
        [self safetyCrashSetValuesForKeysWithDictionary:keyedValues];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        
    }
}

//=================================================================
//                  unKnow Selector
//=================================================================

-(id)SafetyforwardingTargetForSelector:(SEL)aSelector
{
    id resut = [self SafetyforwardingTargetForSelector:aSelector];
    
    if (resut == nil) {
       
        const char * className = "SubObjectProxy";
        Class kclass = objc_getClass(className);
        
        /******方案2********/
        if (!kclass)
        {
            Class superClass = NSClassFromString(@"SubObjectProxy");
            kclass = objc_allocateClassPair(superClass, className, 0);
            objc_registerClassPair(kclass);
        }
        
        class_addMethod(kclass, aSelector, (IMP)noFunctionResponse, "v@:");
        
        if ([self filterLogMsg:NSStringFromClass([self class]) selector:NSStringFromSelector(aSelector)]) {
        /*******方案2********/
            
            Method originalMethod = class_getInstanceMethod([self class], @selector(forwardInvocation:));
            Method method = class_getInstanceMethod([NSObject class], @selector(forwardInvocation:));
            if (originalMethod !=  method) {

                return resut;
            }
            BLYLogWarn(@"cmd %@ %@",[self class],NSStringFromSelector(aSelector));
            [SafetyCrash noteErrorExceptionSelectorCallStackMsg];
            return [[kclass alloc] init];
        
        }
    }
    
    return resut;
}

//filter log msg 跳过以 “_” 开头的类 或者方法，
- (BOOL)filterLogMsg:(NSString *)class selector:(NSString *)cmd
{
    if ([class hasPrefix:@"_"] || [cmd hasPrefix:@"_"] ) {
        //filter os function
        return NO;
    } else {//log
        
        return YES;
    }
}

- (BOOL)runFliterCmd
{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        //        if ([name hasPrefix:@"test"])
        DLog(@"name=> %@",name);
        if ([name isEqualToString:@"forwardInvocation"])
        {
            return YES;
        }
        
    }
    return NO;
}


@end

//proxy class
@implementation SubObjectProxy

/********方案2*******
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
     class_addMethod([self class],sel,(IMP)noFunctionResponse,"v@:");
 
     return [super resolveInstanceMethod:sel];
}
 *******方案2*******/

void noFunctionResponse(id self, SEL _cmd)
{
    //piling
}

@end
