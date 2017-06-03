//
//  CustomImgBgLabel.h
//  HX_GJS
//
//  Created by litao on 16/3/5.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImgBgLabel : UIView

@property (strong, nonatomic) UILabel *textLb;

+ (instancetype)initWithImage:(UIImage *)image andPosition:(CGPoint)position;

@end
