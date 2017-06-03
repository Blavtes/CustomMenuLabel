//
//  SigninRequestService.m
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SigninRequestService.h"
#import "BadgeTool.h"

@implementation SigninRequestService


+ (void)startSiginRequestWithShowText
{
    SigninRequestService *service = [[self class] new];
    service.signinType = SigninTypeShowText;
    [service startRequest];
}

- (NSDictionary *)resultDic
{
    if (!_resultDic) {
        _resultDic = [NSDictionary dictionary];
    }
    return _resultDic;
}

- (NSString *)apiUrl
{
    return @"";
}

- (NSMutableDictionary *)dataParams
{
    NSString *uuid = [CommonMethod UUIDWithKeyChain];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:uuid forKey:@"IMEI"];
    [dic setObject:@"A_5" forKey:@"approach"];
    return dic;
}

- (void)unityConstrucSuccessData:(id)resultDic
{
    self.resultDic = [NSDictionary dictionaryWithDictionary:resultDic];
    
#pragma mark - 小黄点 - 广积分
    if (_signinType == SigninTypeShowText) {    //是否需要显示 签到提示
        if ([@"C0119" isEqualToString:self.error.errorCode]) {//表示已签到，不show
            [[BadgeTool sharedInstance] setBadgeValue:nil keyBadgeType:SignEarnIntegral];
            [[BadgeTool sharedInstance] setBadgeIsShow:NO keyBadgeType:isShowSignInfo];
            
        }else {//今天签到成功
            NSString *integralNum = [self.resultDic objectForKeyForSafetyValue:@"prizesCount"];
            //  显示今日签到个数并保存
            [[BadgeTool sharedInstance] setBadgeValue:integralNum keyBadgeType:SignEarnIntegral];
            [[BadgeTool sharedInstance] setBadgeIsShow:YES keyBadgeType:isShowSignInfo];
            
            [self signShowText];
        }
    }
    
}


- (void)signShowText
{
    
    DLog(@"判断值%d",[[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowSignInfo]);
    if ([[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowSignInfo]) {
        //显示不同颜色的文字
        NSString *integralCount = [[BadgeTool sharedInstance] getBadgeValueWithType:SignEarnIntegral];
        NSString *str1 = FMT_STR(@"今日签到成功获得");
        NSString *str2 = FMT_STR(@"积分");
        NSString *string = [NSString stringWithFormat:@"%@%@%@",str1,integralCount,str2];
        NSMutableAttributedString *noticeString = [[NSMutableAttributedString alloc]initWithString:string];
        [noticeString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(0, str1.length)];
        [noticeString addAttributes:@{NSForegroundColorAttributeName:COMMON_ORANGE_COLOR,NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(str1.length, integralCount.length)];
        [noticeString addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(noticeString.length-str2.length, str2.length)];
        //  积分
        [[[[iToast makeAttributeText:noticeString] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal]attributeShow];
        [[BadgeTool sharedInstance] setBadgeIsShow:NO keyBadgeType:isShowSignInfo];
    }
}
@end
