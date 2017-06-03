//
//  CLLockVC.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    //设置密码
    CoreLockTypeSetPwd=0,
    
    //输入并验证密码
    CoreLockTypeVeryfiPwd,
    
    //修改密码
    CoreLockTypeModifyPwd,
    
}CoreLockType;

@interface CLLockVC : UIViewController

@property (nonatomic,assign) CoreLockType type;
//  是否默认手势密码登陆
@property (nonatomic,assign,getter=isDefaultLockLogin) BOOL isDefaultLockLogin;
//  是否注册流程中设置手势密码
@property (nonatomic,assign,getter=isRegistSetting) BOOL isRegistSetting;
//  是否关闭服务器手势密码
@property (nonatomic,assign,getter=isCloseGestureOnAppServer) BOOL isCloseGestureOnAppServer;

//  是否验证后重置手势密码
@property (nonatomic,assign,getter=isVeryfiRetSetPwd) BOOL isVeryfiRetSetPwd;

//重置校验成功后需临时保存 旧密码
@property (nonatomic, copy) NSString  *oldGesturePwd;
//重置校验的 密码 类型   “1”是手势密码校验   “2”是登录密码校验
@property (nonatomic, copy) NSString  *resetPwdType;

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+ (BOOL)hasPwd;

/*
 *  展示设置密码控制器
 */
+ (instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/**
 *  第一次见手势密码设置
 */
+ (instancetype)showSettingLockVCWithRegistSettingInVC:(UIViewController *)vc cancelBlock:(void(^)())cancelBlock successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock;

/*
 *  展示验证密码输入框
 */
+ (instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/*
 *  展示验证密码输入框 - 关闭手势密码使用
 */
+ (instancetype)showVerifyLockVCInVCForCloseGesture:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/**
 *  展示密码输入框--账号登陆
 */
+ (instancetype)showVerifyLockWithAccoutLoginVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

#pragma mark - 重置密码 校验 与 重置
/*
 *  展示 密码校验 输入框
 */
+ (instancetype)showModifyLockVCInVC:(UIViewController *)vc
                        successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;

/*
 *  展示 重置密码
 */
+ (instancetype)showRetSettingLockVCInVC:(UIViewController *)vc
                           oldGesturePwd:(NSString *)oldGesturePwd
                            resetPwdType:(NSString *)resetPwdType
                            successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock;


/*
 *  消失
 */
- (void)dismiss:(NSTimeInterval)interval;

/**
 *  自定义label
 *
 *  @param str
 */
- (void)labelWithStr:(NSString *)str;

@end
