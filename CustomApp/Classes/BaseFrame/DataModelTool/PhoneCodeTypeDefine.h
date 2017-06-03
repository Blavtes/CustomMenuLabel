//
//  PhoneCodeTypeDefine.h
//  HX_GJS
//
//  Created by litao on 16/2/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#ifndef PhoneCodeTypeDefine_h
#define PhoneCodeTypeDefine_h

static NSString * const kPhoneCodeTime = @"0083";

typedef NS_ENUM(NSInteger, PhoneCodeType) {
    PhoneCodeTypeRegisterValid = 1,             //  注册手机号码验证
    PhoneCodeTypeSetTransactionPassword = 2,    //  设置交易密码
    PhoneCodeTypeFindTransactionPassword = 3,   //  找回交易密码
    PhoneCodeTypeSetSafetyQustion = 5,          //  设置密保问题
    PhoneCodeTypeChargeCash = 6,                //  充值短信
    PhoneCodeTypeWithdrawCash = 7,              //  提现短信
    PhoneCodeTypeUnBindBankCard = 8,            //  解绑银行卡
    PhoneCodeTypeTransferProduct = 9,           //  产品转让确认
    PhoneCodeTypeFindLoginPassword = 11,        //  找回登陆密码
    PhoneCodeTypeTransferCoin = 13,             //  广金币转让确认
    PhoneCodeTypeIntegrationExchange = 14,      //  广积分兑换
    PhoneCodeTypeIntegrationExchangeCoin = 17   //  广积分兑换广金币
};

#endif /* PhoneCodeTypeDefine_h */
