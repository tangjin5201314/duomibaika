//
//  FyAffirmAlertView.h
//  CashLoan
//
//  Created by fyhy on 2017/11/6.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYRadiusView.h"
#import "UIView+fyShow.h"

@interface FyAffirmAlertView : FYRadiusView

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *titeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTitleKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *subTiteValueLabel;

@property (nonatomic, copy) void (^modifyBlock)(void);

@end
