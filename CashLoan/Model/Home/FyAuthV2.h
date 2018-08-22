//
//  FyAuthV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthStateModel.h"


@interface FyAuthV2 : NSObject

@property (nonatomic, assign) BOOL isHasBaseAuth;
@property (nonatomic, strong) AuthStateModel * auth;

@end
