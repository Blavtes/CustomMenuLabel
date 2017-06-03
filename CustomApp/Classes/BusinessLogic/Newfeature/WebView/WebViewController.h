//
//  WebViewController.h
//  HX_GJS
//
//  Created by litao on 16/1/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
//旧接口JS调用OC方法并显示在JS文件完成交互
@protocol TestJSExport <JSExport>

JSExportAs(gotoInvestPage,
           - (void)gotoInvestPage:(NSString *)data jsCallback:(NSString *)jsCallback
           );

JSExportAs(gotoActivityReward,
           - (void)gotoActivityReward:(NSString *)data jsCallback:(NSString *)jsCallback
           );

JSExportAs(gotoShowShareSheet,
           - (void)gotoShowShareSheet:(NSString *)data jsCallback:(NSString *)jsCallback
           );
@end

@interface WebViewController : CustomBaseViewController<UIWebViewDelegate,TestJSExport>

@property (copy, nonatomic) NSString *urlStr;

@property (assign, nonatomic) BOOL webViewShouldIgnoreCache;

//  是否单点登录
@property (assign, nonatomic) BOOL  isSSO;

//  是否从盈米基金首页过来
@property (assign, nonatomic) BOOL  isFromEvaluationRisk;

//  是否从盈米申购页过来
@property (assign, nonatomic) BOOL  isFromYMPurchaseView;

//  是否从平台注册绑卡流程过来
@property (assign, nonatomic) BOOL  isFromBankCardView;

//  是否从投资页过来
@property (assign, nonatomic) BOOL  isFromInvestView;

/**
 *  分享数据，存在时则显示右上角分享按钮
 */
@property (nonatomic, strong) NSMutableDictionary *shareParams;

/**
 *  JS交互相关
 */
@property (strong, nonatomic) JSContext *context;

@end
