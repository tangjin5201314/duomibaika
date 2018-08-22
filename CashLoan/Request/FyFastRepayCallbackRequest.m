//
//  FyFastRepayCallbackRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFastRepayCallbackRequest.h"

@implementation FyFastRepayCallbackRequest

- (NSString *)urlPath{
    return URL_FASTREPAYCALLBACK;
}

- (NSDictionary *)params{
    return @{@"borrowId":self.borrowID, @"resultPay":self.resultPay, @"orderNo":self.orderNo, @"returnParam":self.returnParam};
}

@end
