//
//  CustomFirstRateButton.h
//  GjFax
//
//  Created by yangyong on 2017/2/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIButtonClickHandle)(UIButton *view);

@interface CustomFirstRateButton : UIButton

@property (nonatomic, copy) UIButtonClickHandle clickHandle;

@property (nonatomic, assign) BOOL isResetState;
/**
 * title 显示的标题
 * cornerRadius 是否使用圆角
 *
 * cornerRadius 圆角时 状态为 disable 为NO 背景色为未激活状态
 * cornerRadius 不为圆角时，按钮状态 enable 为NO 按钮背景颜色为灰色 不可点击
 *
 *
**/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title cornerRadius:(BOOL)cornerRadius;

@end
