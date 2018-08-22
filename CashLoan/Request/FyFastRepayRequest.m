//
//  FyFastRepayRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFastRepayRequest.h"

@implementation FyFastRepayRequest

- (NSString *)urlPath{
    return URL_FASTREPAY;
}

- (NSDictionary *)params{
    return @{@"borrowId":self.borrowID};
}

@end
