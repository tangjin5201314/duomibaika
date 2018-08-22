//
//  NSString+fyAdd.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "NSString+fyAdd.h"

@implementation NSString (fyAdd)


- (NSString *)numberString{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    NSArray *array = [NSString matchString:str toRegexString:@"[0-9]+"];
    return [array componentsJoinedByString:@""];
}

+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //match: 所有匹配到的字符,根据() 包含级
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}

//安全的通讯录保存
- (NSString *)safeContactsString{
    NSString *str = self;
    if ([str isNotBlank]) {
        if ([str isEqualToString:@","] ||[str isEqualToString:@"，"]) {
            return @"未知";
        }else if ([str containsString:@","]) {
            return [str stringByReplacingOccurrencesOfString:@"," withString:@""];
        }else if ([str containsString:@"，"]) {
            return [str stringByReplacingOccurrencesOfString:@"，" withString:@""];
        }else{
            return str;
        }
    }else{
        return @"未知";
    }
}


- (BOOL)containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}


@end
