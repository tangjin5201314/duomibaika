//
//  NSString+LPAddtions.m
//  CashLoan
//
//  Created by lilianpeng on 2017/9/11.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "NSString+LPAddtions.h"
#import <MGBankCard/MGBankCard.h>

@implementation NSString (LPAddtions)

+ (NSString *)encodeBankCardNumberWithCardNumber2:(NSString *)cardNo{
    if (cardNo.length > 8) {
        if (cardNo.length % 4 == 0) {
            NSString *displayString = [NSString stringWithFormat:@"%@ **** **** %@",[cardNo substringToIndex:4],[cardNo substringFromIndex:cardNo.length - 4]];
            return  displayString;
        }else{
            NSString *displayString = [NSString stringWithFormat:@"%@ **** **** %@",[cardNo substringToIndex:4],[cardNo substringFromIndex:cardNo.length - 3]];
            return  displayString;
        }
    }
    return cardNo ?: @"";
}

+ (NSString *)encodeBankCardNumberWithCardNumber:(NSString *)cardNo {
    if (cardNo.length > 8) {
        if (cardNo.length % 4 == 0) {
            NSString *displayString = [NSString stringWithFormat:@"%@ **** **** **** %@",[cardNo substringToIndex:4],[cardNo substringFromIndex:cardNo.length - 4]];
            return  displayString;
        }else{
            NSString *displayString = [NSString stringWithFormat:@"%@ **** **** **** %@",[cardNo substringToIndex:4],[cardNo substringFromIndex:cardNo.length - 3]];
            return  displayString;
        }
    }
    return cardNo ?: @"";

    
}
//四位分割
+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>2&&i<mutableStr.length - 3) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    return bankNum;
    
}

+ (NSString *)getBankImageNameWithBankName:(NSString *)bankName {
  NSArray *_banNameArr = @[@"农业银行",@"北京银行",@"建设银行",@"光大银行",@"广发银行",@"工商银行",@"交通银行",@"平安银行",@"浦发银行",@"上海银行",@"兴业银行",@"邮政储蓄银行",@"招商银行",@"中国银行",@"中信银行",@"杭州银行",@"华夏银行"];//17家银行
   NSArray *_banImageArr = @[@"jk_icon_bank_abc",@"jk_icon_bank_bj",@"jk_icon_bank_ccb",@"jk_icon_bank_guagnda-",@"jk_icon_bank_guangfa",@"jk_icon_bank_icbc",@"jk_icon_bank_jiaotong",@"jk_icon_bank_pingan",@"jk_icon_bank_pufa",@"jk_icon_bank_sh",@"jk_icon_bank_xingye",@"jk_icon_bank_youzheng",@"jk_icon_bank_zhaoshang",@"jk_icon_bank_zhongguo",@"jk_icon_bank_zhongxin",@"jk_icon_bank_hangzhou",@"jk_icon_bank_huaxia"];//17个图片
    for (int i = 0; i < _banNameArr.count; i++) {
        NSString *bank = _banNameArr[i];
        if ([bank isEqualToString:bankName]) {
            return _banImageArr[i];
            
        }
    }
        return @"";
}

+ (BOOL)isSuportBankWithBankCode:(NSString *)bankCode{
    if (bankCode.length) {
        NSArray *_bankCodeArr = @[@"01030000",@"04031000",@"01050000",@"03030000",@"03060000",@"01020000",@"03010000",@"03070010",@"03100000",@"04012902",@"03090000",@"61000000",@"03080000",@"01040000",@"03020000",@"04233310",@"64233311",@"03040000", @"03050000"];//18家银行
        
        for (int i = 0; i < _bankCodeArr.count; i++) {
            NSString *bank = _bankCodeArr[i];
            if ([bank isEqualToString:bankCode]) {
                return YES;
            }
        }

    }
    return NO;
}

+ (NSString *)getBankImageNameWithBankName:(NSString *)bankName bankCode:(NSString *)bankCode{
    NSArray *_bankCodeArr = @[@"01030000",@"04031000",@"01050000",@"03030000",@"03060000",@"01020000",@"03010000",@"03070010",@"03100000",@"04012902",@"03090000",@"61000000",@"03080000",@"01040000",@"03020000",@"04233310",@"64233311",@"03040000", @"03050000"];//18家银行
    NSArray *_banNameArr = @[@"农业银行",@"北京银行",@"建设银行",@"光大银行",@"广发银行",@"工商银行",@"交通银行",@"平安银行",@"浦发银行",@"上海银行",@"兴业银行",@"邮政储蓄银行",@"招商银行",@"中国银行",@"中信银行",@"杭州银行",@"杭州商业银行",@"华夏银行", @"民生银行"];//18家银行

    NSArray *_banImageArr = @[@"jk_icon_bank_abc",@"jk_icon_bank_bj",@"jk_icon_bank_ccb",@"jk_icon_bank_guagnda-",@"jk_icon_bank_guangfa",@"jk_icon_bank_icbc",@"jk_icon_bank_jiaotong",@"jk_icon_bank_pingan",@"jk_icon_bank_pufa",@"jk_icon_bank_sh",@"jk_icon_bank_xingye",@"jk_icon_bank_youzheng",@"jk_icon_bank_zhaoshang",@"jk_icon_bank_zhongguo",@"jk_icon_bank_zhongxin",@"jk_icon_bank_hangzhou", @"jk_icon_bank_hangzhou",@"jk_icon_bank_huaxia", @"jk_icon_bank_minsheng"];//18个图片
    if (bankCode.length > 0) {
        for (int i = 0; i < _bankCodeArr.count; i++) {
            NSString *bank = _bankCodeArr[i];
            if ([bank isEqualToString:bankCode]) {
                return _banImageArr[i];
            }
        }
    }
    
    if (bankName.length > 0) {
        for (int i = 0; i < _banNameArr.count; i++) {
            NSString *bank = _banNameArr[i];
            if ([bank isEqualToString:bankName]) {
                //                [weakSelf.bankLogoImgV setImage:[UIImage imageNamed:_banImageArr[i]]];
                return _banImageArr[i];
                
                
            }
        }
    }
    

    return @"";
}


- (NSString *)LPTrimString {
    NSString* str = self;
    
    //1. 去掉首尾空格和换行符
    str = [str
           stringByTrimmingCharactersInSet:[NSCharacterSet
                                            whitespaceAndNewlineCharacterSet]];
    //2. 去掉所有空格和换行符
    str = [str
           stringByReplacingOccurrencesOfString:@"\r"
           withString:@""];
    str = [str
           stringByReplacingOccurrencesOfString:@"\n"
           withString:@""];
    str = [str
           stringByReplacingOccurrencesOfString:@" "
           withString:@""];
    str = [str
           stringByReplacingOccurrencesOfString:@"  "
           withString:@""];
    str = [str
           stringByReplacingOccurrencesOfString:@"-"
           withString:@""];

    return str;
}

//身份证隐藏
+(NSString *)getNewIDNumWitOldIDNum:(NSString *)IDNum
{
    NSMutableString *mutableStr;
    if (IDNum.length) {
        mutableStr = [NSMutableString stringWithString:IDNum];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i>3&&i<mutableStr.length - 4) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
    }
    return mutableStr;
}

//全名隐藏
+(NSString *)getDisplayNameWitName:(NSString *)name
{
    NSMutableString *mutableStr;
    if (name.length) {
        mutableStr = [NSMutableString stringWithString:name];
        for (int i = 0 ; i < mutableStr.length; i ++) {
            if (i<mutableStr.length - 1) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
    }
    return mutableStr;
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

//卡号获取银行
- (NSString *)getBankName {
  
    NSString *bankNumber = [self LPTrimString];
    /*
    NSString *path = [MGBankCardBundle BankCardPathForResource:@"Bank.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    __block NSString *bankId = @"--";
    __block NSString *cardName = @"--";
    __block NSString *cardType = @"--";
    __block NSString *bankName = @"--";
    
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *preNumber = dic[@"bankCode"];
        if([bankNumber hasPrefix:preNumber]){
            bankId = dic[@"bankId"];
            cardName = dic[@"cardName"];
            cardType = dic[@"cardType"];
            bankName = dic[@"bankName"];
        }
    }];
    
    NSArray *resultArr = @[bankId,cardName,cardType,bankName];
    NSLog(@"resultArr == %@",resultArr);
    return bankName;
     */
    return bankNumber;

}



@end
