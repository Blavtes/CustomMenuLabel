//
//  NormalProductNewModel.m
//  GjFax
//
//  Created by gjfax on 16/10/16.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NormalProductNewModel.h"

@implementation NormalProductNewModel


- (instancetype)initWithDic:(id)object
{
    self = [super initWithDic:object];
    if (self) {
        
        //  （预期收益=10000元X该产品预期年化X天数/360）
        //  万份收益 = 利率 * 期限 * 10000元 利率已乘以100 / 360
        double tenThous =  [self.interestRate doubleValue] * 100 * [self.limitTime doubleValue] / 360;
        self.tenThousIncome = FMT_STR(@"%.2f",  tenThous);
    }
    return self;
}
@end
