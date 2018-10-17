////
////  CgiDefine.h
////  YiYunMi
////
////  Created by 李涛 on 15/4/23.
////  Copyright (c) 2015年 李涛. All rights reserved.
////
//
#ifndef YiYunMi_CgiDefine_h
#define YiYunMi_CgiDefine_h
//

//// banner
#define HX_BANNER_URL @""

#define HX_NEWSLIST_URL @""

////  是否需要升级
#define GJS_CheckUpdate @""
//// 请求登入
#define HX_POSTLogin @"remote/login/login"
#define GJS_GJF_FinancialProductList @"restapi/gjf/financial/getFixedProductList"

#define HX_POSTCODEURL @"remote/sms/sendSMS"
//#pragma mark === 基金理财列表 过滤 fundCode ===
//#pragma mark

//
#define GJS_HOME_NONETWORK_PID     @"-1000" //无网络产品id

//    //协议 静态页面 重定向地址
#define GJS_INSURANCE_REDIRECT_URL @"%@restapi/static/redirectPage?pageId=%d"
//
//#pragma mark－--------------------- 友盟统计appKey -------------------
//

#pragma mark -JSPatch appKey
#ifdef DEBUG
#define JSPatchAppKey @"3bfb4f2411dadf2d"
#else
#define JSPatchAppKey @"3bfb4f2411dadf2d"
#endif

#ifdef DEBUG
#define JSPatchAppPublickKey @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDto2Y80TG/TxjNBIkoOjzK+Td6\nQwoyPFcViaxvyZfVmlaXTSKCUcOytNlq/aN9Sg6ZjYcT7ZiH0EU24jylVKN+1aJt\ngETJGdUSNAeOv4PjxnQ41AkZMBm4/MQIsuAVI66ZGXmBwnD0q9Og0w4Wb+HxoYIn\nwfAyabtkd7bdWvpF4wIDAQAB\n-----END PUBLIC KEY-----"
#else
#define JSPatchAppPublickKey @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDto2Y80TG/TxjNBIkoOjzK+Td6\nQwoyPFcViaxvyZfVmlaXTSKCUcOytNlq/aN9Sg6ZjYcT7ZiH0EU24jylVKN+1aJt\ngETJGdUSNAeOv4PjxnQ41AkZMBm4/MQIsuAVI66ZGXmBwnD0q9Og0w4Wb+HxoYIn\nwfAyabtkd7bdWvpF4wIDAQAB\n-----END PUBLIC KEY-----"
#endif
//
#endif
