//
//  AuthDictListModel.m
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "AuthDictListModel.h"

@implementation AuthDictListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contactRelationList": [AuthDictModel class], @"kinsfolkRelationList": [AuthDictModel class], @"educationalStateList": [AuthDictModel class], @"liveTimeList": [AuthDictModel class], @"maritalStateList": [AuthDictModel class], @"salaryRangeList": [AuthDictModel class], @"workTimeList": [AuthDictModel class], @"bankTypeList": [AuthDictModel class], @"workList": [AuthDictModel class], @"loanPurposeList":[AuthDictModel class]};
}


@end
