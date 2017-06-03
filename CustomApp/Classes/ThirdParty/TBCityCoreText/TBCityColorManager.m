//
//  TBCityCoreTextColorManager.m
//  iCoupon
//
//  Created by SunX on 14/12/30.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCityColorManager.h"

@interface TBCityColorManager ()

@property (nonatomic,strong) NSMutableDictionary*                colorsDict;

@end

@implementation TBCityColorManager


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)defaultManager {
    static dispatch_once_t once;
    static TBCityColorManager * __singleton__;
    dispatch_once( &once, ^{
        __singleton__ = [[TBCityColorManager alloc] init];
    });
    return __singleton__;
}

- (id)init {
    self = [super init];
    if (self) {
        self.colorsDict = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRecvMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)onRecvMemoryWarning {
    [self.colorsDict removeAllObjects];
}

- (UIColor*)getColorWithHexString:(NSString*)hexColor {
    if (!hexColor) {
        if (self.colorsDict[@"clearColor"]) {
            return self.colorsDict[@"clearColor"];
        }
        UIColor *color =  [[self class] colorWithHexString:@"clearColor"];
        [self.colorsDict setObject:color forKey:@"clearColor"];
        return color;
    }
    //如果保持有
    if (self.colorsDict[hexColor]) {
        return self.colorsDict[hexColor];
    }
    if ([self.colorsDict count]>30) {
        [self.colorsDict removeAllObjects];
    }
    UIColor *color =  [[self class] colorWithHexString:hexColor];
    [self.colorsDict setObject:color forKey:hexColor];
    return color;
}

+ (UIColor*)colorWithHexString:(NSString *)hexColor
{
    if ([hexColor isEqualToString:@"red"]) {
        return [UIColor redColor];
    }
    else if ([hexColor isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }
    else if ([hexColor isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }
    else if ([hexColor isEqualToString:@"gray"]) {
        return [UIColor grayColor];
    }
    else if ([hexColor isEqualToString:@"lightGray"]) {
        return [UIColor lightGrayColor];
    }
    else if ([hexColor isEqualToString:@"darkGray"]) {
        return [UIColor darkGrayColor];
    }
    else if ([hexColor isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    }
    else if ([hexColor isEqualToString:@"orange"]) {
        return [UIColor orangeColor];
    }
    else if ([hexColor isEqualToString:@"brown"]) {
        return [UIColor brownColor];
    }
    else if ([hexColor isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    }
    else if ([hexColor isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }
    else if ([hexColor isEqualToString:@"white"]) {
        return [UIColor whiteColor];
    }
    else if ([hexColor isEqualToString:@"cyan"]) {
        return [UIColor cyanColor];
    }
    else if ([hexColor isEqualToString:@"clearColor"]) {
        return [UIColor clearColor];
    }
    
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])  cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor*)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha{
    NSString *key = [NSString stringWithFormat:@"%ld%f",(long)hex,alpha];
    TBCityColorManager *a = [TBCityColorManager defaultManager];
    if (a.colorsDict[key]) {
        return a.colorsDict[key];
    }
    if ([a.colorsDict count]>30) {
        [a.colorsDict removeAllObjects];
    }
    UIColor *color =  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
    [a.colorsDict setObject:color forKey:key];
    return color;
}

@end
