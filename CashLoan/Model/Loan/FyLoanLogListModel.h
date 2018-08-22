//
//  FyLoanLogListModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyLoanLogModel.h"
#import "FyPageModel.h"

@interface FyLoanLogListModel : NSObject

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) FyPageModel *page;

@end
