//
//  TBCityCoreTextColorManager.h
//  iCoupon
//
//  Created by SunX on 14/12/30.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

/**
 *  将coreText的颜色保存一份，方便重用，收到MemoryWarnging或者>30时，会被清空
 */

#import <Foundation/Foundation.h>

@interface TBCityColorManager : NSObject

+(instancetype)defaultManager;

/**
 *  获取UIColor，优先在内存中获取
 *
 *  @param hexColor 如0xffffff 或  #ffffff
 *
 *  @return UIColor
 */
- (UIColor*)getColorWithHexString:(NSString*)hexColor;

/**
 *  通过十六进制格式获取UIColor
 *
 *  @param hexColor 如0xffffff 或  #ffffff
 *
 *  @return UIColor 这个方法不会从内存中读取
 */
+ (UIColor*)colorWithHexString:(NSString *)hexColor;

/**
 *  获取UIColor，优先在内存中获取
 *
 *  @param hexColor 如0xffffff 或  #ffffff  alpha = 0~1.0
 *
 *  @return UIColor
 */
+ (UIColor*)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end
