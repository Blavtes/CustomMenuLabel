//
//  CoreTextView.h
//  CoreText
//
//  Created by SunX on 14-4-9.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

/**
 *  特别提醒，此Label会额外增加3个像素高度，目的是避免富文本有图片的时候高度不对的问题，
 *  如需精确的高度，请获取textHeight
 */

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "TBCityCoreTextAttribute.h"
#import "TBCityCoreTextParser.h"
#import "TBCityColorManager.h"
#import "TBCityCoreTextManager.h"

@class TBCityCoreTextLabel;
/**
 *  文本点击回调block
 *
 *  @param href  点击的地址
 *  @param label 点击的label
 */
typedef void(^CoreTextClickBlock) (NSString *href,TBCityCoreTextLabel* label);
typedef void(^CoreTextDrawFinishBlock) (TBCityCoreTextLabel* label);

@interface TBCityCoreTextLabel : UIView

/**
 *  是否把text画出来
 */
@property (nonatomic,assign) BOOL                           drawText;
/**
 *  text
 */
@property (nonatomic,copy)   NSString*                      text;
/**
 *  parser，xml解析器
 */
@property (nonatomic,strong) TBCityCoreTextParser*          parser;
/**
 *  行距，行与行之间的间隔，默认是0
 */
@property (nonatomic,assign) CGFloat                        lineSpace;
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
 *  内容的实际高度 此属性获取实际渲染高度
 */
@property (nonatomic,assign) CGFloat                        textHeight;
/**
 *  内容的实际宽度 此属性获取实际渲染宽度
 */
@property (nonatomic,assign) CGFloat                        textWidth;
/**
 *  Label的默认font
 */
@property (nonatomic,strong) UIFont*                        font;
/**
 *  Label默认的颜色
 */
@property (nonatomic,strong) UIColor*                       textColor;
/**
 *  点击回调，需要设置userInteractionEnabled = YES
 */
@property (nonatomic,copy)   CoreTextClickBlock             clickBlock;
/**
 *  drawRect完成回调
 */
@property (nonatomic,copy)   CoreTextDrawFinishBlock        drawFinishBlock;

/**
 *  为了支持IconFont,以及传入UIImage
 *  demo:  
    TBCityCoreTextLabel *core = [TBCityCoreTextLabel alloc] initWithFrame:xxxx];
    core.imageDic = @{@"iconfontImage":[UIImage iconfont:xxx]};
    core.text = "<img src='iconfontImage' width='12' height='12'/> 这里是传入UImage demo";
 *
 */
@property (nonatomic,strong) NSDictionary*                  imageDic;

/**
 *  CoreText的attributedString，只读
 */
@property (nonatomic,readonly)   NSMutableAttributedString*     attributedString;

/**
 *  通过parser更新界面，省略初始化时间
 */
-(void)attributedStringWithParser:(TBCityCoreTextParser*)parser;

/**
 *  渲染完成回调
 */
- (void)drawWithFinishBlock:(CoreTextDrawFinishBlock)finishBlock;
/**
 *  点击回调
 */
- (void)clickWithBlock:(CoreTextClickBlock)clickBlock;
/**
 *  初始化
 *
 *  @param frame
 *  @param handle 接受点击回调
 *
 *  @return
 */
-(id)initWithFrame:(CGRect)frame
        withHandle:(CoreTextClickBlock)handle;

/**
 *  初始化
 *
 *  @param frame
 *  @param text
 *
 *  @return
 */
-(id)initWithFrame:(CGRect)frame
          withText:(NSString*)text;

+ (instancetype)showInView:(UIView*)view
                 withFrame:(CGRect)frame
                  withText:(NSString*)text
                withHandle:(CoreTextClickBlock)handle;

@end


@interface NSString (NSStringAddition)

/**
 *  去掉xml的特殊字符
 *
 *  @return string
 */
-(NSString*)xmlEscapeString;

@end


