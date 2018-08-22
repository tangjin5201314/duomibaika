//
//  FyBillNoProgressCell.h
//  CashLoan
//
//  Created by fyhy on 2017/11/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyBillNoProgressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, copy) void (^loanBlock)();

@end
