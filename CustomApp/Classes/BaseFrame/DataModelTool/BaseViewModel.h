//
//  BaseViewModel.h
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreCommonHeader.h"

typedef NS_ENUM(NSInteger, DataRequestType) {
    DataRequestTypeDefault = 0,         //默认
    DataRequestTypeRefresh,             //刷新
    DataRequestTypeLoadMore             //加载更多
};

//  定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode, NSString *errorNote);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

//  新增 缓存回调block
typedef void (^CachesDataBlock)(id cachesData);


@interface BaseViewModel : NSObject

@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) FailureBlock failureBlock;

//  缓存回调block
@property (strong, nonatomic) CachesDataBlock  cachesDataBlock;


@property (assign, nonatomic) DataRequestType dataRequestType;

- (void)setReqBlockWithRetValue:(ReturnValueBlock)returnValueBlock
                 withErrorBlock:(ErrorCodeBlock)errorBlock
               withFailureBlock:(FailureBlock)failureBlock;

// 补全回调
- (void)setCachesDataBlock:(CachesDataBlock)cachesDataBlock;
@end
