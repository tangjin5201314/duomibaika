//
//  NSString+fyBase64.h
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (fyBase64)

- (NSString *)base64String;
+ (NSString *)convertToJSONData:(id)infoDict;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)md5WithUpperString:(NSString *)str;
@end
