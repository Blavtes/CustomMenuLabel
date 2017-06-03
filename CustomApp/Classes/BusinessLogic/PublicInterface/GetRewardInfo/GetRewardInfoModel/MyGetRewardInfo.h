//
//  MyGetRewardInfo.h
//  GjFax
//
//  Created by Blavtes on 2017/3/29.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "SFArchiverBaseModel.h"

/**
 *  获取奖励信息
 */
@interface MyGetRewardInfo : SFArchiverBaseModel

//是否显示
@property (nonatomic, assign) BOOL display ;
//文字描述
@property (nonatomic, strong) NSString *desc;
//按钮名称
@property (nonatomic, strong) NSString *btnName;
//点击按钮以后跳转地址，如果是http开头的url地址则直接跳转到H5界面；
//（"newUserProduct”：新手理财产品；）
@property (nonatomic, strong) NSString *action;

@end
