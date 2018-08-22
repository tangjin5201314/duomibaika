//
//  FyBillInProgressCell.h
//  CashLoan
//
//  Created by fyhy on 2017/11/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyOrderDetailModel.h"

@interface FyBillInProgressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;

@property (nonatomic, strong) FyOrderDetailModel *loanLog;
@property (nonatomic, copy) void (^showDetailBlock)();

@end
