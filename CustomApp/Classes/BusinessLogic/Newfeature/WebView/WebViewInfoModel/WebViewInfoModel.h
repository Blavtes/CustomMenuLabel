//
//  WebViewInfoModel.h
//  GjFax
//
//  Created by gjfax on 17/4/1.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "SFBaseModel.h"
@class WebReg;
@class WebLogin;
@class TermProDetail;
@class TransProDetail;
@class GetShareInfo;

/**
 *  专门管理H5交互相关
 */
@interface WebViewInfoModel : SFBaseModel

//  指定动作决定走哪个交互流程
@property (nonatomic, copy)   NSString              *action;
//  模块名，标记从哪个模块调用了该接口
@property (nonatomic, copy)   NSString              *module;
//  传递给native app的参数
@property (nonatomic, strong) NSDictionary          *data;

@property (nonatomic, strong) WebReg                *webReg;

@property (nonatomic, strong) WebLogin              *webLogin;

@property (nonatomic, strong) TermProDetail         *termProDetail;

@property (nonatomic, strong) TransProDetail        *transProDetail;

@property (nonatomic, assign) BOOL                  displayShareBtn;

@property (nonatomic, strong) GetShareInfo          *getShareInfo;

#pragma mark - 单例
+ (WebViewInfoModel *)manager;

//  清理单例中的数据
+ (void)cleanWebViewInfoData;

@end

/**
 *  注册流程相关
 */
@interface WebReg : SFBaseModel

//  跳转链接
@property (nonatomic, copy) NSString        *redirectUrl;

@end

/**
 *  登录流程相关
 */
@interface WebLogin : SFBaseModel

//  跳转链接
@property (nonatomic, copy) NSString        *redirectUrl;

@end

/**
 *  定期详情流程相关
 */
@interface TermProDetail : SFBaseModel

//  产品ID
@property (nonatomic, copy) NSString        *productId;

@end

/**
 *  转让详情流程相关
 */
@interface TransProDetail : SFBaseModel

//  转让ID
@property (nonatomic, copy) NSString        *transferId;

@end

/**
 *  获取分享接口相关
 */
@interface GetShareInfo : SFBaseModel

//  分享地址
@property (nonatomic, copy) NSString        *shareUrl;
//  分享图片地址
@property (nonatomic, copy) NSString        *shareLogoUrl;
//  分享内容
@property (nonatomic, copy) NSString        *shareContent;
//  分享标题
@property (nonatomic, copy) NSString        *shareTitle;

@end
