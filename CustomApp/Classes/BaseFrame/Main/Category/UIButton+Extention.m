//
//  UIButton+Extention.m
//  HX_GJS
//
//  Created by litao on 15/8/27.
//  Copyright (c) 2015年 ZXH. All rights reserved.
//

#import "UIButton+Extention.h"
#import <objc/runtime.h>

@implementation UIButton (Extention)
/**
 *  返回一个btn
 *
 *  @return
 */
+ (instancetype)btnWithTitle:(NSString *)title rect:(CGRect)rect taget:(id)taget action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    btn.backgroundColor = COMMON_ORANGE_COLOR_FOR_ALERT_VIEW;
    int btnFontSize = kCommonFontSizeTitle_18;
    btn.titleLabel.font = [UIFont systemFontOfSize:btnFontSize];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = kCommonBtnRad;
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    //  设置点击间隔
    //btn.acceptEventInterval = .5f;
    
    return btn;
}

/**
 *  返回一个btn - 图片
 *
 *  @return
 */
+ (instancetype)btnWithImageName:(NSString *)iconName position:(CGPoint)position taget:(id)taget action:(SEL)action
{
    //  图片
    UIImage *btnIcon = [UIImage imageNamed:iconName];
    //  默认按钮
    if (!btnIcon) {
        btnIcon = [UIImage imageNamed:@"btn_navi_close_selected"];
    }
    //  按钮
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:btnIcon forState:UIControlStateNormal];
    [btn setBackgroundImage:btnIcon forState:UIControlStateHighlighted];
    
    //  设置大小
    btn.size = btn.currentBackgroundImage.size;
    btn.frame = CGRectMake(position.x, position.y, btn.size.width, btn.size.height);
    
    //  按钮点击高光
    btn.showsTouchWhenHighlighted = YES;
    
    //  事件响应
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    //  设置点击间隔
    //btn.acceptEventInterval = .5f;
    
    return btn;
}

+ (instancetype)btnWithTitleAndIcon:(NSString *)title
                       withIconName:(NSString *)iconName
                          withFrame:(CGRect)frame
                              taget:(id)taget
                             action:(SEL)action
{
    //  图片
    UIImage *btnIcon = [UIImage imageNamed:iconName];
    //  默认按钮
    if (!btnIcon) {
        btnIcon = [UIImage imageNamed:@"icon_invest_time"];
    }
    //  按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:btnIcon forState:UIControlStateNormal];
    [btn setImage:btnIcon forState:UIControlStateHighlighted];
    [btn setImage:btnIcon forState:UIControlStateSelected];
    
    btn.backgroundColor = [UIColor clearColor];
//    int btnFontSize = kCommonFontSizeTitle_18 + 4;
//    if (isRetina || iPhone5) {
//        btnFontSize = kCommonFontSizeTitle_18 + 2;
//    }
    btn.titleLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    //  设置按钮图标合适位置
    CGSize strSize = [title strSizeWithFont:kCommonFontSizeTitle_18 maxSize:MAX_SIZE];
    //  设置image在button上的位置（上top，左left，下bottom，右right）
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, - strSize.width * .25f, 0, 0);
    
    //  按钮点击高光
    btn.showsTouchWhenHighlighted = YES;
    
    //  title 和 image横向居中
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //  事件响应
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    //  设置点击间隔
    //btn.acceptEventInterval = .5f;
    
    return btn;
}


/**
 *  设置纯色的背景图
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -- 增加点击事件

static char *overViewKey;

- (void)GJSHandleClickEvent:(UIControlEvents)aEvent
                  callBack:(ButtonClickCallback)callBack
{
    objc_setAssociatedObject(self, &overViewKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:aEvent];
}

- (void)buttonClick {
    ButtonClickCallback callBack = objc_getAssociatedObject(self, &overViewKey);
    if (callBack!= nil)
    {
        callBack(self);
    }
}
@end
