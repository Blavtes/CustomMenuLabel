//
//  NormalProductNewModel.h
//  GjFax
//
//  Created by gjfax on 16/10/16.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFBaseModel.h"

@interface NormalProductNewModel : SFBaseModel

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
//  [结息日]产品到期日期
@property (nonatomic, copy) NSString            *endDate;
//  [发售日]产品发行日期
@property (nonatomic, copy) NSString            *publishDate;
//  起息日
@property (nonatomic, copy) NSString            *startDate;
//  剩余可投金额 --> 0 [判断是否售罄]
@property (nonatomic, copy) NSString            *remainAmount;
//  产品年化利率
@property (nonatomic, copy) NSString            *interestRate;
//  计息方式(1:一次性还本付息方式;2: 按月付息到期还本;3:按月付息(以月利 率计算利息)到期还本;4:按季付息;5: 等额本息)
@property (nonatomic, copy) NSString            *interestType;
//  产品投资期限
@property (nonatomic, copy) NSNumber            *limitTime;
//  最低投资金额
@property (nonatomic, copy) NSString            *minAmount;
//  是否可使用广金币
@property (nonatomic, assign) BOOL                userCoin;
//  是否可使用广金券
@property (nonatomic, assign) BOOL                useTicket;
//  是否可转让
@property (assign, nonatomic) BOOL                canTrasfer;
//  开售剩余时间(毫秒)
@property (nonatomic, copy) NSString            *startInvestTime;
//  产品的投资进度
@property (nonatomic, copy) NSNumber            *progress;
//  万元收益
@property (nonatomic, copy) NSString            *tenThousIncome;
//  期限单位类型 （0：年  1：月  2：日
@property (nonatomic, copy) NSString            *limitTimeUnit;
//  投资期限范围,如:30-365
@property (nonatomic, copy) NSString            *limitTimeRange;
//  利率范围
@property (nonatomic, copy) NSString            *interestRateRange;
//  计息方式描述
@property (nonatomic, copy) NSString            *interestTypeDesc;

@end
