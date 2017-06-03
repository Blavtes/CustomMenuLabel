//
//  CustomNavigationBarButtonItem.m
//  GjFax
//
//  Created by yangyong on 2016/12/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomNavigationBarButtonItem.h"

@implementation CustomNavigationBarButtonItem

+ (void)customRightItemTitle:(NSString *)title target:(id)target action:(SEL)action
{
    [[[[self class] alloc] init] customRightItemTitle:title target:target fontSize:kCommonFontSizeSubDesc_14 highlight:YES action:action];
}

- (void)customRightItemTitle:(NSString *)title target:(id)target fontSize:(int)fontSize highlight:(BOOL)highlighted action:(SEL)action
{
    UIBarButtonItem *RightItem = [UIBarButtonItem itemWithTitleStr:title titleFont:fontSize target:target action:action];
//    ((UIButton*)RightItem.customView).showsTouchWhenHighlighted = highlighted;
    [((UIButton*)RightItem.customView) setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];

    GJSTopMostViewController().navigationItem.rightBarButtonItem = RightItem;

}

+ (void)customLeftItemTitle:(NSString *)title target:(id)target action:(SEL)action
{
    [[[[self class] alloc] init] customLeftItemTitle:title target:target fontSize:kCommonFontSizeSubDesc_14 highlight:YES action:action];
}

- (void)customLeftItemTitle:(NSString *)title target:(id)target fontSize:(int)fontSize highlight:(BOOL)highlighted action:(SEL)action
{
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithTitleStr:title titleFont:fontSize target:target action:action];
//    ((UIButton*)leftItem.customView).showsTouchWhenHighlighted = highlighted;
    [((UIButton*)leftItem.customView) setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    GJSTopMostViewController().navigationItem.leftBarButtonItem = leftItem;
}

+ (void)customClearLeftItem
{
    [[[[self class] alloc] init] customClearLeftItem];
}

- (void)customClearLeftItem
{
    GJSTopMostViewController().navigationItem.leftBarButtonItem = [UIBarButtonItem
                                                                   itemWithTitleStr:@""
                                                                   target:self
                                                                   action:nil];
    
    GJSTopMostViewController().navigationItem.leftBarButtonItem.enabled = NO;
}

@end
