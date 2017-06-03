//
//  CustomImgBgLabel.m
//  HX_GJS
//
//  Created by litao on 16/3/5.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "CustomImgBgLabel.h"

@interface CustomImgBgLabel () {
    //
}

//  背景图片
@property (strong, nonatomic) UIImageView *bgImgView;

@end

@implementation CustomImgBgLabel
#pragma mark - lazyLoad - setter - getter

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [[UILabel alloc] init];
    }
    
    return _textLb;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
#pragma mark - - bgImgView
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_bgImgView];
        
#pragma mark - - label
        self.textLb.text = @"0";
        self.textLb.textColor = COMMON_WHITE_COLOR;
        self.textLb.backgroundColor = [UIColor clearColor];
        self.textLb.textAlignment = NSTextAlignmentCenter;
        self.textLb.font = [UIFont boldSystemFontOfSize:kCommonFontSizeTitle_18];
        [self addSubview:self.textLb];
    }
    
    return self;
}

+ (instancetype)initWithImage:(UIImage *)image andPosition:(CGPoint)position
{
    CustomImgBgLabel *imgBgLb = [[CustomImgBgLabel alloc] initWithFrame:CGRectMake(position.x, position.y, image.size.width, image.size.height)];
    
    imgBgLb.bgImgView.image = image;
    
    imgBgLb.textLb.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    return imgBgLb;
}

@end
