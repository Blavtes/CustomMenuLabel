//
//  TBCityCoreTextPaser.h
//  iCoupon
//
//  Created by SunX on 14/11/20.
//  Copyright (c) 2014年 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBCityCoreTextAttribute.h"

@interface TBCityCoreTextParser : NSObject 

/**
 *  行距，行与行之间的间隔，默认是0
 */
@property (nonatomic, assign) CGFloat                        lineSpace;
/**
 *  CTLineBreakMode 换行模式
 kCTLineBreakByWordWrapping = 0,        //出现在单词边界时起作用，如果该单词不在能在一行里显示时，整体换行。此为段的默认值。
 kCTLineBreakByCharWrapping = 1,        //当一行中最后一个位置的大小不能容纳一个字符时，才进行换行。
 kCTLineBreakByClipping = 2,            //超出画布边缘部份将被截除。
 kCTLineBreakByTruncatingHead = 3,      //截除前面部份，只保留后面一行的数据。前部份以...代替。
 kCTLineBreakByTruncatingTail = 4,      //截除后面部份，只保留前面一行的数据，后部份以...代替。
 kCTLineBreakByTruncatingMiddle = 5     //在一行中显示段文字的前面和后面文字，中间文字使用...代替。
 */
@property (nonatomic, assign) CTLineBreakMode                lineBreak;
/**
 *  CTTextAlignment
 *  注：有图片的coreText样式会错
 */
@property (nonatomic, assign) CTTextAlignment                textAlign;
/**
 *  Label的默认font
 */
@property (nonatomic,strong) UIFont*                        font;
/**
 *  Label默认的颜色
 */
@property (nonatomic,strong) UIColor*                       textColor;
/**
 *  是否需要draw其他特殊的view  img 背景色等
 */
@property (nonatomic,assign) BOOL                           needDrawExtraView;
/**
 *  CoreText的内容
 */
@property (nonatomic,strong) NSMutableAttributedString*     attributedString;
/**
 *  节点数组
 */
@property (nonatomic,strong) NSMutableArray*                nodesArray;
/**
 *  是否有点击回调事件，如果存在href，YES，否则不会触发TBCityCoreTextLabel的touch回调
 */
@property (nonatomic,assign) BOOL                           canTouchBlock;

/**
 *  创建AttributedString
 */
-(void)buildAttributedString:(NSString*)string;
/**
 *  创建AttributedString
 */
+(TBCityCoreTextParser*)buildAttributedString:(NSString*)string;

@end
