//
//  HomeStatusBaseView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyHomeStatusModel.h"

@interface HomeStatusBaseView : UIView

@property (nonatomic, copy) void (^actionBlock)(void);
- (void)configWithHomeStatusModel:(FyHomeStatusModel *)model;
@end
