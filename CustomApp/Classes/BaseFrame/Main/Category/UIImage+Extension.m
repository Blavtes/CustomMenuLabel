//
//  UIImage+Extension.m
//  GJS_Proj
//
//  Created by 张瑞 on 15/4/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  加载图片时适配ios7
 *
 *  @param name 图片文字
 *
 *  @return 返回image
 */
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    //  处理iOS7的情况
    if (IOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage imageNamed:newName];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:name];
        if (image == nil) {
        }
    }
    return image;
}

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name leftRatio:0.5 topRatio:0.5];
}

/**
 *  返回一张能自由拉伸的图片
 *
 *  @param name      图片名
 *  @param leftRatio 左边有多少比例不需要拉伸(0~1)
 *  @param topRatio  顶部有多少比例不需要拉伸(0~1)
 */
+ (UIImage *)resizedImage:(NSString *)name leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio
{
    UIImage *image = [self imageWithName:name];
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

/**
 *  自定义缩放
 *
 *  @param size
 *
 *  @return
 */
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


/**
 *  去掉图片白色背景
 *
 *  @param image
 *
 *  @return image
 */
+ (UIImage *)maskImage:(UIImage *)image
{
    //过滤数值
    const CGFloat colorMasking[6] = {240.0, 255.0, 240.0, 255.0, 240.0, 255.0};
    CGImageRef sourceImage = image.CGImage;
    
    //去掉alpha通道
    CGImageAlphaInfo info = CGImageGetAlphaInfo(sourceImage);
    if (info != kCGImageAlphaNone) {
        NSData *buffer = UIImageJPEGRepresentation(image, 1);
        UIImage *newImage = [UIImage imageWithData:buffer];
        sourceImage = newImage.CGImage;
    }
    //过滤图片源数据
    CGImageRef masked = CGImageCreateWithMaskingColors(sourceImage, colorMasking);
    UIImage *retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
@end
