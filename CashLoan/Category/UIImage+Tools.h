//
//  UIImage+Tools.h
//  CreditGroup
//
//  Created by JPlay on 14-2-21.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)


//图片压缩
+ (UIImage*)resizeWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//用颜色一张纯色的画图
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//根据屏幕大小压缩一张图片
+ (UIImage *)resizeWithImage:(UIImage *)image;

//根据屏幕大小压缩一个数组的图片
+ (NSArray *)resizeWithImageArray:(NSArray *)array;

// 图片旋转方法
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)resizeWithImage:(UIImage *)image scale:(CGFloat)scale min:(CGFloat)min;
//创建渐变色图片
//+ (UIImage*)imageFromColors:(NSArray*)colors size:(CGSize)size;
@end
