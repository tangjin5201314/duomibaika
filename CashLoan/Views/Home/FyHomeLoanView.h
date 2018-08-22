//
//  FyHomeLoanView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "HomeStatusBaseView.h"
#import "FyHomePagePickerView.h"
#import "RoundButton.h"

@interface FyHomeLoanView : HomeStatusBaseView

@property (nonatomic, strong) IBOutlet FyHomePagePickerView *pickerView;
@property (nonatomic, strong) IBOutlet RoundButton *commitBtn;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;

@end
