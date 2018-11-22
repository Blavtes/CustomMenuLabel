//
//  TransferProductModel.m
//  HX_GJS
//
//  Created by litao on 16/1/15.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "TransferProductModel.h"
#import "TransferProductNewModel.h"
//#import "TransferProductDetailModel.h"
#import "SFArchiverFileManager.h"

@implementation TransferProductModel


#pragma mark - 新接口 处理

- (instancetype)initWithDic:(id)object
{
    self = [super init];
    if (self) {
        
        //  新接口向旧接口转换
        TransferProductNewModel *newModel = [[TransferProductNewModel alloc] initWithDic:object];
        
        //  产品名称
        self.productName = newModel.productName;
        //  产品id
        self.productStockCode = newModel.productId;
        //  产品简称
        self.productStortName = newModel.shortName;
        //  原价
        self.productOriginPrice = newModel.originalPrice;
        //计息方式(1:一次性还本付息方式;2: 按月付息到期还本;3:按月付息(以月利 率计算利息)到期还本;4:按季付息;5: 等额本息)
        self.productIncomeType = newModel.interestType;
        //  发行日期
        self.productIssueDate = newModel.publishDate;
        //  结息日
        self.productDueDate = newModel.endDate;
        //  起息日
        self.productStartDate = newModel.startDate;
        //  差价
        self.productPriceDiff = newModel.diffPrice;
        //  转让后年化收益率
        self.productTransferedAnnualRate = newModel.interestRate;
        //  转让价格
        self.productTransferedPrice = newModel.transferPrice;
        //  转让投资期限
        self.productTransferedTerm = newModel.limitTime;
        //  转让id
        self.productTransferedID = newModel.transferId;
        //  转让用户id
        self.productTransferedSellerID = newModel.sellerId;
        //  转让状态(2:已申报;6:已成交;8:已 撤单)
        self.applyStatus = newModel.applyStatus;
        //  计息方式描述
        self.interestTypeDesc = newModel.interestTypeDesc;
        //  风险评级
        self.productRiskLv = newModel.riskRating;
        //  剩余可投金额 --> 0 [判断是否售罄]
        self.productBalance = newModel.remainAmount;
        //  最低投资金额
        self.productInvestmentLowerLimit = newModel.minAmount;
        
        //  最后调用，将数据保存到 详情model中
        [self modelSaveToDetailModel];
    }
    return self;
}


+ (instancetype)modelWithDic:(NSDictionary *)dataDic
{
    return [[self alloc] initWithDic:dataDic];
}

+ (NSArray *)modelArrayWithArray:(NSArray *)dataArray
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *dataDic in dataArray) {
        [modelArray addObject:[TransferProductModel modelWithDic:dataDic]];
    }
    
    return modelArray;
}

#pragma mark - 将model转为 详情model 并保存到本地

- (void)modelSaveToDetailModel
{
    if (!self.productTransferedID || [self.productTransferedID isNullStr]) {
        DLog(@"转让数据 保存到详情model中，id 为空");
    }
//    //  因均使用BaseProductModel作父类,大部分参数一致 ， 不一致的单个设置
//    TransferProductDetailModel *detailModel = [[TransferProductDetailModel alloc] init];
//    [detailModel autoSetProperty:[self modelToDic]];
//    
//    detailModel.incomeTypeStr = self.interestTypeDesc;
//    detailModel.startIncomeDateStr = self.productStartDate;
//    
    //  保存数据到本地
//    NSString *fileName = FMT_STR(@"%@%@", GJS_GetTransferProductDetail, self.productTransferedID);
//    [SFArchiverFileManager saveDataWithFileName:fileName dataSource:detailModel];
}

#pragma mark - 产品类型
- (ProductNaviType)getCurProductType
{
    return ProductTypeTransfer;
}
@end
