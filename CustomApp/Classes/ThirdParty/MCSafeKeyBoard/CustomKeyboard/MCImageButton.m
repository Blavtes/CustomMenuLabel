//
//  UIButton.m
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/25.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import "MCImageButton.h"

// 小btn的宽高
static CGFloat const kSmallBtnWidth = 30.0f;
static CGFloat const kSmallBtnHeigth = 50.0f;
// 大btn的宽高
static CGFloat const kBigBtnWight = 52.5f;
static CGFloat const kBigBtnHeigth = 80.5f;
// 小btn距离大btn的高度
static CGFloat const kHeightGap = 10.0f;



@interface MCImageButton ()

@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation MCImageButton


- (void)initImageName:(NSString*)imageName
{
    
    // 实际的小btn的宽高
    CGFloat btnWidth = self.frame.size.width;
    CGFloat btnHeight = self.frame.size.height;
    // 实际大btn的imageView宽高
    CGFloat bigImageWidth = (kBigBtnWight / kSmallBtnWidth) * btnWidth;
    CGFloat bigImageHeight = (kBigBtnHeigth / kSmallBtnHeigth) * btnHeight;
    // 实际的大btn的label宽高
    CGFloat labelWidth = kBigBtnWight ;
    CGFloat labelHeight = kBigBtnHeigth ;

    
    // 
    CGFloat bigImageX = 0;
    CGFloat bigImageY = 0;
    if (self.tag == 801 || self.tag == 851 ||
        self.tag == 861 || self.tag == 871) { // 靠左边的按钮
        
            bigImageX = 0;
            bigImageY = -bigImageHeight - kHeightGap;
    
    }else if (self.tag == 810 || self.tag == 860 || self.tag == 870) { // 靠右边的按钮
        
            bigImageX = btnWidth - bigImageWidth;
            bigImageY = -bigImageHeight - kHeightGap;
        
    } else { // 靠中间的按钮
            bigImageX = 0.5*(btnWidth - bigImageWidth);
            bigImageY = -bigImageHeight - kHeightGap;
//            self.label.font = [UIFont systemFontOfSize:50];
    }
    
    self.bigImageView.image = [UIImage imageNamed:imageName];
    self.bigImageView.frame = CGRectMake(bigImageX,bigImageY, bigImageWidth,bigImageHeight);
    self.label.frame = CGRectMake(0, 0, labelWidth, labelHeight);
    
}

/*
 *  显示大图
 */
- (void)showImageViewWithLabelName:(NSString *)labelName
{
    // 字母的显示内容
    self.label.text = labelName;
    self.bigImageView.hidden = NO;
}
/*
 *  隐藏大图
 */
- (void)hideImageViewWithLabelName:(NSString *)labelName
{
    // 字母的显示内容
    self.label.text = labelName;
    self.bigImageView.hidden = YES;
}

- (UILabel *)label
{
    if (!_label) {
        _label =  [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:40];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self.bigImageView addSubview:_label];
    }
    return _label;
}


- (UIImageView *)bigImageView
{
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        // 默认隐藏
        _bigImageView.hidden = YES;
        [self addSubview:_bigImageView];
    }
    return _bigImageView;
}
@end
