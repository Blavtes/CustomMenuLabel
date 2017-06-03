//
//  SXCoreTextManager.m
//  SXFramework
//
//  Created by SunX on 15/1/31.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

#import "TBCityCoreTextManager.h"
#import "TBCityCoreTextLabel.h"

@implementation TBCityCoreTextManager


+ (CGFloat)getContentHeightWithWidth:(CGFloat)width
                            withText:(NSString*)string
                            withFont:(UIFont*)font{
    CGSize size = [[self class] getContentSizeWithText:string withFont:font maxWidth:width lineSpace:0];
    return  size.height;
}

+ (CGSize)getContentSizeWithText:(NSString*)string
                        withFont:(UIFont*)font
                        maxWidth:(CGFloat)maxWidth
                       lineSpace:(CGFloat)lineSpace{
    if ([string length]<1) {
        return CGSizeZero;
    }
    TBCityCoreTextLabel *view = [[TBCityCoreTextLabel alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 3000)];
    view.font = font;
    view.lineSpace = lineSpace;
    view.drawText = NO;
    view.text = string;
    
    if ([view.attributedString length]<1) {
        DLog(@"====XML无法解析内容或者内容为空====%@",string);
        return CGSizeZero;
    }
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)view.attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    CGPoint lineOrigin = lineOrigins[(CFArrayGetCount(lines)-1)];
    //+3是补误差值，
    CGFloat height = ceil(view.frame.size.height-lineOrigin.y) + 3;
    
    CGFloat textwidth = maxWidth;
    if (CFArrayGetCount(lines) <= 1) {
        CGFloat ascent, descent, leading;
        CTLineRef line = CFArrayGetValueAtIndex(lines, 0);
        textwidth =CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
    }
    
    if (path) CFRelease(path);
    if (ctFrame) CFRelease(ctFrame);
    if (ctFramesetter) CFRelease(ctFramesetter);
    return CGSizeMake(textwidth, height);
}


@end
