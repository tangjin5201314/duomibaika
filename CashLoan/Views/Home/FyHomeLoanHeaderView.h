//
//  FyHomeLoanHeaderView.h
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"
#import "FyHomeCardModel.h"

@interface FyHomeLoanHeaderView : UIView

@property (nonatomic, strong) FyHomeCardModel *cardModel;
@property (nonatomic, copy) NSString *maxLoan;

@property (nonatomic, weak) IBOutlet UIView *noticeBarBgView;
@property (nonatomic, weak) IBOutlet TXScrollLabelView *noticeBar;
@property (nonatomic, copy) void (^applyBlock)(void);

@end
