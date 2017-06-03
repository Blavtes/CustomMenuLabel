//
//  SFRequestListService.h
//  HX_GJS
//
//  Created by gjfax on 16/5/20.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestService.h"

typedef NS_ENUM(NSInteger, RequestDataType) {
    RequestDataTypeDefault = 0,         //默认
    RequestDataTypeRefresh,             //刷新
    RequestDataTypeLoadMore             //加载更多
};

@interface SFRequestListService : SFRequestService


@property (assign, nonatomic) RequestDataType           dataRequestType;

/**
 *  当前页数
 */
@property (nonatomic, assign) NSUInteger                currentPage;

/**
 *  数据源，请求完成处理后必须 赋值给resultListArray
 */
@property (nonatomic, strong) NSMutableArray            *resultListArray;

/**
 *  当isOpenRequestControl 为YES时，isStopRequest 是否停止请求 YES 停止请求 NO 不停止
 */
@property (nonatomic, assign) BOOL           isStopRequest;

/**
 *  每页多少条数据，默认20
 */
- (NSUInteger)pageSize;

/**
 *  是否开启 总条数 控制请求,默认不开启 NO
 */
- (BOOL)openRequestTotalControl;
@end
