//
//  CoreTextView.m
//  CoreText
//
//  Created by SunX on 14-4-9.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "TBCityCoreTextLabel.h"
static CGFloat _iosVersion;

@interface TBCityCoreTextLabel () <NSXMLParserDelegate>
{
    BOOL         _loadTextFinish;
}

@end

@implementation TBCityCoreTextLabel

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height += 3;     //额外增加3个像素，避免用户输入高度不够
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _drawText = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
         withText:(NSString*)string {
    frame.size.height += 3;     //额外增加3个像素，避免用户输入高度不够
    self = [super initWithFrame:frame];
    if (self) {
        if (_iosVersion<0) {
            _iosVersion = [UIDevice currentDevice].systemVersion.floatValue;
        }
        self.backgroundColor = [UIColor clearColor];
        _drawText = YES;
        self.text = string;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
        withHandle:(CoreTextClickBlock)handle {
    frame.size.height += 3;     //额外增加3个像素，避免用户输入高度不够
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (_iosVersion<0) {
            _iosVersion = [UIDevice currentDevice].systemVersion.floatValue;
        }
        _drawText = YES;
        self.clickBlock = handle;
        
    }
    return self;
}

- (void)setText:(NSString *)text{
    if ([text length]<1) {
        [self setNeedsDisplay];
        return;
    }
    if (_text!=text) {
        _text = [text copy];
        //解析text的内容
        self.parser = nil;
        self.parser = [[TBCityCoreTextParser alloc] init];
        self.parser.lineSpace = self.lineSpace;
        self.parser.textAlign = self.textAlign;
        self.parser.lineBreak = self.lineBreak;
        self.parser.textColor = self.textColor;
        self.parser.font = self.font;
        [self.parser buildAttributedString:_text];
        self.attributedString = self.parser.attributedString;
    }
}

- (void)attributedStringWithParser:(TBCityCoreTextParser*)parser {
    if (_parser!=parser) {
        _parser = parser;
        self.attributedString = parser.attributedString;
    }
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString {
    _attributedString = attributedString;
    [self setNeedsDisplay];
}

+ (instancetype)showInView:(UIView*)view
                 withFrame:(CGRect)frame
                  withText:(NSString*)text
                withHandle:(CoreTextClickBlock)handle {
    TBCityCoreTextLabel *label = [[TBCityCoreTextLabel alloc] initWithFrame:frame withHandle:handle];
    label.text = text;
    [view addSubview:label];
    return label;
}


- (void)drawWithFinishBlock:(CoreTextDrawFinishBlock)finishBlock {
    self.drawFinishBlock = finishBlock;
}

- (void)clickWithBlock:(CoreTextClickBlock)clickBlock {
    self.clickBlock = clickBlock;
}

- (void)drawRect:(CGRect)rect {
    self.userInteractionEnabled = self.clickBlock?YES:NO;
    _textHeight = 0.f;
    _textWidth = self.frame.size.width;
    self.backgroundColor = [UIColor clearColor];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (!self.drawText||[self.attributedString length]<1) {
        return;
    }
    //设置NSMutableAttributedString的所有属性
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;
    
    //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    
    //获取实际高度
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex lintCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lintCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    //最后一行
    CGPoint lineOrigin = lineOrigins[(lintCount-1)];
    //+3 是补误差值，
    _textHeight = ceil(self.frame.size.height-lineOrigin.y) + 3;
    
    //获取当前label的宽度
    if (CFArrayGetCount(lines) == 1) {
        CGFloat ascent, descent, leading;
        CTLineRef line = CFArrayGetValueAtIndex(lines, 0);
        _textWidth =CTLineGetTypographicBounds(line, &ascent,  &descent, &leading);
    }
    
    //画图片
    [self drawImage:context arrayRef:lines lineOrigins:lineOrigins path:path];
    
    CTFrameDraw(ctFrame, context);
    if (path) CFRelease(path);
    if (ctFrame) CFRelease(ctFrame);
    if (ctFramesetter) CFRelease(ctFramesetter);
    
    //如果有手势，防止被覆盖
    if (self.gestureRecognizers) {
        self.userInteractionEnabled = YES;
        for (UIGestureRecognizer *ges in self.gestureRecognizers) {
            [self addGestureRecognizer:ges];
        }
    }
    
    if (self.drawFinishBlock) {
        self.drawFinishBlock(self);
    }
}

- (void)drawImage:(CGContextRef)context
        arrayRef:(CFArrayRef)lines
     lineOrigins:(CGPoint[])lineOrigins
            path:(CGMutablePathRef)path{
    //需要画图或者背景色才进入此方法
    if(!self.parser.needDrawExtraView) {
        return;
    }
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CGPoint lineOrigin = lineOrigins[i];
        //查看每行的CTRun
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            
            //每个run的frame
            CGFloat runAscent;
            CGFloat runDescent;
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line,
                                                                            CTRunGetStringRange(run).location, NULL),
                               lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            NSString *imageUrl = [attributes objectForKey:@"imageUrl"];
            //计算每行的实际宽度
            //图片渲染逻辑
            if (imageUrl) {
                CGRect imageDrawRect;
                imageDrawRect.size = CGSizeFromString(attributes[@"imageSize"]);
                imageDrawRect.origin.x = runRect.origin.x;
                UIImage *image;
                
                imageDrawRect.origin.y = self.frame.size.height - lineOrigin.y - imageDrawRect.size.height + 2 + [[attributes objectForKey:@"offsetY"] floatValue];
                UIImageView *imageView =  [[UIImageView alloc] initWithFrame:imageDrawRect];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.clipsToBounds = YES;
                [self addSubview:imageView];
                //本地资源图片
                if ([imageUrl hasPrefix:@"bundle://"]) {
                    image = [UIImage imageNamed:[imageUrl stringByReplacingOccurrencesOfString:@"bundle://" withString:@""]];
                }
                //网络图片 SDWebImage 实现
                else if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) {
                    //下载是一个异步的过程，所以不能用draw实现，因为context的坐标系是反过来的，所以需要这样调整y轴
                    SEL selector = NSSelectorFromString(@"sd_setImageWithURL:");
                    if (![UIImageView instancesRespondToSelector:selector]) {
                        selector = NSSelectorFromString(@"setImageWithURL:");
                    }
                    if ([UIImageView instancesRespondToSelector:selector]) {
                        IMP imp = [imageView methodForSelector:selector];
                        if (imp) {
                            void (*func)(id, SEL, NSURL*) = (void *)imp;
                            func(imageView, selector, [NSURL URLWithString:imageUrl]);
                        }
                    }
                }
                else if([imageUrl hasPrefix:@"file://"]) {
                    image = [UIImage imageWithContentsOfFile:imageUrl];
                }
                //本地缓存图片
                else if(self.imageDic){
                    image = self.imageDic[imageUrl];
                }
                if (image) {
                    imageView.image = image;
                }
            }
            UIColor *bgColor = [attributes objectForKey:@"bgColor"];
            if (bgColor) {
                const CGFloat *components = CGColorGetComponents(bgColor.CGColor);
                //画一个矩形
                runRect.origin.y += 1; //这里有点奇怪，像素位不准
                CGContextSetRGBFillColor(context,components[0], components[1], components[2], 1.0);
                CGContextFillRect(context, runRect);
            }
            
            NSString *midLine = attributes[@"midLine"];
            if (midLine) {
                UIColor *midLineColor = [attributes objectForKey:@"midLineColor"];
                const CGFloat *component =  CGColorGetComponents(midLineColor.CGColor);
                //中划线
                CGContextSetRGBStrokeColor(context, component[0], component[1], component[2], 1.0);
                CGContextSetLineWidth(context, [midLine floatValue]);
                CGContextMoveToPoint(context, runRect.origin.x, runRect.origin.y+runRect.size.height/2);
                CGContextAddLineToPoint(context, runRect.origin.x+runRect.size.width, runRect.origin.y+runRect.size.height/2);
                CGContextStrokePath(context);
            }
        }
    }
}

#pragma mark -
//接受触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //没有href标签直接跳出touch
    if (!self.clickBlock || !self.parser.canTouchBlock) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    if (!ctFrame) {
        if (ctFrame) CFRelease(ctFrame);
        if (path) CFRelease(path);
        if (ctFramesetter) CFRelease(ctFramesetter);
        return;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint pnt = [touch locationInView:self];
    CGPoint reversePoint = CGPointMake(pnt.x, self.frame.size.height-pnt.y);
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint* lineOrigins = malloc(sizeof(CGPoint)*CFArrayGetCount(lines));
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0,0), lineOrigins);
    NSInteger index = -1;
    for(CFIndex i = 0; i < CFArrayGetCount(lines); i++)
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint origin = lineOrigins[i];
        if (reversePoint.y > origin.y) {
            if (reversePoint.x - origin.x >= 0 ) {
                reversePoint.x -= origin.x;
                index = CTLineGetStringIndexForPosition(line, reversePoint);
                break;
            }
        }
    }
    BOOL isClickBlock = NO;
    if (index >= 0) {
        for (TBCityCoreTextAttribute *attr in self.parser.nodesArray) {
            if (index>=attr.attributeRange.location
                &&index<=(attr.attributeRange.location+attr.attributeRange.length)
                &&attr.href) {
                self.clickBlock(attr.href,self);
                isClickBlock = YES;
                break;
            }
        }
    }
    
    free(lineOrigins);
    if (ctFrame) CFRelease(ctFrame);
    if (path) CFRelease(path);
    if (ctFramesetter) CFRelease(ctFramesetter);
    if (!isClickBlock) {
        [super touchesBegan:touches withEvent:event];
    }
}

@end


@implementation NSString (NSStringAddition)

/**
 *  去掉xml的特殊字符
 *
 *  @return string
 */
- (NSString*)xmlEscapeString {
    return [NSString stringWithFormat:@"<![CDATA[%@]]>",self];
}

@end
