//
//  ProductDetailModel.h
//  HX_GJS
//
//  Created by litao on 16/3/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseProductModel.h"
@class ProjectSummModel;
@class InstructionBookModel;

@interface ProductDetailModel : SFArchiverBaseModel

//  产品唯一标识
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
//  开售剩余时间(毫秒)
@property (assign, nonatomic) long long         startInvestTime;
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
//  免责声明
@property (nonatomic, copy) NSString            *disclaimer;
//  投资递增金额
@property (nonatomic, copy) NSString            *increaseAmount;
//  3.12新增
//  兑付日
@property (nonatomic, copy) NSString            *cashDate;
//  投资截止时间描述
@property (nonatomic, copy) NSString            *tradeDeadlineDesc;
//  产品可转让描述
@property (nonatomic, copy) NSString            *trasferDesc;
//  剩余投资名额
@property (nonatomic, copy) NSNumber            *remainPlaces;
//  服务器当前时间
@property (nonatomic, copy) NSString            *serverTime;
//  是否可转让
@property (assign, nonatomic) BOOL               canTrasfer;
//  剩余可投资金额描述
@property (nonatomic, copy) NSString             *remainDesc;
//  项目信息摘要（多项,title,desc）
@property (nonatomic, copy) NSMutableArray<ProjectSummModel *> *projectSumm;
//  交易说明书摘要
@property (nonatomic, copy) NSString            *tradeIntroSumm;
//  等额本息产品的收款期数
@property (nonatomic, copy) NSString            *periods;
//  募集日期
@property (nonatomic, copy) NSString            *raiseDate;
//  募集期限
@property (nonatomic, copy) NSString            *raiseTerm;
//  产品投资类型：28:广微系列（网贷）；非28:普通投资
@property (nonatomic, copy) NSString *prdType;
// 相关说明书模型
@property (nonatomic, copy) NSMutableArray<InstructionBookModel *> *relatedDesc;

+ (instancetype)modelWithDic:(NSDictionary *)dataDic;

@end

/*项目摘要模型 */
@interface ProjectSummModel : SFArchiverBaseModel
// 名称，可以动态配置（一般的项目为：“项目类型”，“资产信息”和“保障方式；对于月月盈项目：展示“项目类型”，“借款人”，“还款来源”）
@property (nonatomic, copy) NSString *title;
// 描述，名称对应的详细描述，可以动态配置
@property (nonatomic, copy) NSString *desc;
@end

/*网贷说明书模型 */
@interface InstructionBookModel : SFArchiverBaseModel
// title：标题
@property (nonatomic, copy) NSString *title;
// fileType：文件类型：0表示H5；1表示pdf
@property (nonatomic, copy) NSString *fileType;
// fileUrl：文件链接地址
@property (nonatomic, copy) NSString *fileUrl;
@end
