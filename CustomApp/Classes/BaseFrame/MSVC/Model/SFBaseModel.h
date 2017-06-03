//
//  SFBaseModel.h
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBaseModel : NSObject

/**
 *  初始化，并将object安全对应赋值给model
 */
- (instancetype)initWithDic:(id)object;

/**
 *  model 转 dic,  无值为 null
 *
 *  @return dic
 */
- (NSDictionary *)modelToDic;

/**
 *  将object安全对应赋值给model
 */
- (void)autoSetProperty:(id)object;

/**
 *  返回一个自己的model数组
 */
- (NSMutableArray *)modelArrayWithArray:(NSArray *)dataArray;
@end
