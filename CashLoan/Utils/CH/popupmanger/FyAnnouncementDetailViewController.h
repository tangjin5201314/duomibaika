//
//  FyAnnouncementDetailViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyAnnouncementModel.h"

@interface FyAnnouncementDetailViewController : UIViewController

@property (nonatomic, strong) FyAnnouncementModel *model;
@property (nonatomic, copy) void (^closeBlock)(void);

@end
