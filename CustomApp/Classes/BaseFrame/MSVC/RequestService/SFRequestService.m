//
//  SFRequestService.m
//  HX_GJS
//
//  Created by gjfax on 16/5/20.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestService.h"

@implementation SFRequestService

#pragma mark - 可继承

/**
 *  请求接口url
 */
- (NSString *)apiUrl
{
    return nil;
}

/**
 *  请求 入参
 */
- (NSMutableDictionary *)dataParams
{
    if (_dataParams) {
        return _dataParams;
    }
    return nil;
}

/**
 *  请求头 参数，默认nil 。存在 即需带请求头
 */
- (NSMutableDictionary *)headerDataParams
{
    return nil;
}

/**
 *  HUD 类型，默认不显示HUD
 */
- (HUDShowType)HUDShowType
{
    return HUDShowTypeHideDefault;
}

#pragma mark -- Setter block  && Getter

/**
 *  设置 成功、失败、网络异常block
 *
 */
- (void)setWithSuccessBlock:(SFSucceededBlock)successBlock
             withErrorBlock:(SFRequestErrorBlock)errorBlock
           withFailureBlock:(SFFailureBlock)failureBlock
{
    _succeededBlock = successBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
    
}

/**
 *  注册成功block，不会请求，这种写法是为了利用xcode的block补全而已，
 跟self.loadSuccessBlock = 意义一样
 */
- (void)setSucceededBlock:(SFSucceededBlock)succeededBlock
{
    _succeededBlock = succeededBlock;
}

/**
 *  注册异常block，不会请求
 */
- (void)setFailureBlock:(SFFailureBlock)failureBlock
{
    _failureBlock = failureBlock;
}

/**
 *  注册失败block，不会请求
 */
- (void)setErrorBlock:(SFRequestErrorBlock)errorBlock
{
    _errorBlock = errorBlock;
}

/**
 *  失败error
 */
- (SFRequestError *)error
{
    if (!_error) {
        _error = [SFRequestError new];
    }
    return _error;
}


#pragma mark - request Method

/**
 *  执行请求
 */
- (void)startRequest {
    
    if (![self apiUrl]) {
        DLog(@"你漏写api url了");
        return;
    }
//    DLog(@"apiUrl = %@,dataParams = %@",[self apiUrl],[self dataParams]);
    [self showHUD];

    [self postData];
    
}

/**
 *  post请求
 */
- (void)postData {
    
    [[self class] postUrl:[self apiUrl]
                   params:[self dataParams]
                headerDic:[self headerDataParams]
                  success:^(id responseObject) {
                      
                      [self handleFetchSucceedData:responseObject];
                  } failure:^(NSError *error) {
                      [self failed:error];
                  }];
}


#pragma mark - SFServerDelegate

/**
 *  处理成功返回的数据，并根据constructResultData分离 结果为 正常的（succeed） 还是 失败的（error）
 */
- (void)handleFetchSucceedData:(id)response
{
    BOOL isSucceed = [self unityHandleDataWithResponse:response];
    
    // isSucceed 为NO 时代表返回的结果是失败的,执行error：方法
    if (isSucceed) {
        [self succeed:response];
    }else {
        [self errored:self.error];
    }
}

/**
 *  请求成功
 */
- (void)succeed:(id)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //    DLog(@"\n%@",response);
        //  隐藏hud
        [self hideHUD];
        
        if (_succeededBlock) {
            //  返回的是自身，即各自的RequestService（viewModel）
            //  在constructResultData 理应已处理完成，各自的RequestService 需要有个全局model（resultArray）对象
            _succeededBlock(self);
        }
    });
}

/**
 *  网络异常失败
 */
- (void)failed:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //    DLog(@"error = %@",error);
        //  隐藏hud
        [self hideHUD];
        
        if (_failureBlock) {
            _failureBlock();
        }
    });

}

/**
 *  返回数据结果失败
 */
- (void)errored:(SFRequestError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //  隐藏hud
        [self hideHUD];
        
        if (_errorBlock) {
            _errorBlock(error);
        }
    });

}

#pragma mark -- HUD Method

/**
 *  根据hudShowType 显示HUD
 */
- (void)showHUD
{
    if ([self HUDShowType] == HUDShowTypeShowWithView) {
        
        [HUDTool showHUDOnView];
    }else if ([self HUDShowType] == HUDShowTypeShowWithWindow) {
        
        [HUDTool showHUDOnKeyWindow];
    }else {
        
    }
}

/**
 *  根据hudShowType 隐藏HUD
 */
- (void)hideHUD
{
    if ([self HUDShowType] == HUDShowTypeShowWithView) {
        
        [HUDTool hideHUDOnView];
    }else if ([self HUDShowType] == HUDShowTypeShowWithWindow) {
        
        [HUDTool hideHUDOnKeyWindow];
    }else {
        
    }
}


#pragma mark - 后台返回统一解析
/*
 *  将返回的数据进行统一解析 并 分离
 *  return YES 返回的结果符合预期  No 返回的结果为 error
 */
- (BOOL)unityHandleDataWithResponse:(id)response
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:response];
    NSString *statusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"]
                                          objectForKeyForSafetyValue:@"status"]);
    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"]
                                           objectForKeyForSafetyValue:@"errorCode"]);
    if ([retCodeStr isNullStr]) {
        retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"]
                                     objectForKeyForSafetyValue:@"retCode"]);
    }
    NSString *noteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"]
                                        objectForKeyForSafetyValue:@"note"]);

    // 将返回码和note保存到 self.error  包含成功的返回码
    self.error.errorCode = retCodeStr;
    self.error.errorNote = noteStr;
    
    if ([[statusStr lowercaseString] isEqualToString:kInterfaceRetStatusSuccess]) {
        // 返回的状态值  成功为YES
        self.error.stautsBool = YES;
        // 取出结果字典
        NSDictionary *resultDic = [body objectForKeyForSafetyDictionary:@"result"];
        // 交给unityConstrucSuccessData 构造。真正的由不同接口各自的数据处理的方法
        [self unityConstrucSuccessData:resultDic];
        return YES;
        
    }else {
        // 返回的状态值  失败为NO
        self.error.stautsBool = NO;

        return NO;
    }
}

/*
 *  统一解析，构造 成功数据源，需重写，赋值给各自的 数据源【resultArray （model）】
 *  eg: SFRequestListService 中的数据源就是 resultListArray
 */
- (void)unityConstrucSuccessData:(id)resultDic
{
    //各自的RequestService 需要有个全局数据源【model（resultArray）对象】
}
@end
