//
//  CoreTextAttribute.m
//  CoreText
//
//  Created by SunX on 14-4-10.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "TBCityCoreTextAttribute.h"
#import "TBCityColorManager.h"

@implementation TBCityCoreTextAttribute

/**
 *  添加了新元素不要忘记这个
 */
- (id)copyWithZone:(NSZone *)zone
{
	TBCityCoreTextAttribute *attribute = [[TBCityCoreTextAttribute alloc] init];
	attribute.content = self.content;
    attribute.font = self.font;
    attribute.fontSize = self.fontSize;
    attribute.href = self.href;
    attribute.height = self.height;
    attribute.width = self.width;
    attribute.src = self.src;
    attribute.color = self.color;
    attribute.unlineColor = self.unlineColor;
    attribute.charSpace = self.charSpace;
    attribute.tag = self.tag;
    attribute.maxWidth = self.maxWidth;
    attribute.bgColor = self.bgColor;
    attribute.textColor = self.textColor;
    attribute.midLineColor = self.midLineColor;
    attribute.midLineWidth = self.midLineWidth;
    attribute.bold = self.bold;
    attribute.offsetY = self.offsetY;
	return attribute;
}

-(id)initWithAttributeDict:(NSDictionary*)attributeDict tag:(NSString*)tag{
    self = [super init];
    if (self) {
        self.tag = tag;
        if (attributeDict) {
            self.href = attributeDict[@"href"];
            self.color = attributeDict[@"color"];
            self.unlineColor = attributeDict[@"unlineColor"];
            self.midLineWidth = attributeDict[@"midLineWidth"];
            self.midLineColor = attributeDict[@"midLineColor"];
            self.font = attributeDict[@"font"];
            self.fontSize= [attributeDict[@"fontSize"] floatValue];
            self.charSpace = [attributeDict[@"charSpace"] intValue];
            self.bold = [attributeDict[@"bold"] boolValue];
            self.maxWidth = [attributeDict[@"maxWidth"] intValue];
            self.bgColor = attributeDict[@"bgColor"];
            
            if ([self.tag isEqualToString:@"img"]) {
                self.src = attributeDict[@"src"];
                self.width = [attributeDict[@"width"] floatValue];
                self.height = [attributeDict[@"height"] floatValue];
                self.offsetY = [attributeDict[@"offsetY"] floatValue];
            }
        }
    }
    return self;
}

-(NSMutableAttributedString*)buildAttribute {
    NSMutableAttributedString *contentStr;
    
    if ([self.tag isEqualToString:@"img"]) {
        
        //设置CTRun的回调，用于针对需要被替换成图片的位置的字符，可以动态设置图片预留位置的宽高
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1;
        imageCallbacks.dealloc = TBCityRunDelegateDeallocCallback;
        imageCallbacks.getAscent = TBCityRunDelegateGetAscentCallback;
        imageCallbacks.getDescent = TBCityRunDelegateGetDescentCallback;
        imageCallbacks.getWidth = TBCityRunDelegateGetWidthCallback;
        
        NSDictionary *dic = @{@"width":@(self.width),@"height":@(self.height)};
        //创建CTRun回调
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge_retained void*)dic);
        
        contentStr = [[NSMutableAttributedString alloc] initWithString:@"\ufffc"];

        //设置图片预留字符使用CTRun回调
        [contentStr addAttribute:(NSString *)kCTRunDelegateAttributeName
                           value:(__bridge id)runDelegate
                           range:NSMakeRange(0, 1)];
        CFRelease(runDelegate);
        //设置图片预留字符使用一个imageName的属性，区别于其他字符
        
        [contentStr addAttribute:@"imageUrl"
                           value:self.src
                           range:NSMakeRange(0, 1)];
        
        [contentStr addAttribute:@"offsetY"
                           value:@(self.offsetY)
                           range:NSMakeRange(0, 1)];
        
        [contentStr addAttribute:@"imageSize"
                           value:[NSString stringWithFormat:@"{%f,%f}",self.width,self.height]
                           range:NSMakeRange(0, 1)];
        
        self.strLength = 1;
        self.content = @" ";
        
        [contentStr addAttribute:@"tag"
                           value:[NSString stringWithFormat:@"{%@,%@}",self.tag,self.content]
                           range:NSMakeRange(0, 1)];
        
        return contentStr;
    }
    
    //最大显示字数 一个中文当2个字符，maxWidth是10个中文的长度，20个英文字符
    if (self.maxWidth>0) {
        self.content = [[self class] maxWidthString:self.content width:self.maxWidth];
    }
    
    contentStr = [[NSMutableAttributedString alloc] initWithString:self.content];
    self.strLength = [contentStr length];
    
    if (self.strLength==0) {
        return contentStr;
    }
    
    [contentStr addAttribute:@"tag"
                       value:[NSString stringWithFormat:@"{%@,%@}",self.tag,self.content]
                       range:NSMakeRange(0, 1)];
    
    //增加蓝色点击
    if (self.href) {
        [contentStr addAttribute:(id)kCTForegroundColorAttributeName
                                value:(id)[[UIColor blueColor] CGColor]
                                range:NSMakeRange(0, self.strLength)];

    }
    //修改字体和大小
    if (self.font) {
        UIFont *font1 = [UIFont fontWithName:self.font size:self.fontSize>0?self.fontSize:12.f];
        CTFontRef font = CTFontCreateWithName((CFStringRef)font1.fontName, self.fontSize>0?self.fontSize:12.f, NULL);
        [contentStr addAttribute:(id)kCTFontAttributeName
                           value:(__bridge_transfer id)font
                           range:NSMakeRange(0, self.strLength)];
    }
    else {
        if (self.fontSize>0) {
            CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:self.fontSize].fontName, self.fontSize, NULL);
            [contentStr addAttribute:(id)kCTFontAttributeName
                               value:(__bridge_transfer id)font
                               range:NSMakeRange(0, self.strLength)];
        }
    }
    //修改字体间距
    if (self.charSpace>0) {
        CFNumberType numberType;
        #if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
            numberType = kCFNumberSInt64Type;
        #else
            numberType = kCFNumberSInt32Type;
        #endif
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,numberType,&_charSpace);
        [contentStr addAttribute:(id)kCTKernAttributeName value:(__bridge_transfer id)num
                           range:NSMakeRange(0, self.strLength)];
    }
    
    //修改颜色
    CGColorRef color = (__bridge CGColorRef)([self buildAttributeColor:self.color]);
    if (color) {
        [contentStr addAttribute:(id)kCTForegroundColorAttributeName
                           value:(__bridge id)color
                           range:NSMakeRange(0, self.strLength)];
    }
    
    //粗体
    if ([self.tag isEqualToString:@"b"] || self.bold)  {
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont boldSystemFontOfSize:self.fontSize].fontName,
                                              self.fontSize, NULL);
        [contentStr addAttribute:(id)kCTFontAttributeName
                           value:(__bridge_transfer id)font
                           range:NSMakeRange(0, self.strLength)];
        
    }
    //是否是斜体
    if ([self.tag isEqualToString:@"i"]) {
        CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:self.fontSize].fontName,
                                              self.fontSize, NULL);
        [contentStr addAttribute:(id)kCTFontAttributeName
                           value:(__bridge_transfer id)font
                           range:NSMakeRange(0, self.strLength)];
    }
    //下划线
    else if ([self.tag isEqualToString:@"u"]) {
        [contentStr addAttribute:(id)kCTUnderlineStyleAttributeName
                           value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                           range:NSMakeRange(0, self.strLength)];
        
        
        //下划线颜色
        CGColorRef unlineColor = (__bridge CGColorRef)([self buildAttributeColor:self.unlineColor]);
        if (unlineColor) {
            [contentStr addAttribute:(id)kCTUnderlineColorAttributeName
                               value:(__bridge id)unlineColor
                               range:NSMakeRange(0, self.strLength)];
        }
    }
    /**
     *  文字的背景色
     */
    if (self.bgColor) {
        [contentStr addAttribute:@"bgColor"
                           value:[UIColor colorWithCGColor:(__bridge CGColorRef)([self buildAttributeColor:self.bgColor])]
                           range:NSMakeRange(0, self.strLength)];
    }
    
    if (self.midLineColor) {
        [contentStr addAttribute:@"midLineColor"
                           value:[UIColor colorWithCGColor:(__bridge CGColorRef)([self buildAttributeColor:self.midLineColor])]
                           range:NSMakeRange(0, self.strLength)];
        if (self.midLineWidth) {
            [contentStr addAttribute:@"midLine"
                               value:self.midLineWidth
                               range:NSMakeRange(0, self.strLength)];
        }
    }
    
    return contentStr;
}

#pragma mark - CTRun回调
//CTRun的回调，销毁内存的回调
static void TBCityRunDelegateDeallocCallback( void* refCon ){
    if (refCon) {
        CFBridgingRelease(refCon);
    }
}

//CTRun的回调，获取高度
static CGFloat TBCityRunDelegateGetAscentCallback( void *refCon ){
    return [(NSString*)[(__bridge NSDictionary*)refCon objectForKey:@"height"] floatValue];
}

static CGFloat TBCityRunDelegateGetDescentCallback(void *refCon){
    return 0;
}

//CTRun的回调，获取宽度
static CGFloat TBCityRunDelegateGetWidthCallback(void *refCon){
    return [(NSString*)[(__bridge NSDictionary*)refCon objectForKey:@"width"] floatValue];
}

#pragma mark - 
- (id)buildAttributeColor:(NSString*)color{
    if (!color) {
        if (self.textColor) {
            return (id)self.textColor.CGColor;
        }
        return nil;
    }
    return (id)[[[TBCityColorManager defaultManager] getColorWithHexString:color] CGColor];
}

-(UIColor*)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
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

+(NSString*)maxWidthString:(NSString*)string width:(NSUInteger)maxWidth{
    NSString *newStr = @"";
    if (maxWidth>0) {
        if (maxWidth>=string.length) {
            return string;
        }
        float rangeIndex = 0.f;
        for (int i = 1; i<=string.length; i++) {
            NSString *a = [string substringWithRange:NSMakeRange(i-1, 1)];
            long len = strlen([a UTF8String]);
            if (len>1) {
                rangeIndex++;
            }
            else {
                rangeIndex += 0.5f;
            }
            if (rangeIndex>maxWidth) {
                newStr = [newStr stringByAppendingString:@"..."];
                break;
            }
            if (i<string.length&&rangeIndex==(maxWidth-0.5f)) {
                NSString *b = [string substringWithRange:NSMakeRange(i, 1)];
                long len = strlen([b UTF8String]);
                if ((rangeIndex+(len>1?1:0.5))>maxWidth) {
                    newStr = [newStr stringByAppendingString:@"..."];
                    break;
                }
            }
            newStr = [newStr stringByAppendingString:a];
        }
    }
    return newStr;
}

@end
