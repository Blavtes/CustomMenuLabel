//
//  BuglyTool.m
//  GjFax
//
//  Created by Blavtes on 2017/3/15.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "BuglyTool.h"


#pragma mark ---
#pragma mark ---- bugly define ----

//bugly无网络key
#define kBuglyNoNetWork(url)   [NSString stringWithFormat:@"NoNetWork_TimeOut_%@_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain],(url)]
//bugly 数据解析错误，api获取数据异常
#define kBuglyParseAPIError(url) [NSString stringWithFormat:@"APIParseError_%@_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain],(url)]

//bugly 数据解析异常，api 获取数据不为success etc.
#define kBuglyGetDataNOSuccess(url) [NSString stringWithFormat:@"GetDataNOSuccess_%@_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain],(url)]

//bugly 控制器push 异常
#define kBuglyVCPushException [NSString stringWithFormat:@"VCPushException_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain]]
// bugly 控制器pop 异常
#define kBuglyVCPopException [NSString stringWithFormat:@"VCPopException_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain]]

// bugly 控制器popRoot 异常
#define kBuglyVCPopRootException [NSString stringWithFormat:@"VCPopRootException_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain]]

// bugly 控制器selector 异常
#define kBuglySelectorException [NSString stringWithFormat:@"SelectorException_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain]]

// bugly 控制器selector 异常
#define kBuglySafetyException [NSString stringWithFormat:@"SafetyException_%@_%@",[CommonMethod appVersion],[CommonMethod UUIDWithKeyChain]]

#pragma mark ----------- bugly --------
#ifdef DEBUG
#define BUGLY_APP_ID @""
#else
#define BUGLY_APP_ID @""
#endif

@implementation BuglyTool

+ (void)setupBuglyConfig
{
    [[[BuglyTool alloc] init] setupBuglyConfig];
}

- (void)setupBuglyConfig {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = YES;
    config.viewControllerTrackingEnable = NO;
    config.deviceIdentifier = [CommonMethod UUIDWithKeyChain];
    //开启崩溃上传日志
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"%@", [CommonMethod UUIDWithKeyChain]]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
}

#pragma mark - BuglyDelegate
//- (NSString *)attachmentForException:(NSException *)exception {
//    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
//    
//    return @"This is an attachment";
//}

#pragma mark - Bugly代理 - 捕获异常,回调(@return 返回需上报记录，随 异常上报一起上报)
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);

#ifdef DEBUG // 调试
    return [NSString stringWithFormat:@"[logInfo]:%@",[self redirectNSLogToDocumentFolder]];
#endif
    
    return @"This is an attachment";
}

#pragma mark - 保存日志文件
- (NSString *)redirectNSLogToDocumentFolder{
    //如果已经连接Xcode调试则不输出到文件
//    if(isatty(STDOUT_FILENO)) {
//        return nil;
//    }

//    UIDevice *device = [UIDevice currentDevice];
//    if([[device model] hasSuffix:@"Simulator"]){
//        //在模拟器不保存到文件中
//        return nil;
//    }

    //获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
    // freopen 重定向输出输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    return [[NSString alloc] initWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    
}

+ (void)reportGetDataNoSuccessResponse:(id)response url:(NSString *)apiUrl
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:response];
    NSString *statusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"]
                                          objectForKeyForSafetyValue:@"status"]);
    
    if (![[statusStr lowercaseString] isEqualToString:kInterfaceRetStatusSuccess]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BLYLogWarn(@"GetResponseDataNoSuccess %@",apiUrl);
            [Bugly reportError:[NSError errorWithDomain:kBuglyGetDataNOSuccess(apiUrl) code:kBuglyGetDataNoSuccessCode userInfo:@{@"URL":apiUrl,@"returnValue":response}]];
            // 返回的状态值  失败为NO
        });
    }
}

#pragma mark waring----是否需要过滤api ----

+ (void)reportParseAPIError:(NSError *)error url:(NSString *)strUrl;
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Report caught an NSException object
        BLYLogWarn(@"ParseAPIError %@",strUrl);
        [Bugly reportError:[NSError errorWithDomain:kBuglyParseAPIError(strUrl) code:kBuglyParseAPItErrorCode userInfo:@{@"URL":strUrl,@"error":error}]];
    });
}

+ (void)reportTimeOutUrl:(NSString *)strUrl
{
    //  无网络提示
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BLYLogWarn(@"TimeOut error %@",strUrl);//该记录随上传一起记录
//        [Bugly reportError:[NSError errorWithDomain:kBuglyNoNetWork(strUrl) code:kBuglyTimeOutErrorCode userInfo:@{@"URL":strUrl}]];
    });
}

+ (void)reportVCPushException:(UIViewController *)viewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BLYLogWarn(@"VCPushException %@",NSStringFromClass([viewController class]));
        [Bugly reportException:[NSException exceptionWithName:kBuglyVCPushException reason:kBuglyVCPushExceptionCode userInfo:@{@"goalVC":NSStringFromClass([viewController class])}]];
    });
}

+ (void)reportVCPopException:(UINavigationController *)nav
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BLYLogWarn(@"VCPopException %@",NSStringFromClass([[nav.viewControllers firstObject] class]));
        [Bugly reportException:[NSException exceptionWithName:kBuglyVCPopException reason:kBuglyVCPopExceptionCode userInfo:@{@"goalVC":NSStringFromClass([[nav.viewControllers firstObject] class])}]];
    });
}

+ (void)reportVCPopRootException:(UINavigationController *)nav
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BLYLogWarn(@"VCPopRootException %@",NSStringFromClass([[nav.viewControllers firstObject] class]));
        [Bugly reportException:[NSException exceptionWithName:kBuglyVCPopRootException reason:kBuglyVCPopRootExceptionCode userInfo:@{@"goalVC":NSStringFromClass([[nav.viewControllers firstObject] class])}]];
    });
}

+ (void)reportSelectorException:(NSArray *)msg
{
    BLYLogWarn(@"%@",msg);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Bugly reportException:[NSException exceptionWithName:kBuglySelectorException reason:kBuglySelectorExceptionCode userInfo:@{@"Selector":msg}]];
    });

}

+ (void)reportSafetyException:(NSString *)msg
{
    BLYLogWarn(msg);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Bugly reportException:[NSException exceptionWithName:kBuglySafetyException reason:kBuglySafetyExceptionCode userInfo:@{@"SafetyException":msg}]];
    });
}
@end
