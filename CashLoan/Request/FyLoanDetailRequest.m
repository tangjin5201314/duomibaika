//
//  FyLoanDetailRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanDetailRequest.h"
#import "FyOrderDetailModel.h"

@implementation FyLoanDetailRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ORDER_GETORDERDETIALS;
}

- (NSDictionary *)params{ //请求参数
    return @{@"orderId":self.borrowID};
}

- (Class)objectClass{
    return [FyOrderDetailModel class];
}


@end
