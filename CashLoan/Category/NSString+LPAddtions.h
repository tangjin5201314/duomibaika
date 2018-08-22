//
//  NSString+LPAddtions.h
//  CashLoan
//
//  Created by lilianpeng on 2017/9/11.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LPAddtions)

+ (NSString *)encodeBankCardNumberWithCardNumber2:(NSString *)cardNo;
+ (NSString *)encodeBankCardNumberWithCardNumber:(NSString *)cardNo;
+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;
+ (NSString *)getBankImageNameWithBankName:(NSString *)bankName;
+ (NSString *)getBankImageNameWithBankName:(NSString *)bankName bankCode:(NSString *)bankCode;
/**
 去掉空字符

 @return 格式化后的字符串
 */
- (NSString *)LPTrimString;
//身份证隐藏
+(NSString *)getNewIDNumWitOldIDNum:(NSString *)IDNum;
//全名隐藏
+(NSString *)getDisplayNameWitName:(NSString *)name;
//安全的通讯录保存
- (NSString *)safeContactsString;
//卡号获取银行
- (NSString *)getBankName;
+ (BOOL)isSuportBankWithBankCode:(NSString *)bankCode;

@end
