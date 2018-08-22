//
//  FyHistoryBillCell.h
//  CashLoan
//
//  Created by fyhy on 2017/11/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyHistoryBillCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@end
