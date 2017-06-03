//
//  GjFaxCgiErrorModel.m
//  GjFax
//
//  Created by litao on 16/9/14.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GjFaxCgiErrorModel.h"

@implementation GjFaxCgiErrorModel

- (instancetype)initWithCgiName:(NSString *)cgiName
                        andCode:(NSString *)retCode
                        andInfo:(NSString *)retInfo
{
    //  info -> model
    if (self = [super init]) {
        self.cgiName = FMT_STR(@"%@", cgiName);
        self.errorMsg = FMT_STR(@"%@", retInfo);
        self.errorCode = FMT_STR(@"%@", retCode);
        self.curTime = [CommonMethod strCurrentTimeFormateYYMM];
        self.userId = FMT_STR(@"%@", UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeUserId));
        self.appVersion = [CommonMethod appVersion];
        UIViewController *topVc = GJSTopMostViewController();
        NSString *topClassName = [NSString stringWithUTF8String:object_getClassName(topVc)];
        self.pageId = topClassName;
    }
    
    return self;
}

+ (instancetype)modelWithCgiName:(NSString *)cgiName
                         andCode:(NSString *)retCode
                         andInfo:(NSString *)retInfo
{
    return [[self alloc] initWithCgiName:cgiName andCode:retCode andInfo:retInfo];
}

#pragma mark - 归档

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.cgiName = [decoder decodeObjectForKey:@"CgiError_cgiName"];
        self.userId = [decoder decodeObjectForKey:@"CgiError_userId"];
        self.appVersion = [decoder decodeObjectForKey:@"CgiError_appVersion"];
        self.curTime = [decoder decodeObjectForKey:@"CgiError_curTime"];
        self.pageId = [decoder decodeObjectForKey:@"CgiError_pageId"];
        self.errorCode = [decoder decodeObjectForKey:@"UCgiError_errorCode"];
        self.errorMsg = [decoder decodeObjectForKey:@"CgiError_errorMsg"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.cgiName forKey:@"CgiError_cgiName"];
    [encoder encodeObject:self.userId forKey:@"CgiError_userId"];
    [encoder encodeObject:self.appVersion forKey:@"CgiError_appVersion"];
    [encoder encodeObject:self.curTime forKey:@"CgiError_curTime"];
    [encoder encodeObject:self.pageId forKey:@"CgiError_pageId"];
    [encoder encodeObject:self.errorCode forKey:@"UCgiError_errorCode"];
    [encoder encodeObject:self.errorMsg forKey:@"CgiError_errorMsg"];
}
@end
