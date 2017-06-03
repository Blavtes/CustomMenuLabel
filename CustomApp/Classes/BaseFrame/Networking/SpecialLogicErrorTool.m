//
//  SpecialLogicErrorTool.m
//  GjFax
//
//  Created by litao on 16/5/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SpecialLogicErrorTool.h"
#import "CustomAlertView.h"



@implementation SpecialLogicErrorTool

+ (BOOL)handleSpecialErrorWithCode:(NSString *)errorCode andNote:(NSString *)errorNote
{
    BOOL isSpecialError = NO;
    
    NSString *errCodeStr = FMT_STR(@"%@", errorCode);
    
    if ([errCodeStr isEqualToString:kTimeOutCode] || [errCodeStr isEqualToString:kLoginExpiredError] || [errCodeStr isEqualToString:kOldLoginExpiredError] || [errCodeStr isEqualToString:kNoLoginError] || [errCodeStr isEqualToString:kOldNoLoginError]) {
        //  登录超时 || 登录已过期 || 未登录
        isSpecialError = YES;
        //  弹出登录页面 - 不需要返回首页
        
    } else if ([errCodeStr isEqualToString:kLoginDeviceIdError] || [errCodeStr isEqualToString:kOldLoginDeviceIdError]) {
        //  设备id发生变化
        isSpecialError = YES;
        
        CustomAlertViewForFuncJump *alertView = [[CustomAlertViewForFuncJump alloc] initWithCompletionBlock:^(id  _Nonnull alertView) {
            //  消失弹出框
            [(CustomAlertViewForFuncJump *)alertView dismiss];
            //  弹出登录页面 - 需返回首页
            
        }];
        alertView.textLabel.text = @"您的登录设备号发生了变化，请重新登录";
        alertView.textLabel.numberOfLines = 0;
        alertView.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        alertView.textLabel.height = alertView.textLabel.height * 2.0f;
        alertView.confirmBtnTitle = @"好的";
        [alertView show];
    } else if ([errCodeStr isEqualToString:kLoginOtherDeviceError] || [errCodeStr isEqualToString:kOldLoginOtherDeviceError]) {
        //  在其他设备登陆
        isSpecialError = YES;
        
        //  先隐藏掉其他现有的
        [CustomAlertView hideAll];
        
        CustomAlertViewForStrongTip *alertView = [[CustomAlertViewForStrongTip alloc] initWithCancelBlock:^(id  _Nonnull alertView) {
            //  消失弹出框
            [(CustomAlertViewForStrongTip *)alertView dismiss];
            //  弹出登录页面 - 需返回首页
            
        } withCompletionBlock:^(id  _Nonnull alertView) {
            //  消失弹出框
            [(CustomAlertViewForStrongTip *)alertView dismiss];
         
        }];
        if (errorNote && ![errorNote isNilObj]) {
            alertView.textLabel.text = errorNote;
        } else {
            alertView.textLabel.text = @"您的账户在另一台设备登录，如非本人操作，您的密码可能已经泄露，请重置您的登录密码";
        }
        alertView.textLabel.numberOfLines = 0;
        alertView.textLabel.frame = CGRectMake(alertView.textLabel.x, alertView.textLabel.y - alertView.textLabel.height, alertView.textLabel.width, alertView.textLabel.height);
        alertView.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        alertView.textLabel.height = alertView.textLabel.height * 3.0f;
        alertView.cancelBtnTitle = @"重新登录";
        alertView.confirmBtnTitle = @"重置登录密码";
        [alertView show];
    } else if ([errCodeStr isEqualToString:kFrozenLoginPwdError]) {
        //  登陆密码错误被冻结
        isSpecialError = YES;
        
        //  先隐藏掉其他现有的
        [CustomAlertView hideAll];
        
        CustomAlertViewForStrongTip *alertView = [[CustomAlertViewForStrongTip alloc] initWithCancelBlock:^(id  _Nonnull alertView) {
            //  消失弹出框
            [(CustomAlertViewForStrongTip *)alertView dismiss];
        } withCompletionBlock:^(id  _Nonnull alertView) {
            [(CustomAlertViewForStrongTip *)alertView dismiss];
            //  忘记密码
        
        }];
        if (errorNote && ![errorNote isNilObj]) {
            alertView.textLabel.text = errorNote;
        } else {
            alertView.textLabel.text = @"登录密码错误，请重试";
        }
        alertView.textLabel.numberOfLines = 0;
        alertView.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        alertView.textLabel.height = alertView.textLabel.height * 2.0f;
        alertView.cancelBtnTitle = @"关闭";
        alertView.confirmBtnTitle = @"找回登录密码";
        [alertView show];
    }
    
    return isSpecialError;
}
@end
