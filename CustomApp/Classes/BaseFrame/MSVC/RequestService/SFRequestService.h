//
//  SFRequestService.h
//  HX_GJS
//
//  Created by gjfax on 16/5/20.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTool.h"
#import "SFBaseModel.h"
#import "SFRequestError.h"

typedef NS_ENUM(NSInteger, HUDShowType) {
    HUDShowTypeHideDefault      =       0,  //默认不使用HUD
    HUDShowTypeShowWithView,                //显示在view上，navi可点击
    HUDShowTypeShowWithWindow,              //显示在window上，屏幕被遮挡
};

/**
 *  网络请求 成功返回后台succeed 结果block
 *  return self
 */
typedef void (^SFSucceededBlock) (id requestService);

/**
 *  网络异常 返回block
 */
typedef void (^SFFailureBlock)();

/**
 *  网络请求 成功返回 后台fail 结果block
 *  return  SFRequestError
 */
typedef void (^SFRequestErrorBlock) (SFRequestError  *SFError);



@interface SFRequestService : HttpTool

/**
 *  网络请求 成功返回后台succeed 结果block
 *  return self
 */
@property (copy, nonatomic) SFSucceededBlock            succeededBlock;

/**
 *  网络异常 返回block
 */
@property (copy, nonatomic) SFFailureBlock              failureBlock;

/**
 *  网络请求 成功返回 后台fail 结果block
 *  return  SFRequestError
 */
@property (copy, nonatomic) SFRequestErrorBlock         errorBlock;

/**
 *  网络请求入参，self.dataParams为补全[self dataParams]，[self dataParams] 优先处理
 */
@property (nonatomic, strong) NSMutableDictionary              *dataParams;

/*
 *  网络请求返回 状态
 */
@property (nonatomic, strong) SFRequestError            *error;



#pragma mark -- 按需继承,不需要的不用重写
/**
 *  设置 接口地址url
 */
- (NSString *)apiUrl;

/**
 *  设置 接口业务入参
 *  若 [self dataParams]被重写，则以[self dataParams]为优先
 *  若 self.dataParams 存在，[self dataParams]不被重写。则 返回self.dataParams
 */
- (NSMutableDictionary *)dataParams;

/**
 *  设置请求头 参数，
 *  默认nil 。设置 即需带请求头
 */
- (NSMutableDictionary *)headerDataParams;

/**
 *  设置HUD Loading 类型，默认不显示
 */
- (HUDShowType)HUDShowType;

#pragma mark - 发送请求
/**
 *  发起请求，默认 执行【self showHUD】 [self postData]
 */
- (void)startRequest;

#pragma mark - 将返回的结果进行统一处理
/*
 *  将返回的数据进行统一解析 并 分离
 *  return YES 返回的结果符合预期，并执行unityConstrucSuccessData：，后调用succeed：
 *         No 返回结果错误，调用 errored：
 */
- (BOOL)unityHandleDataWithResponse:(id)response;

/*
 *  统一解析，构造 成功数据源，需重写，赋值给各自的 数据源【resultArray （model）】
 *  eg: SFRequestListService 中的数据源就是 resultListArray
 */
- (void)unityConstrucSuccessData:(id)resultDic;




#pragma mark -- HUD Method

/**
 *  根据hudShowType 显示HUD
 */
- (void)showHUD;

/**
 *  根据hudShowType 隐藏HUD
 */
- (void)hideHUD;


#pragma mark - Setter

/**
 *  设置 成功、失败、网络异常block
 *  不发送请求
 */
- (void)setWithSuccessBlock:(SFSucceededBlock)successBlock
             withErrorBlock:(SFRequestErrorBlock)errorBlock
           withFailureBlock:(SFFailureBlock)failureBlock;


/**
 *  注册成功block，不会请求，这种写法是为了利用xcode的block补全而已，
 *  跟self.loadSuccessBlock = 意义一样
 */
- (void)setSucceededBlock:(SFSucceededBlock)succeededBlock;

/**
 *  注册异常block，不会请求
 */
- (void)setFailureBlock:(SFFailureBlock)failureBlock;

/**
 *  注册失败block，不会请求
 */
- (void)setErrorBlock:(SFRequestErrorBlock)errorBlock;


#pragma mark --  Service回调
/**
 *  Service回调，默认会触发block回调，不会对数据进行处理
 *
 *  response 为未处理过的数据。
 */
- (void)succeed:(id)response;

/**
 *  Service回调，默认会触发block回调， 结果失败处理
 *
 *  error ＝ self.SFError；
 */
- (void)errored:(SFRequestError *)error;

/**
 *  Service回调，默认会触发block回调，回调不含返回值
 *
 *  response 为未处理过的数据。
 */
- (void)failed:(NSError *)error;


@end
