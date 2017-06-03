//
//  UIImage+Extension.h
//  GJS_Proj
//
//  Created by 张瑞 on 15/4/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名自动加载适配iOS6\7的图片
 */
+ (instancetype)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (instancetype)resizedImage:(NSString *)name;

/**
 *  返回一张能自由拉伸的图片
 *
 *  @param name      图片名
 *  @param leftRatio 左边有多少比例不需要拉伸(0~1)
 *  @param topRatio  顶部有多少比例不需要拉伸(0~1)
 */
+ (instancetype)resizedImage:(NSString *)name leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio;

/**
 *  自定义缩放
 *
 *  @param size
 *
 *  @return
 */
- (instancetype)scaleToSize:(CGSize)size;

/**
 *  去掉图片的 白色背景 过滤240 ~ 250
 *
 *  @param image image description
 *
 *  @return return value description
 */
+ (instancetype)maskImage:(UIImage *)image;
@end
