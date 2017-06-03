//
//  SXCoreTextManager.h
//  SXFramework
//
//  Created by SunX on 15/1/31.
//  Copyright (c) 2015年 SunX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCityCoreTextManager : NSObject

/**
 *  指定宽度【计算】某个文本的实际高度，
 *  这个方法不会触发渲染
 *  @param width  指定文本的宽度
 *  @param string xml内容
 *  @param font   默认的字体
 *  @return CGFloat
 */
+(CGFloat)getContentHeightWithWidth:(CGFloat)width
                           withText:(NSString*)text
                           withFont:(UIFont*)font;

/**
 *  获取某个文本的宽高
 *
 *  @param string   xml内容
 *  @param font     UIFont
 *  @param maxWidth 最大宽度
 *  @param lineSpace 行间距
 *
 *  @return CGSize
 */
+ (CGSize)getContentSizeWithText:(NSString*)string
                        withFont:(UIFont*)font
                        maxWidth:(CGFloat)maxWidth
                       lineSpace:(CGFloat)lineSpace;

@end
