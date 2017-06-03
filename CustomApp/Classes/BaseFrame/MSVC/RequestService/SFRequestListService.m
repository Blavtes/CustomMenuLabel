//
//  SFRequestListService.m
//  HX_GJS
//
//  Created by gjfax on 16/5/20.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRequestListService.h"

@implementation SFRequestListService

- (void)setDataRequestType:(RequestDataType)dataRequestType
{
    _dataRequestType = dataRequestType ? dataRequestType : RequestDataTypeDefault;
    
    //  每进入一次，都更新一次 入参
    [self.dataParams setObjectJudgeNil:FMT_STR(@"%lu", (unsigned long)[self currentPage])
                                forKey:@"pageNum"];
    [self.dataParams setObjectJudgeNil:FMT_STR(@"%lu", (unsigned long)[self pageSize])
                                forKey:@"pageSize"];
}

- (NSUInteger)pageSize
{
    return 20;
}

- (NSUInteger)currentPage
{
    if (_currentPage <= 0 || self.dataRequestType != RequestDataTypeLoadMore) {
        _currentPage = 1;
    }
    
    return _currentPage;
}

/**
 *  是否开启 总条数 控制请求,默认不开启 NO
 */
- (BOOL)openRequestTotalControl
{
    return NO;
}


- (NSMutableArray *)resultListArray
{
    if (!_resultListArray) {
        _resultListArray = [NSMutableArray array];
    }
    return _resultListArray;
}



- (void)startRequest
{
    //  控制请求
    if ([self openRequestTotalControl]) {
        if (!self.isStopRequest || self.dataRequestType != RequestDataTypeLoadMore) {
            [super startRequest];
        } else {
            if (self.succeededBlock) {
                self.succeededBlock(self);
            }
        }
    } else {
        [super startRequest];

    }
    
}


- (void)succeed:(id)response
{
    //  只要成功了就加一
    _currentPage ++;
    
    //  回调结果前的方法，判断是否需要 停止后续请求
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *body = [NSDictionary dictionaryWithDictionary:response];
        NSString *pageNum = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"]
                                            objectForKeyForSafetyValue:@"pageNum"]);
        NSString *totalPage = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"]
                                              objectForKeyForSafetyValue:@"totalPage"]);
        if ([pageNum isEqualToString:totalPage]) {
            self.isStopRequest = YES;
        } else {
            self.isStopRequest = NO;
        }
    }
    
    [super succeed:response];
}

- (void)errored:(SFRequestError *)error
{
    //  错误时，重新减回去
    if (self.dataRequestType == RequestDataTypeLoadMore) {
        _currentPage --;
    }
    [super errored:error];
}


- (void)failed:(NSError *)error
{
    //  错误时，重新减回去
    if (self.dataRequestType == RequestDataTypeLoadMore) {
        _currentPage --;
    }
    [super failed:error];
}

@end
