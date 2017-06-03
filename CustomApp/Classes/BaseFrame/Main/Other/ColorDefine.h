//
//  ColorDefine.h
//  HX_GJS
//
//  Created by litao on 16/2/19.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#ifndef ColorDefine_h
#define ColorDefine_h

#pragma mark - 通用颜色定义
//  随机色
#define RandColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//  颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//  颜色  e.g. UIColorFromRGBHex(0xCECECE);
#define UIColorFromRGBHex(rgbValue)     [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//  通用黑色 ok
#define COMMON_BLACK_COLOR RGBColor(94, 98, 99)

//  通用灰色 ok
#define COMMON_GREY_COLOR RGBColor(163, 163, 163)

//  浅灰色 ok
#define COMMON_LIGHT_GREY_COLOR RGBColor(206, 206, 206)

//  灰白色 (已经偏白) ok
#define COMMON_GREY_WHITE_COLOR RGBColor(241, 241, 241)

//  白色 ok
#define COMMON_WHITE_COLOR RGBColor(255, 255, 255)
#define COMMON_WHITE_COLOR_ALPHA RGBColorAlpha(255, 255, 255, .5f)

//  通用蓝色
#define COMMON_BLUE_COLOR RGBColor(55, 137, 221)

//  通用蓝青色[主色调] ok
#define COMMON_BLUE_GREEN_COLOR RGBColor(51, 167, 196)

#define COMMON_GREEN_BLUE_COLOR RGBColor(19, 177, 76)

//  浅蓝青色 ok
#define COMMON_LIGHT_BLUE_COLOR RGBColorAlpha(51, 167, 196, .6f)

//  通用橙黄色[文字] ok
#define COMMON_ORANGE_COLOR RGBColor(241, 130, 70)
//  弹出框 - 页面中部按钮 ok
#define COMMON_ORANGE_COLOR_FOR_ALERT_VIEW RGBColor(240, 103, 40)
//  通用橙黄色[底部按钮] ok
#define COMMON_ORANGE_COLOR_FOR_BOTTOM_BTN RGBColor(224, 96, 36)

//  通用红色
#define COMMON_RED_COLOR RGBColor(255, 62, 63)

//春节颜色
#define COMMON_SPRING_COLOR UIColorFromRGBHex(0xdc2e34)
//  通用绿色
#define COMMON_GREEN_COLOR RGBColor(129, 194, 74)

//  半透明颜色
#define TransparentColor [UIColor colorWithRed:238/255.0 green:243/255.0 blue:248/255.0 alpha:1.0f]

#define TransparentColorForHUD [UIColor colorWithRed:.05f green:.05f blue:.05f alpha:.2f]

#define VirsualColor [UIColor colorWithRed:238/255.0 green:243/255.0 blue:248/255.0 alpha:.3f]
//次等按钮按下背景色
#define COMMON_SECOND_RANK_TOUCH_COLOR UIColorFromRGBHex(0xffefe7)
////次等按钮按下字体颜色
#define COMMON_SECOND_RANK_TITLE_COLOR UIColorFromRGBHex(0xca4000)
//主按钮正常背景色
#define COMMON_FIRST_RANK_NORMOALL_BG_COLOR COMMON_ORANGE_COLOR_FOR_ALERT_VIEW
//主按钮按下背景色
#define COMMON_FIRST_RANK_TOUCH_COLOR UIColorFromRGBHex(0xcd5206)
//主按钮未激活背景色
#define COMMON_FIRST_RANK_NOT_ACTIVITYED_BG_COLOR UIColorFromRGBHex(0xf1c7b4)
//主按钮按下字体颜色
#define COMMON_FIRST_RANK_TITLE_COLOR UIColorFromRGBHex(0xca4000)

//文字按钮 按下颜色
#define COMMON_CHARACTER_TOUCHDOWN_COLOR UIColorFromRGBHex(0xadd6e3)
#endif /* ColorDefine_h */
