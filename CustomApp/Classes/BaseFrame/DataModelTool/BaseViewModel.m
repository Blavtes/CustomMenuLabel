//
//  BaseViewModel.m
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)setReqBlockWithRetValue:(ReturnValueBlock)returnValueBlock
                 withErrorBlock:(ErrorCodeBlock)errorBlock
               withFailureBlock:(FailureBlock)failureBlock
{
    _returnBlock = returnValueBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

- (void)setDataRequestType:(DataRequestType)dataRequestType
{
    _dataRequestType = dataRequestType ? dataRequestType : DataRequestTypeDefault;
}


- (void)setCachesDataBlock:(CachesDataBlock)cachesDataBlock
{
    _cachesDataBlock = cachesDataBlock;
}
@end
