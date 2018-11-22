//
//  ProductNavigationModel.m
//  GjFax
//
//  Created by litao on 2016/11/6.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "ProductNavigationModel.h"

#import "NormalProductModel.h"
//#import "CurrentProductModel.h"
#import "TransferProductModel.h"
//#import "BusinessTypeModel.h"
//#import "InsuranceDetailModel.h"
//#import "YMFundProductListModel.h"
//#import "HomeBannerViewModel.h"

@implementation ProductNavigationModel

- (instancetype)initWithDic:(NSDictionary *)dataDic
{
    self = [super initWithDic:dataDic];
    
    if (self) {
        self.fixedTotalNum = [[dataDic objectForKeyForSafetyValue:@"fixedTotalNum"] integerValue];
        self.currentTotalNum = [[dataDic objectForKeyForSafetyValue:@"currentTotalNum"] integerValue];
        self.fundTotalNum = 0;
        self.insuranceTotalNum = 0;
        self.transferTotalNum = [[dataDic objectForKeyForSafetyValue:@"transferTotalNum"] integerValue];
        self.businessTotalNum = [[dataDic objectForKeyForSafetyValue:@"businessTotalNum"] integerValue];
        
#pragma mark - - 产品模型数组解析
        
//        NSArray *resultFixedArray = [dataDic objectForKeyForSafetyArray:@"fixedProList"];
//        NSArray *resultCurrentArray = [dataDic objectForKeyForSafetyArray:@"currentProList"];
//        NSArray *resultFundArray = [dataDic objectForKeyForSafetyArray:@"fundProList"];
//        NSArray *resultInsuranceArray = [dataDic objectForKeyForSafetyArray:@"insuranceProList"];
        NSArray *resultTransferArray = [dataDic objectForKeyForSafetyArray:@"transferProList"];
//        NSArray *resultBusinessArray = [dataDic objectForKeyForSafetyArray:@"businessProList"];
       
//        self.fixedNaviArray = [NormalProductModel modelArrayWithArray:resultFixedArray];
//        self.currentNaviArray = [CurrentProductModel modelArrayWithArray:resultCurrentArray];
//        NSMutableArray *modelArrayfundNaviArray = [NSMutableArray array];
//        for (NSDictionary *dataDic in resultFundArray) {
//            YMFundProductListModel *model = [[YMFundProductListModel alloc] initWithDic:dataDic];
//            [modelArrayfundNaviArray addObject:model];
//        }
//        self.fundNaviArray = @[];//[YMFundProductListModel modelArrayWithArray:resultFundArray];
//        self.insuranceNaviArray = @[];
        self.transferNaviArray = [TransferProductModel modelArrayWithArray:resultTransferArray];
//        self.businessNaviArray = [BusinessTypeModel modelArrayWithArray:resultBusinessArray];
//        if ([[HomeBannerViewModel sharedInstance] isHiddenProductSetting]) {
//            [self checkoutFixedArray];
//        }
    }
    
    return self;
}

- (void)checkoutFixedArray
{
    DLog(@"checkoutFixedArray ");
//    self.fixedNaviArray = [NormalProductListModel test].list;
}

+ (instancetype)modelWithDic:(NSDictionary *)dataDic
{
    return [[self alloc] initWithDic:dataDic];
}

#pragma mark - LazyLoad array
//- (NSArray *)fixedNaviArray
//{
//    if (_fixedNaviArray) {
//        return _fixedNaviArray;
//    }
//
//    _fixedNaviArray = [NSMutableArray array];
//
//    return _fixedNaviArray;
//}

//- (NSArray *)currentNaviArray
//{
//    if (_currentNaviArray) {
//        return _currentNaviArray;
//    }
//
//    _currentNaviArray = [NSMutableArray array];
//
//    return _currentNaviArray;
//}
//
//- (NSArray *)fundNaviArray
//{
//    if (_fundNaviArray) {
//        return _fundNaviArray;
//    }
//
//    _fundNaviArray = [NSMutableArray array];
//
//    return _fundNaviArray;
//}
//
//- (NSArray *)insuranceNaviArray
//{
//    if (_insuranceNaviArray) {
//        return _insuranceNaviArray;
//    }
//
//    _insuranceNaviArray = [NSMutableArray array];
//
//    return _insuranceNaviArray;
//}

- (NSArray *)transferNaviArray
{
    if (_transferNaviArray) {
        return _transferNaviArray;
    }
    
    _transferNaviArray = [NSMutableArray array];
    
    return _transferNaviArray;
}

//- (NSArray *)businessNaviArray
//{
//    if (_businessNaviArray) {
//        return _businessNaviArray;
//    }
//
//    _businessNaviArray = [NSMutableArray array];
//
//    return _businessNaviArray;
//}
@end
