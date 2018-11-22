//
//  ProductNavigationModel.h
//  GjFax
//
//  Created by litao on 2016/11/6.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFArchiverBaseModel.h"

//@class NormalProductModel;
//@class CurrentProductModel;
@class TransferProductModel;
//@class BusinessTypeModel;
//@class InsuranceDetailModel;
//@class YMFundProductListModel;

@interface ProductNavigationModel : SFArchiverBaseModel

//  定期总数量
@property (assign, nonatomic) NSInteger fixedTotalNum;
//  活期总数量
@property (assign, nonatomic) NSInteger currentTotalNum;
//  基金总数量
@property (assign, nonatomic) NSInteger fundTotalNum;
//  保险总数量
@property (assign, nonatomic) NSInteger insuranceTotalNum;
//  转让总数量
@property (assign, nonatomic) NSInteger transferTotalNum;
//  特邀总数量
@property (assign, nonatomic) NSInteger businessTotalNum;
//专区产品列表中显示的基金个数内容可配置，如："99+"，"1000+"。
@property (strong, nonatomic) NSString *fundNumMore;
//  3.9 新增 基金 是否有推荐产品  default is NO
@property (assign, nonatomic) BOOL      fundRecommend;

//  定期Navi数组
//@property (strong, nonatomic) NSArray <NormalProductModel *> *fixedNaviArray;
////  活期Navi数组
//@property (strong, nonatomic) NSArray <CurrentProductModel *> *currentNaviArray;
////  基金Navi数组
//@property (strong, nonatomic) NSArray <YMFundProductListModel *> *fundNaviArray;
////  保险Navi数组
//@property (strong, nonatomic) NSArray <InsuranceDetailModel *> *insuranceNaviArray;
//  转让Navi数组
@property (strong, nonatomic) NSArray <TransferProductModel *> *transferNaviArray;
//  特邀Navi数组
//@property (strong, nonatomic) NSArray <BusinessTypeModel *> *businessNaviArray;

+ (instancetype)modelWithDic:(NSDictionary *)dataDic;

@end
