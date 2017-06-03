//
//  SFBaseModel.m
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFBaseModel.h"

@implementation SFBaseModel


- (instancetype)initWithDic:(id)object
{
    self = [super init];
    if (self) {
        [self autoSetProperty:object];
    }
    return self;
}

/**
 *  model 转 dic,  无值为 null
 *
 *  @return dic
 */
- (NSDictionary *)modelToDic
{
    NSDictionary *dataDic = [self GJSAllPropertiestAndValues];
    return dataDic;
}

/**
 *  将object安全对应赋值给model
 */
- (void)autoSetProperty:(id)object
{
    [self GJSAutoSetPropertySafety:object];
}


/**
 *  返回一个自己的model数组
 */
- (NSMutableArray *)modelArrayWithArray:(NSArray *)dataArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (dataArray && [dataArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in dataArray) {
            
            [resultArray addObject:[[[self class] alloc] initWithDic:dic]];
            
        }
    }
    
    return resultArray;
}
@end
