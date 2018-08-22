//
//  FyCalculatePopView.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+fyShow.h"

@interface FyCalculatePopView : UIView

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^commitBlock)(void);

@end
