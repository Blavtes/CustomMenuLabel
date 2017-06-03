//
//  ThreeDTouchTool.m
//  HX_GJS
//
//  Created by gjfax on 16/4/15.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "ThreeDTouchTool.h"




@implementation ThreeDTouchTool


//初始化列表item
+ (void)initApplicationShortcutItem
{
    if (IOS_VERSION >= 9.0) {
        UIApplicationShortcutIcon *oneIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ShortcutItem_Icon_0"];
        UIMutableApplicationShortcutItem *oneItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"productList" localizedTitle:@"快速投资" localizedSubtitle:nil icon:oneIcon userInfo:nil];
        
        UIApplicationShortcutIcon *twoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ShortcutItem_Icon_1"];
        UIMutableApplicationShortcutItem *twoItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"myInvest" localizedTitle:@"我的投资" localizedSubtitle:nil icon:twoIcon userInfo:nil];
        
        UIApplicationShortcutIcon *threeIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ShortcutItem_Icon_2"];
        UIMutableApplicationShortcutItem *threeItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"receiptCalendar" localizedTitle:@"收款日历" localizedSubtitle:nil icon:threeIcon userInfo:nil];
        
        UIApplicationShortcutIcon *fourIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"ShortcutItem_Icon_3"];
        UIMutableApplicationShortcutItem *fourItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"newActivity" localizedTitle:@"最新活动" localizedSubtitle:nil icon:fourIcon userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[oneItem,twoItem,threeItem,fourItem];
    }
}

//点击item后根据不同的type来跳转界面
+ (void)clickShorycutItemJump:(UIApplicationShortcutItem*)ShortcutItem
{
    [CommonMethod goBackHomeWithTabbar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[ShortcutItem type] isEqualToString:@"productList"]) {
            //跳转至产品列表－－无需登陆
            [CommonMethod switchTabBar:PRODUCT_INDEX];
            
        }else if ([[ShortcutItem type] isEqualToString:@"myInvest"]) {
            //跳转至我的投资－－持有中，如果未登录在该界面会让用户登陆
      
            
        }else if ([[ShortcutItem type] isEqualToString:@"receiptCalendar"]) {
     
            
        }else if ([[ShortcutItem type] isEqualToString:@"newActivity"]) {
            //跳转至活动中心
      
        }
    });

}

@end
