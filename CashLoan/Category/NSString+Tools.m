//
//  NSString+Tools.m
//  CreditGroup
//
//  Created by JPlay on 14/10/21.
//  Copyright (c) 2014年 JPlay. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributedText = [self attributedStringFromStingWithFont:font
                                                                        withLineSpacing:lineSpacing];
    CGSize textSize = [attributedText boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
    return textSize;
}

+ (NSString *)currentDateString{
    NSDate *date = [NSDate date];
    
    return [self dateStringFromDate:date formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)currentDateTimeIntervalString{
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%lld", (long long)([date timeIntervalSince1970]*1000)];//到毫秒
}


+ (NSString *)dateStringFrom1970:(long long)timeInterval{
    return [self dateStringFrom1970:timeInterval formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)dateStringFrom1970:(long long)timeInterval formatter:(NSString *)formatter{ //获取当前时间字符串
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return [self dateStringFromDate:date formatter:formatter];
}

+ (NSString *)dateStringFromDate:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];

}

+ (NSString *)dateString:(NSString *)dateString fromFormatter:(NSString *)fromFormatter toFormatter:(NSString *)toFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = fromFormatter;
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (!date) return nil;
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    dateFormatter2.dateFormat = toFormatter;
    
    
    return [dateFormatter2 stringFromDate:date];
    
}

+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)fromFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = fromFormatter;
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)dateStringWithWeekdayOfDate:(NSDate *)date formatter:(NSString *)formatter{
    NSString *dateString = [self dateStringFromDate:date formatter:formatter];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday fromDate:date];
    
    NSString *weekName;
    
    switch (components.weekday) {
        case 1:
            weekName = @"星期日";
            break;
        case 2:
            weekName = @"星期一";
            break;
        case 3:
            weekName = @"星期二";
            break;
        case 4:
            weekName = @"星期三";
            break;

        case 5:
            weekName = @"星期四";
            break;
        case 6:
            weekName = @"星期五";
            break;

        case 7:
            weekName = @"星期六";

            break;

        default:
            break;
    }
    
    
    
    dateString = [dateString stringByAppendingString:@" "];
    dateString = [dateString stringByAppendingString:weekName];

    return dateString;
}

+ (NSString *)dateStringWithWeekdayOfTimeInterval:(long long)timeInterval formatter:(NSString *)formatter{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    return [self dateStringWithWeekdayOfDate:date formatter:formatter];
}

@end
