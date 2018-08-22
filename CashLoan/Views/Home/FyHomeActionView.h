//
//  FyHomeActionView.h
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyHomeActionBannersModel.h"

@interface FyHomeActionView : UITableViewHeaderFooterView

@property (nonatomic,copy) void (^homeActionBlock)(NSInteger index);
@property (nonatomic, strong) FyHomeActionBannersModel *banners;

@end
