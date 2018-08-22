//
//  FyBillHeaderCell.h
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyBillHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel *psLabel;
@property (nonatomic, weak) IBOutlet UILabel *payStyleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bankLabel;
@property (nonatomic, weak) IBOutlet UILabel *usageLabel;

@end
