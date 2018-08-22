//
//  NSString+fyUrl.m
//  CashLoan
//
//  Created by fyhy on 2017/11/1.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "NSString+fyUrl.h"

@implementation NSString (fyUrl)

- (NSString *)fy_UrlString{
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"`%^{}\"[]|\\<> "].invertedSet;
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
