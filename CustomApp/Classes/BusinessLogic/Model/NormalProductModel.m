//
//  NormalProductModel.m
//  HX_GJS
//
//  Created by litao on 16/1/11.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NormalProductModel.h"
#import "NormalProductNewModel.h"
#import "ProductDetailModel.h"
#import "SFArchiverFileManager.h"

@implementation NormalProductModel

#pragma mark - 新接口 处理

- (instancetype)initWithDic:(id)object
{
    self = [super init];
    if (self) {
        
        //  新接口向旧接口 转换
        NormalProductNewModel *newModel = [[NormalProductNewModel alloc] initWithDic:object];
        
        //  产品名称
        self.productName = newModel.productName;
        //  产品简称
        self.productStortName = newModel.shortName;
        //  产品唯一标识(普通产品的股权代码,汇宝 A对应产品代码)
        self.productStockCode = newModel.productId;
        //  产品类型(0:普通产品,1:汇宝A)
        self.productCompanyType = newModel.productType;
        //  风险评级
        self.productRiskLv = newModel.riskRating;
        //  [结息日]产品到期日期
        self.productDueDate = newModel.endDate;
        //  产品发行日期[发售日]
        self.productIssueDate = newModel.publishDate;
        //  起息日
        self.productStartDate = newModel.startDate;
        //  剩余可投金额 --> 0 [判断是否售罄]
        self.productBalance = newModel.remainAmount;
        //  产品年化利率
        self.productAnnualRate = newModel.interestRate;
        //  计息方式(1:一次性还本付息方式;2: 按月付息到期还本;3:按月付息(以月利 率计算利息)到期还本;4:按季付息;5: 等额本息)
        self.productIncomeType = newModel.interestType;
        //  产品投资期限
        self.productInvestmentTerm = newModel.limitTime;
        //  最低投资金额
        self.productInvestmentLowerLimit = newModel.minAmount;
        //  是否可使用广金币
        self.useCoin = newModel.userCoin;
        //  是否可使用广金券
        self.useTicket = newModel.useTicket;
        //  是否可转让
        self.canTrasfer = newModel.canTrasfer;
        //  开售剩余时间(毫秒)
        self.countDownNum = [newModel.startInvestTime longLongValue];
        //  产品的投资进度
        self.productProgress = newModel.progress;
        //  万元收益
        self.productTenThousIncome = newModel.tenThousIncome;
        //  期限单位类型 （0：年  1：月  2：日）
        self.productTermType = newModel.limitTimeUnit;
        //  投资期限范围,如:30-365
        self.productTermRangeStr = newModel.limitTimeRange;
        //  利率范围
        self.productRateRangeStr = newModel.interestRateRange;
        //  计息方式描述
        self.interestTypeDesc = newModel.interestTypeDesc;
        
        [self configFlagImgArray];
        
        [self configCanTransferImgArray];
        
        //  最后调用，将数据保存到 详情model中
        [self normalModelSaveToDetailModel];
    }
    return self;
}

- (void)setStartCountDownNum:(long long)times
{
    long long time = times / 1000;
    self.countDownNum = time;
}

+ (instancetype)modelWithDic:(NSDictionary *)dataDic
{
    return [[self alloc] initWithDic:dataDic];
}

+ (NSArray *)modelArrayWithArray:(NSArray *)dataArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dataDic in dataArray) {
        [modelArray addObject:[NormalProductModel modelWithDic:dataDic]];
    }
    
    return modelArray;
}

- (void)configFlagImgArray
{
    NSMutableArray *flagArray = [[NSMutableArray alloc] init];
    if (_useCoin) {
        [flagArray addObject:FMT_STR(@"%ld", (long)ProductFlagTypeCoin)];
    } else if (_useTicket) {
        [flagArray addObject:FMT_STR(@"%ld", (long)ProductFlagTypeTicket)];
    }
    _flagImgArray = [self configProductFlagImgArray:flagArray];
}

- (void)configCanTransferImgArray {
    NSMutableArray *canTransferArray = [[NSMutableArray alloc] init];
    if (_canTrasfer) {
        [canTransferArray addObject:FMT_STR(@"%ld", (long)ProductFlagCanTransfer)];
    }
    _canTransferImgArray = [self configCanTransferImgArray:canTransferArray];
}
#pragma mark - 将model转为 详情model 并保存到本地

- (void)normalModelSaveToDetailModel
{
    if (!self.productStockCode || [self.productStockCode isNullStr]) {
        DLog(@"定期数据 保存到详情model中，id 为空");
    }
    //  因均使用BaseProductModel作父类,大部分参数一致 ， 不一致的单个设置
    ProductDetailModel *detailModel = [[ProductDetailModel alloc] init];
    [detailModel autoSetProperty:[self modelToDic]];
    
    detailModel.interestTypeDesc = self.interestTypeDesc;
    detailModel.startDate = self.productStartDate;
    detailModel.startInvestTime = self.countDownNum;
    
    //  保存数据到本地
//    NSString *fileName = FMT_STR(@"nav%@%@", GJS_ProductDetail, self.productStockCode);
//    [SFArchiverFileManager saveDataWithFileName:fileName dataSource:detailModel];
}

#pragma mark - setter && getter

- (ProductNaviType)getCurProductType
{
    return ProductTypeNormal;
}

- (NSArray *)flagImgArray
{
    if (_flagImgArray) {
        return _flagImgArray;
    }
    
    _flagImgArray = [NSArray array];
    
    return _flagImgArray;
}
- (NSArray *)canTransferImgArray {
    if (_canTransferImgArray) {
        return _canTransferImgArray;
    }
    _canTransferImgArray = [NSArray array];
    
    return _canTransferImgArray;
}

- (id)copyWithZone:(NSZone *)zone
{
    NormalProductModel *obj = [super copyWithZone:zone];
    obj.useCoin = self.useCoin;
    obj.useTicket = self.useTicket;
    obj.canTrasfer = self.canTrasfer;
    obj.countDownNum = self.countDownNum;
    obj.flagImgArray = self.flagImgArray;
    obj.canTransferImgArray = self.canTransferImgArray;
    return obj;
}
@end
