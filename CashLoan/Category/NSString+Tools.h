//
//  NSString+Tools.h
//  CreditGroup
//
//  Created by JPlay on 14/10/21.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define HD_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font},@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define HD_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

@interface NSString (Tools)

+ (NSString *)currentDateTimeIntervalString;
+ (NSString *)currentDateString; //获取当前时间字符串
+ (NSString *)dateStringFrom1970:(long long)timeInterval; //获取当前时间字符串
+ (NSString *)dateStringFrom1970:(long long)timeInterval formatter:(NSString *)formatter; //获取当前时间字符串

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)fromFormatter;

//计算文本的size
-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing;

//sting转AttributedString
-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing;

+ (NSString *)dateString:(NSString *)dateString fromFormatter:(NSString *)fromFormatter toFormatter:(NSString *)toFormatter;

+ (NSString *)dateStringFromDate:(NSDate *)date formatter:(NSString *)formatter;
+ (NSString *)dateStringWithWeekdayOfDate:(NSDate *)date formatter:(NSString *)formatter;
+ (NSString *)dateStringWithWeekdayOfTimeInterval:(long long)timeInterval formatter:(NSString *)formatter;

@end
