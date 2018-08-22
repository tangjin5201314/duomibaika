//
//  FyBillDetailRepaymentPlanCell.h
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyBillDetailPopView.h"
#import "THLabel.h"

@interface FyBillDetailRepaymentPlanCell : UITableViewCell

@property (nonatomic, copy) NSArray<FyPopCellModel *> *detailList; //[{"name":"", "value":""}]
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet THLabel *statusLabel;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) BOOL hiddenLine;

@property (nonatomic, copy) void (^openBlock)(BOOL open);

@end
