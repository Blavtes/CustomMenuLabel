//
//  PhoneCodeViewModel.h
//  HX_GJS
//
//  Created by litao on 16/2/4.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "BaseViewModel.h"
#import "PhoneCodeTypeDefine.h"

@interface PhoneCodeViewModel : BaseViewModel

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType;

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType withNewVersionFlag:(BOOL)isNewVersion;

- (void)fetchPhoneCodeData:(PhoneCodeType)codeType withNewVersionFlag:(BOOL)isNewVersion withAmount:(NSString *)amount;

/*
 *  需自定义参数，获取验证码
 */
- (void)fetchPhoneCodeData:(PhoneCodeType)codeType
        withNewVersionFlag:(BOOL)isNewVersion
               mobilePhone:(NSString *)phone
                  userName:(NSString *)userName;
@end
