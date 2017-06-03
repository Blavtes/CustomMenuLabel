//
//  CustomSecondRateButton.h
//  GjFax
//
//  Created by yangyong on 2017/2/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIButtonClickHandle)(UIButton *view);

@interface CustomSecondRateButton : UIButton

@property (nonatomic, copy) UIButtonClickHandle clickHandle;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(BOOL)cornerRadius;

@end
