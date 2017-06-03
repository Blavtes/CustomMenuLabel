//
//  CustomTopHeaderView.m
//  GjFax
//
//  Created by yangyong on 2016/12/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomTopHeaderView.h"

@implementation CustomTopHeaderView

+(UIView *)showTopHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 2)];
    tableHeaderView.backgroundColor = COMMON_BLUE_GREEN_COLOR;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, -MAIN_SCREEN_HEIGHT / 2, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT / 2)];
    topView.backgroundColor = COMMON_BLUE_GREEN_COLOR;
    [tableHeaderView addSubview:topView];
    return tableHeaderView;
}

@end
