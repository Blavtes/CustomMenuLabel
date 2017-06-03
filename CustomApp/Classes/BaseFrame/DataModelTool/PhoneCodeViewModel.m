//
//  PhoneCodeViewModel.m
//  HX_GJS
//
//  Created by litao on 16/2/4.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "PhoneCodeViewModel.h"
#import "PreCommonHeader.h"

@interface PhoneCodeViewModel () {
    //
}

@end

@implementation PhoneCodeViewModel

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType
{
    [self fetchPhoneCodeData:codeType withNewVersionFlag:NO];
}

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType withNewVersionFlag:(BOOL)isNewVersion withAmount:(NSString *)amount
{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:FMT_STR(@"%ld", codeType) forKey:@"smsType"];

    //    [reqDic setObject:UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeMobilePhone) forKey:@"mobile"];
    //    [reqDic setObject:UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeUserName) forKey:@"userName"];
    
    if (isNewVersion) {
        [reqDic setObject:@"new" forKey:@"version"];
    }
    
    if (amount) {
        [reqDic setObject:[amount formatStrWithSignToNumberStr] forKey:@"amount"];
    }
    
    [HttpTool postUrl:HX_POSTCODEURL params:reqDic success:^(id responseObj) {
        //  解析数据
        [self req_callBack:responseObj];
    } failure:^(NSError *error) {
        //  网络出错
        self.failureBlock();
    }];
}

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType withNewVersionFlag:(BOOL)isNewVersion
{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:FMT_STR(@"%ld", codeType) forKey:@"smsType"];
    //    [reqDic setObject:UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeMobilePhone) forKey:@"mobile"];
    //    [reqDic setObject:UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeUserName) forKey:@"userName"];
    
    if (isNewVersion) {
        [reqDic setObject:@"new" forKey:@"version"];
    }
    
    [HttpTool postUrl:HX_POSTCODEURL params:reqDic success:^(id responseObj) {
        //  解析数据
        [self req_callBack:responseObj];
    } failure:^(NSError *error) {
        //  网络出错
        self.failureBlock();
    }];
}

- (void)req_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
    NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
    
    if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccess]) {
        
        NSDictionary *resultDic = [body objectForKeyForSafetyDictionary:@"result"];
        
        if (resultDic && resultDic.count > 0) {
            self.returnBlock(resultDic);
            
        } else {
            self.returnBlock(@YES);
        }
    } else {
        if ([retCodeStr isEqualToString:kPhoneCodeTime]) {
            //  短信太频繁
            NSString *remainTimeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyValue:@"remainTime"]);
            self.errorBlock(retCodeStr, remainTimeStr);
        } else {
            self.errorBlock(retCodeStr, retNoteStr);
        }
    }
}

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType
        withNewVersionFlag:(BOOL)isNewVersion
               mobilePhone:(NSString *)phone
                  userName:(NSString *)userName
{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:FMT_STR(@"%ld", codeType) forKey:@"smsType"];
    if (![phone isNullStr]) {
        [reqDic setObject:FMT_STR(@"%@",phone) forKey:@"mobile"];

    }
    if (![userName isNullStr]) {
        [reqDic setObject:FMT_STR(@"%@",userName) forKey:@"userName"];
    }
    
    if (isNewVersion) {
        [reqDic setObject:@"new" forKey:@"version"];
    }
    
    [HttpTool postUrl:HX_POSTCODEURL params:reqDic success:^(id responseObj) {
        //  解析数据
        [self req_callBack:responseObj];
    } failure:^(NSError *error) {
        //  网络出错
        self.failureBlock();
    }];
}

@end
