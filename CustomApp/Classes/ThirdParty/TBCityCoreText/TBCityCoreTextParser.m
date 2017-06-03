//
//  TBCityCoreTextPaser.m
//  iCoupon
//
//  Created by SunX on 14/11/20.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import "TBCityCoreTextParser.h"

@interface TBCityCoreTextParser () <NSXMLParserDelegate>


@property (nonatomic,strong) TBCityCoreTextAttribute*       nodeAttrbute;       //当前节点
@property (nonatomic,strong) NSString*                      nodeString;         //当前节点的string，会出现多次获取的情况
@property (nonatomic,strong) NSXMLParser*                   parser;

@end

@implementation TBCityCoreTextParser

-(void)dealloc {
    [self cancelParser];
}

- (void)cancelParser {
    _parser.delegate = nil;
    [_parser abortParsing];
    _parser = nil;
}

-(void)buildAttributedString:(NSString*)string {
    if ([string length]<1) {
        return ;
    }
    [self cancelParser];
    self.nodesArray = [NSMutableArray array];
    //前后添加一个特殊标签，用于解析里面的数据
    NSString* document = [NSString stringWithFormat:@"<xhtml>%@</xhtml>", string];
    NSData* data = [document dataUsingEncoding:string.fastestEncoding];
    self.parser = [[NSXMLParser alloc] initWithData:data];
    self.parser.delegate = self;
    [self.parser parse];
}

+(TBCityCoreTextParser*)buildAttributedString:(NSString*)string {
    TBCityCoreTextParser *parser = [TBCityCoreTextParser new];
    [parser buildAttributedString:string];
    return parser;
}

#pragma mark NSXMLParserDelegate
//解析标签开始
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    NSString *tag = [elementName lowercaseString];
    if (![tag isEqualToString:@"xhtml"]) {
        if ([tag isEqualToString:@"img"]
            || attributeDict[@"bgColor"]
            || attributeDict[@"midLineColor"]) {
            self.needDrawExtraView = YES;
        }
        self.nodeAttrbute = nil;
        self.nodeString = @"";
        self.nodeAttrbute = [[TBCityCoreTextAttribute alloc]
                             initWithAttributeDict:attributeDict
                             tag:tag];
        self.nodeAttrbute.textColor = self.textColor;
        if (!self.nodeAttrbute.font&&self.font) {
            self.nodeAttrbute.font = self.font.fontName;
            if (self.nodeAttrbute.fontSize<1) {
                self.nodeAttrbute.fontSize = self.font.pointSize;
            }
        }
    }
}

//获取到标签内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    if (!self.nodeAttrbute) {
        self.nodeAttrbute = [[TBCityCoreTextAttribute alloc]
                             initWithAttributeDict:nil
                             tag:@"other"];
        self.nodeAttrbute.textColor = self.textColor;
        if (!self.nodeAttrbute.font&&self.font) {
            self.nodeAttrbute.font = self.font.fontName;
            if (self.nodeAttrbute.fontSize<1) {
                self.nodeAttrbute.fontSize = self.font.pointSize;
            }
        }
        self.nodeAttrbute.content = string;
        [self.nodesArray addObject:[self.nodeAttrbute copy]];
        self.nodeAttrbute = nil;
        self.nodeString = @"";
    }
    else {
        self.nodeString =  [self.nodeString stringByAppendingString:string];
    }
}

//单个element结束
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSString* tag = [elementName lowercaseString];
    if ([tag isEqualToString:@"xhtml"]) {
        //构造界面
        [self contructAttribute];
    }
    else {
        if ([self.nodeString length]>0||[self.nodeAttrbute.tag isEqualToString:@"img"]) {
            self.nodeAttrbute.content = self.nodeString;
            //保存节点
            [self.nodesArray addObject:[self.nodeAttrbute copy]];
        }
        self.nodeAttrbute = nil;
        self.nodeString = @"";
    }
}

//构造界面
-(void)contructAttribute {
    if (self.nodesArray) {
        self.attributedString = nil;
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
//        //加入1像素的图片是为了处理最后字符串的点击bug
        TBCityCoreTextAttribute *lastnode = [[TBCityCoreTextAttribute alloc]
                                                 initWithAttributeDict:@{@"src":@"",
                                                                         @"width":@"1",
                                                                         @"height":@"1",
                                                                         }
                                                 
                                                 tag:@"img"];
        [self.nodesArray addObject:lastnode];
        
        int index = 0;
        self.canTouchBlock = NO;
        for (TBCityCoreTextAttribute *attr in self.nodesArray) {
            if (attr.href) {
                self.canTouchBlock = YES;
            }
            //解析attribute并加入contentStr结尾
            [self.attributedString insertAttributedString:[attr buildAttribute] atIndex:index];
            attr.attributeRange = NSMakeRange(index,[attr strLength]);
            index +=  [attr strLength];
        }
        [self globalSettings];
    }
    [self cancelParser];
}

//文字全局配置项
-(void)globalSettings  {
    //换行模式，设置段落属性
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = self.lineBreak;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting lineSpaceSetting;
    lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceSetting.value = &_lineSpace;
    lineSpaceSetting.valueSize = sizeof(CGFloat);
    

    //指定为对齐属性
    CTTextAlignment alignment = self.textAlign;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,
        lineSpaceSetting,
        alignmentStyle
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    if(style) CFRelease(style);
    
    [self.attributedString addAttributes:attributes range:NSMakeRange(0, [self.attributedString length])];
}


@end
