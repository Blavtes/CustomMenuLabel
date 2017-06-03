//
//  CoreTextAttribute.h
//  CoreText
//
//  Created by SunX on 14-4-10.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface TBCityCoreTextAttribute : NSObject <NSCopying>

@property (nonatomic,copy)   NSString       *tag;              //标签名称
@property (nonatomic,copy)   NSString       *content;          //文字内容
@property (nonatomic,assign) NSUInteger     strLength;         //文字内容长度

//文字属性
@property (nonatomic,copy)   NSString       *href;             //超连接 有点击回调
@property (nonatomic,copy)   NSString       *color;            //颜色
@property (nonatomic,strong) UIColor*       textColor;         //颜色，当color为空时，会使用这个
@property (nonatomic,copy)   NSString       *font;             //字体名称
@property (nonatomic,assign) float          fontSize;          //字体大小
@property (nonatomic,assign) long           charSpace;         //字距
@property (nonatomic,assign) BOOL           bold;              //是否加粗， 和 b 标签一样的效果
@property (nonatomic,copy)   NSString       *unlineColor;      //下划线颜色

@property (nonatomic,copy)   NSString       *midLineColor;     //删除线颜色
@property (nonatomic,copy)   NSString       *midLineWidth;     //删除线大小

@property (nonatomic,assign) int            maxWidth;          //最大字数，2个英文字符=1个字数
@property (nonatomic,copy)   NSString       *bgColor;          //文字背景色

//图片特有
@property (nonatomic,copy)   NSString       *src;              //图片地址
@property (nonatomic,assign) float          width;             //图片宽度
@property (nonatomic,assign) float          height;            //图片高度
@property (nonatomic,assign) float          offsetY;            //图片偏移

//其他
@property (nonatomic,assign) NSRange        attributeRange;    //当前attribute的位置

/**
 *  初始化 attribute
 *
 *  @param attributeDict 数据字典
 *  @param tag           标签 a  u  i  img  b  font  =
 *
 *  @return
 */
-(id)initWithAttributeDict:(NSDictionary*)attributeDict
                       tag:(NSString*)tag;

/**
 *  建立CoreText NSMutableAttributedString
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)buildAttribute;

/**
 *  最大显示字数 一个中文当2个字符，maxWidth是10个中文的长度，20个英文字符
 *
 *  @param string
 *  @param maxWidth
 *
 *  @return 
 */
+(NSString*)maxWidthString:(NSString*)string width:(NSUInteger)maxWidth;

@end
