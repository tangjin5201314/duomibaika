//
//  FyRepayListModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyRepayModel.h"
#import "FyPageModel.h"

@interface FyRepayListModel : NSObject

@property (nonatomic , strong) NSArray * list;
@property (nonatomic, strong) FyPageModel *page;

@end