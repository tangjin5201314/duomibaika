//
//  FyLoanUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/12/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyLoanPremiseModelV2.h"


@interface FyLoanUtil : FyBaseRequest

+ (void)applyIfNeededWithModel:(FyLoanPremiseModelV2 *)model fromViewController:(UIViewController *)viewController;
+ (void)showNoDataMessageFromViewController:(UIViewController *)viewController;
@end
