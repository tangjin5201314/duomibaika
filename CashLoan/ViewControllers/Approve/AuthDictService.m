//
//  AuthDictService.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "AuthDictService.h"
#import "FyApproveStepDictRequest.h"

@implementation AuthDictService

+(void)requestDictWithType:(AuthDictType)type resultModel:(void (^)(AuthDictListModel *, FyResponse *))result{
    NSString *typeStr = @"";
    switch (type) {
            
        case AuthDictTypeContacts:
        {
            typeStr = @"KINSFOLK_RELATION,CONTACT_RELATION";
        }
            break;
        case AuthDictTypeLiveTime:
        {
            typeStr = @"LIVE_TIME";
        }
            break;
        case AuthDictTypeEducational:
        {
            typeStr = @"EDUCATIONAL_STATE";
        }
            break;
        case AuthDictTypeBankList:
        {
            typeStr = @"BANK_TYPE";
        }
            break;
        case AuthDictTypeWorkTime:
        {
            typeStr = @"WORK_TIME";
        }
            break;
        case AuthDictTypePersonInfo:
        {
            typeStr = @"EDUCATIONAL_STATE,MARITAL_STATE";
        }
            break;
        case AuthDictTypeWorkInfo:
        {
            typeStr = @"WORK,WORK_TIME,SALARY_RANGE,WORK";
        }
            break;
        case AuthDictTypeTrueName:
        {
            typeStr = @"EDUCATIONAL_STATE,MARITAL_STATE,WORK";
        }
            break;

        case AuthDictTypeLoanUsage:
        {
            typeStr = @"LOAN_PURPOSE";
        }
            break;
        default:
            break;
    }
    
    FyApproveStepDictRequest *task = [[FyApproveStepDictRequest alloc] init];
    task.type = typeStr;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        result(model,error);
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        result(nil,error);
    }];
}


@end
