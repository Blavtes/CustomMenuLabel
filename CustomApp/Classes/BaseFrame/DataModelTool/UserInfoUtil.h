//
//  UserInfoUtil.h
//  HX_GJS
//
//  Created by litao on 16/1/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfoTypeDefine.h"

/**
 *  函数名隐藏在结构体里，以函数指针成员的形式存储
 */
typedef struct _funcUtil
{
    //  设置用户信息
    void (*setUserInfoWithValue)(UserInfoValueType infoType, NSString *info);
    //  获取用户信息
    NSString* (*getUserInfoWithValue)(UserInfoValueType infoType);
    
    //  设置用户信息
    void (*setUserInfoWithBool)(UserInfoBoolType infoType, BOOL info);
    //  获取用户信息
    BOOL (*getUserInfoWithBool)(UserInfoBoolType infoType);

    //  清空所有数据
    void (*clearGJSUserInfo)(BOOL all);
    
}UserInfoUtil_t;

#define UserInfoUtil ([_UserInfoUtil sharedUtil])

@interface _UserInfoUtil : NSObject
+ (UserInfoUtil_t *)sharedUtil;
@end
