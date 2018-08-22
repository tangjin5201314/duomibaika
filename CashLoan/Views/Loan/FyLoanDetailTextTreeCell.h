//
//  FyLoanDetailTextTreeCell.h
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OpenBlock)(BOOL);
typedef void(^HelpBlock)();

@interface FyLoanDetailTextTreeCell : UITableViewCell

@property (nonatomic, strong) UILabel *fyTextLabel;
@property (nonatomic, strong) UILabel *fySubTextLabel;
@property (nonatomic, assign) BOOL open;

@property (nonatomic, copy) OpenBlock openBlock;
@property (nonatomic, copy) HelpBlock helpBlock;

@end
