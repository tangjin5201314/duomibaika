//
//  NSString+Validation.m
//  LoginViewDemo
//
//  Created by erongdu_cxk on 16/3/14.
//  Copyright © 2016年 erongdu. All rights reserved.
//

#import "NSString+Validation.h"

//手机号码验证13开头
#define kValidationPhone_11 @"^[0-9]{11}$"

#define kValidationPhone @"^((1[345678][0-9])|(14[57])|(17[0678]))\\d{8}$"
//邮箱验证
#define kValidationMail @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
//身份证验证
#define kValidationIDCard @"^\\d{8,18}|[0-9x]{8,18}|[0-9X]{8,18}?$"
//IP地址验证
#define kValidationIP @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))"
//日期中的月验证(01~09和1~12)
#define kValidationMonth @"^(0?[1-9]|1[0-2])$"
//日期中的日验证(01~09和1~31)
#define kValidationDay @"^((0?[1-9])|((1|2)[0-9])|30|31)$"
//密码验证
#define kValidationPassword @"^(?=.*\\d)(?=.*[a-zA-Z]).{6,16}$"
//#define kValidationPassword @"^(?![^a-zA-Z]+$)(?!\\d+$).{6,16}$"

//用户名验证（包含数字加字母）
//#define kValidationUserName @"^[a-zA-Z0-9\u4e00-\u9fa5]+$"
#define kValidationUserName @"^(?![^a-zA-Z]+$)(?!\\d+$).{4,16}$"



//银行卡简单验证 16位和19位
#define kValidationBankCard @"^\\d{16}|\\d{19}$"
//验证码纯数字4位
#define kValidationPhoneCode @"^\\d{4}"
//中文验证
#define kValidationChinese @"^[\u4E00-\u9FA5]*$"
//验证字母和数字
#define kValidationLetterOrNumber @"^[a-zA-Z0-9]{4,16}$"
//验证纯数字
#define kValidationTypeNumber @"^[0-9]*$"



//验证码纯数字6位
#define kValidationNameNumber @"^\\d{4,16}"
#define kValidationNameLetter @"\\w{4,16}"

@implementation NSString (Validation)

- (BOOL)validationType:(ValidationType)validationType
{
    return [self validationExpression:[self expressionByValidationType:validationType]];
}

- (BOOL)validationExpression:(NSString *)expression
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",expression];
    return [predicate evaluateWithObject:self];
}


- (BOOL)isPrueInt
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    int intVal;
    return [scanner scanInt:&intVal] && [scanner isAtEnd];
}

- (BOOL)isPrueFloat
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float floatVal;
    return [scanner scanFloat:&floatVal] && [scanner isAtEnd];
}

- (BOOL)isPrueIntOrFloat
{
    return [self isPrueFloat]||[self isPrueInt];
}

/**
 *  根据类型返回对应的正则表达式
 *
 *  @param type 待验证的正则表达式
 *
 *  @return 正则表达式
 */
- (NSString *)expressionByValidationType:(ValidationType)type
{
    NSString *str;
    switch (type) {
        case ValidationTypePhone:
            str = kValidationPhone;
            break;
        case ValidationTypeMail:
            str = kValidationMail;
            break;
        case ValidationTypeIDCard:
            str = kValidationIDCard;
            break;
        case ValidationTypeIP:
            str = kValidationIP;
            break;
        case ValidationTypeMonth:
            str = kValidationMonth;
            break;
        case ValidationTypeDay:
            str = kValidationDay;
            break;
        case ValidationTypePassword:
            str = kValidationPassword;
            break;
        case ValidationTypeUserName:
            str = kValidationUserName;
            break;
        case ValidationTypeBankCard:
            str = kValidationBankCard;
            break;
        case ValidationTypePhoneCode:
            str = kValidationPhoneCode;
            break;
        case ValidationTypeChinese:
            str = kValidationChinese;
            break;
        case ValidationTypeLetterOrNumber:
            str = kValidationLetterOrNumber;
            break;
        case ValidationTypeNumber:
            str = kValidationTypeNumber;
            break;
        case ValidationTypeNameNumber:
            str = kValidationNameNumber;
            break;
        case ValidationTypeNameStr:
            str = kValidationNameLetter;
            break;
        case ValidationTypePhone11:
            str = kValidationPhone_11;
            break;

        default:
            str = @"";
            break;
    }
    return str;
}


- (BOOL)isValidIDCard{
    return [self validationType:ValidationTypeIDCard];
}


@end
