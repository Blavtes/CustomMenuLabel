//
//  JSPatchTool.m
//  GjFax
//
//  Created by yangyong on 16/8/3.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "JSPatchTool.h"
#import <JSPatchPlatform/JSPatch.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static NSInteger const kJSOffSetTime = 3600; //请求间隔限制
static NSString *const kJSPatchRequestLastTime = @"JSPatchRequestLastTime"; // 尝试制造启动 crash

@implementation JSPatchTool

+ (void)startJSPatch
{
//        // 记录启动时刻，用于限制请求次数
//    NSInteger lastTime =  [JSPatchTool getRequestLastTime];
//    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a = [dat timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//    
//    if ((lastTime != 0 && [timeString integerValue] - lastTime > kJSOffSetTime)
//        || lastTime == 0) {
//        DLog(@" last time %ld %ld %ld",lastTime,(long)[timeString integerValue],(long)[timeString integerValue] - lastTime);
//        [JSPatchTool setRequestLastTime:[timeString integerValue]];
//        
//    } else {
//         DLog(@" not update js === last time %ld %ld %ld",lastTime,(long)[timeString integerValue],(long)[timeString integerValue] - lastTime);
//    }
    [JSPatchTool JSUpdate];
}

+ (void)setRequestLastTime:(NSInteger)requestLastTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:requestLastTime forKey:kJSPatchRequestLastTime];
    [defaults synchronize];
}

+ (NSInteger)getRequestLastTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kJSPatchRequestLastTime];
}

+ (void)JSUpdate
{
    [JSPatch setupLogger:^(NSString *note) {
        DLog(@"js %@",note);
    }];
    
    
    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        
        [JSPatchTool dataCollection:type data:data error:error];
    }];
    
    [JSPatch startWithAppKey:JSPatchAppKey];
    [JSPatch setupRSAPublicKey:JSPatchAppPublickKey];
        //    [JSPatch setupUserData:[NSDictionary dictionaryWithObjectsAndKeys:@"test",@"loadType", nil]];
#ifdef DEBUG
        //测试模式下使用
    [JSPatch setupDevelopment];
#endif
//    [JSPatch testScriptInBundle];
    [JSPatch sync];
    
   
}

+ (void)cleanerAllJSPatch
{
    [JSCleaner cleanAll];
}

//脚本执行状态收集

+ (void)dataCollection:(JPCallbackType) type data:(NSDictionary *)data error:(NSError *)error
{
    NSString *srcClassName = @"JSPatchTool";
    NSString *curClassName = @"JS_Defalut";
    switch (type) {
        case JPCallbackTypeRunScript: {
            DLog(@"js run script %@", error);
            curClassName = @"JS_RunScriptSuccess";
            break;
        }
        case JPCallbackTypeUpdate: {
            DLog(@"updated %@", error);
            curClassName = @"JS_JSHaveUpdate";
            break;
        }
        case  JPCallbackTypeUpdateDone: {
            DLog(@"download script %@",error);
            curClassName = @"JS_DownSuccess";
            break;
        }
        case JPCallbackTypeCondition: {
            DLog(@"condition script %@",error);
            curClassName = @"JS_Condition";
            break;
        }
        case  JPCallbackTypeGray: {
            DLog(@"gray script %@",error);
            curClassName = @"JS_Gray";
            break;
        }
        case JPCallbackTypeUpdateFail: {
            DLog(@"UpdateFail script %@",error);
            curClassName = @"JS_UpdateFail";
            break;
        }
        case JPCallbackTypeException:{
            DLog(@"config Exception  %@",error);
            curClassName = @"JS_ConfigException";
            break;
        }
        case JPCallbackTypeJSException:{
            DLog(@"JSException  %@",error);
            curClassName = @"JS_JSRunException";
            break;
        }
        default:
            break;
    }
}

@end

@implementation JSCleaner
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)cleanAll
{
    [self cleanClass:nil];
    [[self includedScriptPaths] removeAllObjects];
}

+ (void)cleanClass:(NSString *)className
{
    NSDictionary *methodsDict = [JPExtension overideMethods];
    for (Class cls in methodsDict.allKeys) {
        if (className && ![className isEqualToString:NSStringFromClass(cls)]) {
            continue;
        }
        for (NSString *jpSelectorName in [methodsDict[cls] allKeys]) {
            NSString *selectorName = [jpSelectorName substringFromIndex:3];
            NSString *originalSelectorName = [NSString stringWithFormat:@"ORIG%@", selectorName];
            
            SEL selector = NSSelectorFromString(selectorName);
            SEL originalSelector = NSSelectorFromString(originalSelectorName);
            IMP originalImp = class_respondsToSelector(cls, originalSelector) ? class_getMethodImplementation(cls, originalSelector) : NULL;
            
            Method method = class_getInstanceMethod(cls, originalSelector);
            char *typeDescription = (char *)method_getTypeEncoding(method);
            
            class_replaceMethod(cls, selector, originalImp, typeDescription);
        }
        
        char *typeDescription = (char *)method_getTypeEncoding(class_getInstanceMethod(cls, @selector(forwardInvocation:)));
        IMP forwardInvocationIMP = class_getMethodImplementation(cls, @selector(ORIGforwardInvocation:));
        class_replaceMethod(cls, @selector(forwardInvocation:), forwardInvocationIMP, typeDescription);
    }
}

#pragma clang diagnostic pop
@end

