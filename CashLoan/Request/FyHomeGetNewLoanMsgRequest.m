//
//  FyHomeGetNewLoanMsgRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeGetNewLoanMsgRequest.h"
#import "FyLoanMsgModel.h"

@implementation FyHomeGetNewLoanMsgRequest

- (NSString *)urlPath{
    return URLPATH_GETNEWLOANMSG;
}

- (Class)objectClass{
    return [FyLoanMsgListModel class];
}

@end
