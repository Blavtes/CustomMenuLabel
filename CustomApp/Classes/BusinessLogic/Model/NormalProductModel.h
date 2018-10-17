//
//  NormalProductModel.h
//  HX_GJS
//
//  Created by litao on 16/1/11.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseProductModel.h"

@interface NormalProductModel : BaseProductModel <NSCopying>
//  是否可以使用广金币
@property (assign, nonatomic) BOOL useCoin;
//  是否可使用广金券
@property (assign, nonatomic) BOOL useTicket;
//  是否可转让
@property (assign, nonatomic) BOOL canTrasfer;
//  倒计时时间
@property (assign, nonatomic) long long countDownNum;
//  （广金券）图标数组
@property (strong, nonatomic) NSArray *flagImgArray;
//  （可转让标签）图标数组
@property (strong, nonatomic) NSArray *canTransferImgArray;

//  自身产品类型
- (ProductNaviType)getCurProductType;

//- (instancetype)initWithDic:(NSDictionary *)dataDic;

+ (instancetype)modelWithDic:(NSDictionary *)dataDic;

+ (NSArray *)modelArrayWithArray:(NSArray *)dataArray;

- (id)copyWithZone:(NSZone *)zone;
//带入倒计时
- (void)setStartCountDownNum:(long long)time;
@end
