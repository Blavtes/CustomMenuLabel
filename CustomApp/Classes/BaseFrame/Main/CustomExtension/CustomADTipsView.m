//
//  CustomADTipsView.m
//  GjFax
//
//  Created by yangyong on 2016/12/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomADTipsView.h"

@implementation CustomADTipsView


+(UIView *)showADTipsView
{
   return  [CustomADTipsView showADTipsView:@"市场有风险 , 投资需谨慎"];
}

+(UIView *)newUserProductShowADTipsView
{
    return [CustomADTipsView showADTipsView:@"活动 • 市场有风险,投资需谨慎"];
}

+(UIView *)showADTipsView:(NSString *)str
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kTableViewHeaderHeight )];
    footerView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kTableViewHeaderHeight - 10)];
    tips.text = str;
    tips.textAlignment = NSTextAlignmentCenter;
    tips.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    tips.textColor = COMMON_GREY_COLOR;
    [footerView addSubview:tips];
    return footerView;
}

@end
