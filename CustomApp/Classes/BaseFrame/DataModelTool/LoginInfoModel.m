//
//  LoginInfoModel.m
//  HX_GJS
//
//  Created by gjfax on 16/2/19.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "LoginInfoModel.h"

@implementation LoginInfoModel

+ (LoginInfoModel *)shareLoginModel {
    static LoginInfoModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[LoginInfoModel alloc] init];
    });
    return model;
}

- (instancetype)initWithDataDic:(id)dataDic {
    
    [self GJSAutoSetPropertySafety:dataDic];
    
    self.isShortDPwd = [[dataDic objectForKeyForSafetyValue:@"isShortDPwd"] boolValue];
#pragma mark - 每次请求这个状态则保存到本地 【如果是短密码则后续一定是短密码】
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeIsShortPwd, self.isShortDPwd);
    self.isGesturePwd = [[dataDic objectForKeyForSafetyValue:@"isGesturePwd"] boolValue];

    return self;
}
@end
