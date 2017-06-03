//
//  MyGetRewardInfo.m
//  GjFax
//
//  Created by Blavtes on 2017/3/29.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "MyGetRewardInfo.h"

@implementation MyGetRewardInfo
- (instancetype)initWithDic:(id)object
{
    if (self = [super initWithDic:object]) {
//        [self testYY];
    }
    return self;
}

- (void)testYY
{
    _display = NO;
    _desc = @"<a color=\"0x363e40\" fontSize=\"13\">恭喜您获得</a><font color=\"#ff8248\" fontSize=\"13\">20000元</font><a color=\"0x363e40\" fontSize=\"13\">新手理财体验金</a>";
    _btnName = @"查看";
    _action = @"http:www.baidu.com";
    
}

@end
