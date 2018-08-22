//
//  FyVerificationCodeModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FyVerificationCodeStateUnknow= 0,
    FyVerificationCodeStateSuccess = 10,
} FyVerificationCodeState;

@interface FyVerificationCodeModel : NSObject

@property (nonatomic, assign) FyVerificationCodeState code;
@property (nonatomic, copy) NSString *msg;

@end
