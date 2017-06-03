//
//  UserInfoTypeDefine.h
//  HX_GJS
//
//  Created by litao on 16/1/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#ifndef UserInfoTypeDefine_h
#define UserInfoTypeDefine_h

/**
 *  用户信息:具体值类型枚举
 */
typedef NS_ENUM(NSInteger, UserInfoValueType) {
    UserInfoValueTypeUserName = 0,              //  用户名
    UserInfoValueTypeMobilePhone,               //  用户手机号码
    UserInfoValueTypeLoginPwd,                  //  用户登录密码
    UserInfoValueTypeUserId,                    //  用户userId
    UserInfoValueTypeSessionId,                 //  用户SessionId
    UserInfoValueTypeHeadPortraitPath,          //  用户头像url
    UserInfoValueTypeUserRealName,              //  真实姓名
    UserInfoValueTypeRecommendCode,             //  用户的推荐码
    UserInfoValueTypeUserNickName,               //  用户昵称
    UserInfoValueTypeRdkey,                     //  与网页sso所需key
    UserInfoValueTypeToken,                     //  与网页SSO所需token
    UserInfoValueTypeHaiYingFundCacheDate,      // 基金cache 时间
};

/**
 *  用户信息:BOOL类型枚举
 */
typedef NS_ENUM(NSInteger, UserInfoBoolType) {
    UserInfoBoolTypeLoginStatus = 0,                //  用户登录状态 - [已废弃]
    UserInfoBoolTypeAutoLogin,                      //  是否自动登陆 - [已废弃]
    UserInfoBoolTypeRmbUserName,                    //  是否选择记住登录名
    UserInfoBoolTypeUseGesture,                     //  是否使用手势密码
    UserInfoBoolTypeShowedGestureView,              //  是否显示过设置手势密码页面
    UserInfoBoolTypeShowedLoginViewFromGestureView, //  登陆页面是从手势密码页面弹出的
    UserInfoBoolTypeEnteredApp,                     //  是否正式进入APP [优化顶部弹框使用 - 其他地方不适用]
    UserInfoBoolTypeUserTouchID,                    //  是否使用了指纹密码， 与手势密码冲突，只能开启其中之一
    UserInfoBoolTypeIsAlreadyEnterApp,              //  是否第一次打开app，暂时提示[开启指纹用到]。该值需要长存，清空数据时需保存此值
    UserInfoBoolTypeFirstLaunched,                  //  是否已经启动过APP [引导页使用]
    UserInfoBoolTypeIsAgent,                        //  是否是经纪人
    UserInfoBoolTypeIsShortPwd,                     //  是否短密码
    UserInfoBoolTypeIsAlreadyLogined,               //  进入app后，是否已经登录过。需保存此值 【隐藏首页注册】
    UserInfoBoolTypeFirstInvest,                    //  是否第一次进入定期理财，显示引导
    UserInfoBoolTypeFirstGotoNewYearsAction,        // 是否第一次进入新年活动
};

#endif /* UserInfoTypeDefine_h */
