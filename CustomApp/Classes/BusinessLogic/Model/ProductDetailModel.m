//
//  ProductDetailModel.m
//  HX_GJS
//
//  Created by litao on 16/3/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "ProductDetailModel.h"

@implementation ProductDetailModel

- (instancetype)initWithDic:(id)object
{
    self = [super initWithDic:object];
    if (self) {
        
        //  （预期收益=10000元X该产品预期年化X天数/360）
        //  万份收益 = 利率 * 期限 * 10000元 利率已乘以100 / 360
        double tenThous =  [self.interestRate doubleValue] * 100 * [self.limitTime doubleValue] / 360;
        self.tenThousIncome = FMT_STR(@"%.2f",  tenThous);
        //项目摘要
         _projectSumm = [NSMutableArray arrayWithCapacity:1];
        NSArray *arr = [object objectForKeyForSafetyArray:@"projectSumm"];
        for (NSDictionary *dict in arr) {
            ProjectSummModel *model = [[ProjectSummModel alloc] initWithDic:dict];
            [_projectSumm addObject:model];
        };
        //网贷说明书
        _relatedDesc = [NSMutableArray arrayWithCapacity:1];
        NSArray *array = [object objectForKeyForSafetyArray:@"relatedDesc"];
        for (NSDictionary *dict in array) {
            InstructionBookModel *model = [[InstructionBookModel alloc] initWithDic:dict];
            [_relatedDesc addObject:model];
        };
//        [self test];
    }
    return self;
}
- (void)test {
    self.relatedDesc = [self getTestArray];
}

- (NSMutableArray *)getTestArray {
    NSMutableArray *testArray = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        [testArray addObject:[[InstructionBookModel alloc] initWithDic:nil]];
    };
    return testArray;
}

+ (instancetype)modelWithDic:(NSDictionary *)dataDic
{
    return [[self alloc] initWithDic:dataDic];    
}

@end


@implementation ProjectSummModel
- (instancetype)initWithDic:(id)object
{
    if (self = [super initWithDic:object]) {
        
    }
    return self;
}

@end

@implementation InstructionBookModel
- (instancetype)initWithDic:(id)object
{
    return  [super initWithDic:object] ;
    
//    [self test];
//    return self;
}

- (void)test {
    self.title = @"测试协议和说明书";
    self.fileUrl = @"https://www.baidu.com";
    self.fileType = @"0";
}
@end
