//
//  UIImage+Tools.m
//  CreditGroup
//
//  Created by JPlay on 14-2-21.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

+(UIImage*)resizeWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)resizeWithImage:(UIImage *)image{
    
    float height = image.size.height;
    float width = image.size.width;
    UIImage *resizeImage;
    
    float screenHeight = [[UIScreen mainScreen] bounds].size.height *2;
    float screenWidth = [[UIScreen mainScreen] bounds].size.width *2;
    
    
    if (height > screenHeight && width > screenWidth) {
        if (height/width >= screenHeight/screenWidth) {
            
            resizeImage =
            [UIImage resizeWithImage:image
                        scaledToSize:CGSizeMake(screenWidth, screenWidth/width*height)];
            
            
        }else{
            resizeImage =
            [UIImage resizeWithImage:image
                        scaledToSize:CGSizeMake(screenHeight/height*width, screenHeight)];
        }
    }else{
        resizeImage = image;
    }
    
    
    return resizeImage;
    
}


+(NSArray *)resizeWithImageArray:(NSArray *)array{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (UIImage *image in array) {
        
        [returnArray addObject:[UIImage resizeWithImage:image]];
    }
    return [NSArray arrayWithArray:returnArray];
    
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+ (UIImage *)resizeWithImage:(UIImage *)image scale:(CGFloat)scale min:(CGFloat)min{
    float height = image.size.height;
    float width = image.size.width;
    UIImage *resizeImage;
    
    float screenHeight = height * scale;
    float screenWidth =width * scale;
    
    //至少min
    if (min > 0) {
        if (screenWidth < min && screenHeight < min) {
            if (screenHeight > screenWidth) {
                CGFloat s = min/screenHeight;
                screenHeight = min;
                screenWidth = screenWidth * s;
            }else{
                CGFloat s = min/screenWidth;
                screenWidth = min;
                screenHeight = screenHeight * s;
            }
        }
        
    }
    
    if (height > screenHeight && width > screenWidth) {
        if (height/width >= screenHeight/screenWidth) {
            
            resizeImage =
            [UIImage resizeWithImage:image
                        scaledToSize:CGSizeMake(screenWidth, screenWidth/width*height)];
            
            
        }else{
            resizeImage =
            [UIImage resizeWithImage:image
                        scaledToSize:CGSizeMake(screenHeight/height*width, screenHeight)];
        }
    }else{
        resizeImage = image;
    }
    
    
    return resizeImage;
    
}


@end
