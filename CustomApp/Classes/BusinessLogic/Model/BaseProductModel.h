//
//  BaseProductModel.h
//  HX_GJS
//
//  Created by litao on 16/1/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFArchiverBaseModel.h"

typedef NS_ENUM(NSInteger, ProductNaviType) {
    ProductTypeNormal = 0,      //  定期理财
    ProductTypeCurrent,         //  活期理财
    ProductTypeFund,            //  基金理财
    ProductTypeInsurance,       //  保险理财
    ProductTypeTransfer,        //  转让专区
    ProductTypeBusiness         //  业务专区
};

typedef NS_ENUM(NSInteger, HomePageCellType) {
    HomePageCellTypeTopInfo = 0,    //  顶部信息区域
    HomePageCellTypeBanner,         //  banner区域
    HomePageCellTypeFixed,          //  定期推荐
    HomePageCellTypeCurrent,        //  活期推荐
    HomePageCellTypeFund,           //  基金推荐
    HomePageCellTypeLoan,           // 贷款
    HomePageCellTypeFish            //  新手理财
};

typedef NS_ENUM(NSInteger, ProductFlagType) {
    ProductFlagTypeCoin = 0,        //    广金币
    ProductFlagTypeTicket  ,         //    广金券
    ProductFlagCanTransfer ,        //    可转让
    ProductFlagTypeCount            //    图标总和
};

/**
 *  基础产品模型
 */
@interface BaseProductModel : SFArchiverBaseModel <NSCopying>
//  产品名称 ＝productName
@property (copy, nonatomic) NSString *productName;
//  产品短名称
@property (copy, nonatomic) NSString *productStortName;
//  产品评级
@property (copy, nonatomic) NSString *productRiskLv;
//  产品到期日期
@property (copy, nonatomic) NSString *productDueDate;
//  产品 起息日
@property (copy, nonatomic) NSString *productStartDate;
//  产品发行价
@property (copy, nonatomic) NSString *productIssuePrice;
//  产品发行日期
@property (copy, nonatomic) NSString *productIssueDate;
//  产品股权代码 ＝ productId
@property (copy, nonatomic) NSString *productStockCode;
//  产品股权类别名称
@property (copy, nonatomic) NSString *productStockTypeName;
//  产品股权名称
@property (copy, nonatomic) NSString *productStockName;
//  产品年化利率
@property (copy, nonatomic) NSString *productAnnualRate;
//  产品交易状态
@property (copy, nonatomic) NSString *productTradingStatus;
//  计息方式（1：一次性还本付息方式；2：按月付息到期还本；3：按月付息（以月利率计算利息）到期还本；4：按季付息；5：等额本息）
@property (copy, nonatomic) NSString *productIncomeType;
//  产品投资期限
@property (copy, nonatomic) NSNumber *productInvestmentTerm;
//  产品投资下限
@property (copy, nonatomic) NSString *productInvestmentLowerLimit;
//  产品委托数量
@property (copy, nonatomic) NSString *productCommissionNum;
//  产品总股本
@property (copy, nonatomic) NSString *productCapitalization;
//  产品状态 --> 1已过期<与以前兼容>，2预约，3交易成功，4已过期，5投资，6其他
@property (copy, nonatomic) NSString *productStatus;
//  产品投资进度
@property (copy, nonatomic) NSNumber *productProgress;
//  剩余可投金额 --> [判断是否售罄]
@property (copy, nonatomic) NSString *productBalance;
//  产品类型 （0：广金所   1：汇宝）
@property (copy, nonatomic) NSString *productCompanyType;
//  期限类型 （0：年  1：月  2：日）
@property (copy, nonatomic) NSString *productTermType;
//  利率范围
@property (copy, nonatomic) NSString *productRateRangeStr;
//  期限范围
@property (copy, nonatomic) NSString *productTermRangeStr;

//  万元收益 （预期收益=10000元X该产品预期年化X天数/360）
@property (copy, nonatomic) NSString *productTenThousIncome;
//  计息方式描述
@property (copy, nonatomic) NSString *interestTypeDesc;
//  免责声明
@property (copy,nonatomic) NSString *disclaimer;

#pragma mark - 产品特性图标 - 广金币等
- (NSArray *)configProductFlagImgArray:(NSArray *)flagTypeArray;
#pragma mark - 可转让图标
- (NSArray *)configCanTransferImgArray:(NSArray *)canTransferArray;

- (id)copyWithZone:(NSZone *)zone;
@end
