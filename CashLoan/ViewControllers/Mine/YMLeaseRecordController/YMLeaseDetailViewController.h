//
//  YMLeaseDetailViewController.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyFindIndexModelV2.h"
#import "BankCardModel.h"

@interface YMLeaseDetailViewController : FyBaseViewController
@property (nonatomic, strong) YMHomeUnfishedOrderModel *orderModel;
@property (nonatomic, strong) BankCardModel *cardModel;

@end
