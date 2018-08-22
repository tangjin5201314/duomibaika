//
//  NSString+fyAdd.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SAFESTRING(str)  ((((str)!=nil)&&![(str) isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"%@",(str)]:@"")

@interface NSString (fyAdd)

- (NSString *)numberString;
- (NSString *)safeContactsString;


@end
