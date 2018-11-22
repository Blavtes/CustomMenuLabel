//
//  TransferProductModel.h
//  HX_GJS
//
//  Created by litao on 16/1/15.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseProductModel.h"

@interface TransferProductModel : BaseProductModel
//  转让id
@property (copy, nonatomic) NSString *productTransferedID;
//  转让数量
@property (copy, nonatomic) NSString *productTransferedNum;
//  转让委托编号
@property (copy, nonatomic) NSString *productTransferedEntrustNo;
//  sellerID
@property (copy, nonatomic) NSString *productTransferedSellerID;
//  差价
@property (copy, nonatomic) NSString *productPriceDiff;
//  转让投资期限
@property (copy, nonatomic) NSString *productTransferedTerm;
//  原价
@property (copy, nonatomic) NSString *productOriginPrice;
//  转让价格
@property (copy, nonatomic) NSString *productTransferedPrice;
//  转让后年化收益率
@property (copy, nonatomic) NSString *productTransferedAnnualRate;
//  现申请状态 applyStatus  == 6  || (applyStatus == 2 && sellerID == userID) 不能购买
//  转让状态(2:已申报;6:已成交;8:已 撤单)
@property (copy, nonatomic) NSString *applyStatus;
//  产品安全等级
@property (copy, nonatomic) NSString *riskRating;
//  预期收益
@property (nonatomic, copy) NSString *expectEarnings;

//  自身产品类型
- (ProductNaviType)getCurProductType;

- (instancetype)initWithDic:(NSDictionary *)dataDic;

+ (instancetype)modelWithDic:(NSDictionary *)dataDic;

+ (NSArray *)modelArrayWithArray:(NSArray *)dataArray;
@end
