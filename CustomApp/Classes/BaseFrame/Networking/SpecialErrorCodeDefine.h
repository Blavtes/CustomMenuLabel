//
//  SpecialErrorCodeDefine.h
//  GjFax
//
//  Created by litao on 16/5/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#ifndef SpecialErrorCodeDefine_h
#define SpecialErrorCodeDefine_h

//  超时返回码
static NSString * const kTimeOutCode = @"0082";
//  本地 - 网络系统异常
static NSString * const kNetworkSystemError = @"N00001";

#pragma mark - 老的retCode返回的新版ICP错误码
//  登陆已过期，请重新登陆
static NSString * const kOldLoginExpiredError = @"C0122";
//  您的账户@于@在另外一台设备登陆,如非本人操作，您的密码可能已经泄露，请修改您的登陆密码
static NSString * const kOldLoginOtherDeviceError = @"C0123";
//  您的网络设备ID发生了变化，请重新登陆
static NSString * const kOldLoginDeviceIdError = @"C0124";
//  您尚未登陆，请重新登陆
static NSString * const kOldNoLoginError = @"C0125";
//  系统异常
static NSString * const kOldSystemError = @"C0126";

#pragma mark - errorCode新版错误码
//  密码出错
static NSString * const kEnteredPwdError = @"201001";
//  登陆已过期，请重新登陆
static NSString * const kLoginExpiredError = @"201010";
//  您的账户@于@在另外一台设备登陆,如非本人操作，您的密码可能已经泄露，请修改您的登陆密码
static NSString * const kLoginOtherDeviceError = @"201011";
//  您的网络设备ID发生了变化，请重新登陆
static NSString * const kLoginDeviceIdError = @"201012";
//  您尚未登陆，请重新登陆
static NSString * const kNoLoginError = @"201013";
//  登陆密码被冻结
static NSString * const kFrozenLoginPwdError = @"201002";

//  输入文字包含 特殊字符 异常
static NSString * const kInputStrError = @"220001";

//  交易密码错误 返回码
static NSString * const kEnteredPayPwdError = @"221001";
//  交易密码冻结
static NSString * const kFrozenPayPwdError = @"221002";

//  系统异常
static NSString * const kSystemError = @"301001";

#pragma mark - - 手势密码
//  手势密码为空
static NSString * const kGesturePwdIsNull = @"223001";

//  手势密码校验错误
static NSString * const kGesturePwdIsWrong = @"223002";

//充值失败
static NSString * const kRechargeFailedError =  @"202001";

//查询银行卡信息失败
static NSString * const kQueryBankCardError =  @"202002";

//输入 充值金额错误
static NSString * const kRechargeAmountError =  @"202003";

//充值失败 -邮政银行需要开通在线支付
static NSString * const kChargeOnLinePayError =  @"202004";

#pragma mark
#pragma mark -- fund
//基金 未开户
static NSString * const kFundAccountIsNull = @"222002";

 //交易密码为空
static NSString * const kDealPWDIsNull = @"221003";

//申购交易限额超限
static NSString * const kFundPurchaseMoneyOverLimit = @"222003";

//赎回 交易限额超限
static NSString * const kFundRedeemMoneyOverLimit = @"222004";

//赎回   金额不足
static NSString * const kFundRedeemMonty_insuffcient = @"222005";
//保险 核保失败错误码
static NSString * const kInsuranceInvestUnderWirtingErrorCode = @"224003";

#pragma mark
#pragma mark ---bugly

//api解析错误 返回数据错误
static int  const kBuglyParseAPItErrorCode                  = 9900401;

//api 获取的数据不为success
static int  const kBuglyGetDataNoSuccessCode                = 9900402;

//网络异常 获取不到数据 超时
static int  const kBuglyTimeOutErrorCode                    = 9900404;

//vc push exception
static NSString * const kBuglyVCPushExceptionCode           = @"9900900";

//vc pop exception
static NSString * const kBuglyVCPopExceptionCode            = @"9900901";

//vc pop root exception
static NSString * const kBuglyVCPopRootExceptionCode        = @"9900902";

//selector exception
static NSString * const kBuglySelectorExceptionCode         = @"9900903";

// safety exception etc.NSArray insert nil.
static NSString * const kBuglySafetyExceptionCode           = @"9900904";



#endif /* SpecialErrorCodeDefine_h */
