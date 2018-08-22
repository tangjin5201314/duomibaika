//
//  IDCardModel.m
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/5/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "IDCardModel.h"

@implementation BackModel
@end

@implementation BirthdayModel
@end

@implementation LegalityModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"IDPhoto":@"ID Photo",
             @"TemporaryIDPhoto":@"Temporary ID Photo"
             };
}
@end


@implementation FrontModel
@end

@implementation IDCardModel
@end

