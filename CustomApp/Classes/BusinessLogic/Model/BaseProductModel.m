//
//  BaseProductModel.m
//  HX_GJS
//
//  Created by litao on 16/1/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseProductModel.h"

@implementation BaseProductModel

#pragma mark - getter - setter
- (NSString *)productTermType
{
    if ([FMT_STR(@"%@", _productTermType) isEqualToString:@"0"]) {
        _productTermType = @"年";
    } else if ([FMT_STR(@"%@", _productTermType) isEqualToString:@"1"]) {
        _productTermType = @"月";
    } else if ([FMT_STR(@"%@", _productTermType) isEqualToString:@"2"]) {
        _productTermType = @"天";
    } else {
        _productTermType = @"天";
    }
    
    return _productTermType;
}

#pragma mark - 产品特性图标 - 广金币等
- (NSArray *)configProductFlagImgArray:(NSArray *)flagTypeArray
{
    NSMutableArray *imgArray = [NSMutableArray array];
    
    if (flagTypeArray) {
        
        [flagTypeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *flagImg = [[UIImage alloc] init];
            
            flagImg = [self getImgWithFlagType:(ProductFlagType)[obj integerValue]];
            
            if (flagImg) {
                [imgArray addObject:flagImg];
            }
            
        }];
    }
    
    return imgArray;
}

- (UIImage *)getImgWithFlagType:(ProductFlagType)type
{
    UIImage *retFlagImg = [[UIImage alloc] init];
    
    switch (type) {
        case ProductFlagTypeCoin:
        {
            retFlagImg = [UIImage imageNamed:@"product_flag_coin"];
        }
            break;
            
        case ProductFlagTypeTicket:
        {
            retFlagImg = [UIImage imageNamed:@"product_flag_ticketNew"];
        }
            break;
            
        default:
        {
            retFlagImg = nil;
        }
            break;
    }
    
    return retFlagImg;
}

#pragma mark - 可转让标签图标
- (NSArray *)configCanTransferImgArray:(NSArray *)canTransferArray {
    NSMutableArray *imgArray = [NSMutableArray array];
    
    if (canTransferArray) {
        
        [canTransferArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *canTransferImg = [[UIImage alloc] init];
            
            canTransferImg = [self getImgWithCanTransfer];
            
            if (canTransferImg) {
                [imgArray addObject:canTransferImg];
            }
            
        }];
    }
    
    return imgArray;
}

- (UIImage *)getImgWithCanTransfer
{
    UIImage *retCanTransferImg = [[UIImage alloc] init];
    
    retCanTransferImg = [UIImage imageNamed:@"product_flag_canTransferNew"];
    
    return retCanTransferImg;
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseProductModel *obj = [[[self class] allocWithZone:zone] init];
    obj.productName = self.productName;
    obj.productRiskLv = self.productRiskLv;
    obj.productStatus = self.productStatus;
    obj.productBalance = self.productBalance;
    obj.productDueDate = self.productDueDate;
    obj.productProgress = self.productProgress;
    obj.productTermType = self.productTermType;
    obj.productIssueDate = self.productIssueDate;
    obj.productStockCode = self.productStockCode;
    obj.productStockName = self.productStockName;
    obj.productStortName = self.productStortName;
    obj.productCompanyType = self.productCompanyType;
    obj.productIncomeType = self.productIncomeType;
    obj.productRateRangeStr = self.productRateRangeStr;
    obj.productTermRangeStr = self.productTermRangeStr;
    obj.productCommissionNum = self.productCommissionNum;
    obj.productIssuePrice = self.productIssuePrice;
    obj.productAnnualRate = self.productAnnualRate;
    obj.productStartDate = self.productStartDate;
    obj.productStockTypeName = self.productStockTypeName;
    obj.productTradingStatus = self.productTradingStatus;
    obj.productInvestmentLowerLimit = self.productInvestmentLowerLimit;
    obj.productCapitalization = self.productCapitalization;
    obj.productInvestmentTerm = self.productInvestmentTerm;
    obj.productTenThousIncome = self.productTenThousIncome;
    obj.interestTypeDesc = self.interestTypeDesc;
    obj.disclaimer = self.disclaimer;
    return obj;
}
@end
