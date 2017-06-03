//
//  MyAccountInfoRequestService.m
//  GjFax
//
//  Created by gjfax on 16/6/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "MyAccountInfoRequestService.h"

@implementation MyAccountInfoRequestService

+ (void)startCheckUnOpenAward
{
    MyAccountInfoRequestService *service = [MyAccountInfoRequestService new];
    service.myAccountInfoType = MyAccountInfoTypeUnOpenAward;
    [service startRequest];
}

- (NSString *)apiUrl
{
    return @"";
}

- (void)unityConstrucSuccessData:(id)resultDic
{
    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:resultDic];
    
//    self.resultModel = [[UserAssetInfoModel manager] initWithDic:dataDic];
    
#pragma mark - 小红点 - 未拆奖励
    if (self.myAccountInfoType == MyAccountInfoTypeUnOpenAward) {
        
        NSString *redNum = FMT_STR(@"%@",[dataDic objectForKeyForSafetyValue:@"unknowAwardSum"]);
        if([redNum integerValue] > 0) {
            //  显示未拆奖励个数红点并保存
            [[BadgeTool sharedInstance] setBadgeValue:redNum keyBadgeType:UnOpenRewardType];
        }
    }
}

- (void)errored:(SFRequestError *)error
{
    if (self.myAccountInfoType == 0) {
        [HttpTool handleErrorCodeFromServer:error.errorCode withNote:error.errorNote];
    }
    [super errored:error];
}

@end
