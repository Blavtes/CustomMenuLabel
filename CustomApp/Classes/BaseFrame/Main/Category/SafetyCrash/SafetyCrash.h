//
//  safetyCrash.h
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//category
#import "NSObject+SafetyCrash.h"

#import "NSArray+SafetyCrash.h"
#import "NSMutableArray+SafetyCrash.h"

#import "NSDictionary+SafetyCrash.h"
#import "NSMutableDictionary+SafetyCrash.h"

#import "NSString+SafetyCrash.h"
#import "NSMutableString+SafetyCrash.h"

#import "NSAttributedString+SafetyCrash.h"
#import "NSMutableAttributedString+SafetyCrash.h"


/**
 *  if you want to get the reason that can cause crash, you can add observer notification in AppDelegate.
 *  for example: 
 *
 *  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:SafetyCrashNotification object:nil];
 *  
 *  ===========================================================================
 *  
 *  你如果想要得到导致崩溃的原因，你可以在AppDelegate中监听通知，代码如上。
 *  不管你在哪个线程导致的crash,监听通知的方法都会在主线程中
 *
 */
#define SafetyCrashNotification @"SafetyCrashNotification"



//user can ignore below define
#define SafetyCrashDefaultReturnNil  @"This framework default is to return nil to Safety crash."
#define SafetyCrashDefaultIgnore     @"This framework default is to ignore this operation to Safety crash."


#ifdef DEBUG

#define  SafetyCrashLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])

#else

#define SafetyCrashLog(...)
#endif


@interface SafetyCrash : NSObject


/**
 *  become effective . You can call becomeEffective method in AppDelegate didFinishLaunchingWithOptions
 *  
 *  开始生效.你可以在AppDelegate的didFinishLaunchingWithOptions方法中调用becomeEffective方法
 *
 *  这是全局生效，若你只需要部分生效，你可以单个进行处理，比如:
 *  [NSArray safetyCrashExchangeMethod];
 *  [NSMutableArray safetyCrashExchangeMethod];
 *  .................
 *  .................
 */

//user can ignore below method <用户可以忽略以下方法>


+ (void)exchangeClassMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel;

+ (void)exchangeInstanceMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel;

//异常信息收集
+ (void)noteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo;

//收集Selector 错误信息
+ (void)noteErrorExceptionSelectorCallStackMsg;

@end
