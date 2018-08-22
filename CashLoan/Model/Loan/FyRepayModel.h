//
//  FyRepayModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FyRepayStateInRefund = 10, //还款中
    FyRepayStateSuccess = 40, //成功
    FyRepayStateFailure = 50,  //失败
} FyRepayState;

@interface FyRepayModel : NSObject

@property (nonatomic , copy) NSString              * repayAmout;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * repayTime;
@property (nonatomic , assign) FyRepayState              state; //@{@"10":@"还款中",@"40":@"成功",@"50":@"失败"}
@property (nonatomic , copy) NSString              * repayDate;

- (NSString *)displayState;

@end
