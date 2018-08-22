//
//  FyLoanLogCell.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyLoanLogModel.h"

@interface FyLoanLogCell : UITableViewCell

@property (nonatomic, strong) FyLoanLogModel * model;
@property (nonatomic, copy) void (^protocolBlock)(void);


@end
