//
//  LoginInfoModel.h
//  HX_GJS
//
//  Created by gjfax on 16/2/19.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoModel : NSObject


@property (nonatomic, copy) NSString                    *isSetCert;     //是否已经实名认证
@property (nonatomic, copy) NSString                    *isBindCard;    //是否已经绑卡
@property (nonatomic, copy) NSString                    *isSetDealpwd;  //是否已经设置交易密码
@property (nonatomic, copy) NSString                    *isSetPwdAnswer;//是否已经设置安全问题
@property (nonatomic, copy) NSString                    *isValidateEmail;//邮箱是否已经验证
@property (nonatomic, copy) NSString                    *activation;    //是否需要或已经激活。0: 不需要激活1: 需要激活但未激活2: 需要激活但已经激活
@property (nonatomic, copy) NSString                    *isUserCan;           //是否显示活动推荐菜单

@property (nonatomic, copy) NSString                  *userId;        //用户ID
@property (nonatomic, copy) NSString                  *userName;      //用户名
@property (nonatomic, copy) NSString                  *email;         //email
@property (nonatomic, copy) NSString                  *mobilePhone;   //手机号码
@property (nonatomic, copy) NSString                  *createTime;    //创建时间
@property (nonatomic, copy) NSString                  *updateTime;    //修改时间
@property (nonatomic, copy) NSString                  *fidKhh;        //顶点注册返回客户号
@property (nonatomic, copy) NSString                  *fidGqzh;       //股权账号
@property (nonatomic, copy) NSString                  *fidLsh;        //资产账户开户流水号
@property (nonatomic, copy) NSString                  *registerFlag;  //注册信息来源
@property (nonatomic, copy) NSString                  *userType;      //用户类型
@property (nonatomic, copy) NSString                  *registerGiveAmount;    //赠送广金币
@property (nonatomic, copy) NSString                  *bindCardGiveAmount;    //绑卡送广金币
@property (nonatomic, copy) NSString                  *realName;            //真实姓名
@property (nonatomic, copy) NSString                  *certiCode;           //身份证号码 后四位
@property (nonatomic, copy) NSString                  *lastLoginTime;       //最后登陆时间
@property (nonatomic, copy) NSString                  *zjzh;                //资金账号
@property (nonatomic, copy) NSString                  *nickName;            //昵称
@property (nonatomic, copy) NSString                  *recommendCode;       //推荐码
@property (nonatomic, copy) NSString                  *headPortraitPath;    //头像文件地址

@property (nonatomic, assign) BOOL                    isShortDPwd;  //是否新老用户 短密码 NO长密码
@property (nonatomic, assign) BOOL                    isGesturePwd; //  是否设置手势密码
@property (nonatomic, assign) BOOL                    isAgent;      //是否是经济人 
@property (nonatomic, copy) NSString                  *certiFlag;       //0 未认证 1 通联用户 2 已认证
@property (nonatomic, copy) NSString                  *certiCodeAll;    //身份证号 全部18位

@property (nonatomic, assign) BOOL                      isBindFund; //是否绑定了基金卡
//  单点登录所需参数
@property (nonatomic, copy) NSString                  *sessionId;       //sessionId
@property (nonatomic, copy) NSString                  *token;       //token
@property (nonatomic, copy) NSString                  *rdkey;       //rdkey


#pragma mark - 3.8
// 是否绑定 基金业务银行卡
@property (nonatomic, assign) BOOL          isBindYMFundCard;
//  基金测评状态描述
@property (nonatomic, copy) NSString        *ymFundEvaluState;
//  活期测评状态
@property (nonatomic, copy) NSString        *fundEvaluState;
//  广金所平台风险测评状态
@property (nonatomic, copy) NSString        *gjfaxEvaluState;

//字典转model
- (instancetype)initWithDataDic:(id)dataDic;


+ (LoginInfoModel *)shareLoginModel;
@end
