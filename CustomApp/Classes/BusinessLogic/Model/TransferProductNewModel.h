//
//  TransferProductNewModel.h
//  GjFax
//
//  Created by gjfax on 16/10/16.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFBaseModel.h"

@interface TransferProductNewModel : SFBaseModel

//  产品唯一标识(普通产品的股权代码,汇宝 A对应产品代码)
@property (nonatomic, copy) NSString            *productId;
//  产品名称
@property (nonatomic, copy) NSString            *productName;
//  产品简称
@property (nonatomic, copy) NSString            *shortName;
//  产品类型(0:普通产品,1:汇宝A)
@property (nonatomic, copy) NSString            *productType;
//  风险评级
@property (nonatomic, copy) NSString            *riskRating;
//  计息方式(1:一次性还本付息方式;2: 按月付息到期还本;3:按月付息(以月利 率计算利息)到期还本;4:按季付息;5: 等额本息)
@property (nonatomic, copy) NSString            *interestType;
//  [结息日]产品到期日期
@property (nonatomic, copy) NSString            *endDate;
//  [发售日]产品发行日期
@property (nonatomic, copy) NSString            *publishDate;
//  起息日
@property (nonatomic, copy) NSString            *startDate;
//  产品年化利率
@property (nonatomic, copy) NSString            *interestRate;
//  产品投资期限
@property (nonatomic, copy) NSString            *limitTime;
//  计息方式描述
@property (nonatomic, copy) NSString            *interestTypeDesc;
//  剩余可投金额 --> 0 [判断是否售罄]
@property (nonatomic, copy) NSString            *remainAmount;
//  最低投资金额
@property (nonatomic, copy) NSString            *minAmount;
//  差价
@property (nonatomic, copy) NSString            *diffPrice;
//  原价
@property (nonatomic, copy) NSString             *originalPrice;
//  转让价格
@property (nonatomic, copy) NSString            *transferPrice;
//  转让id
@property (nonatomic, copy) NSString            *transferId;
//  转让用户id
@property (nonatomic, copy) NSString            *sellerId;
//  申请状态(2:已申报;6:已成交;8:已 撤单)
@property (nonatomic, copy) NSString            *applyStatus;
//  免责声明
@property (nonatomic ,copy) NSString            *disclaimer;
//  是否可使用广金币
@property (nonatomic ,assign) BOOL               userCoin;
//  是否可使用广金券
@property (nonatomic ,assign) BOOL               useTicket;
@end
