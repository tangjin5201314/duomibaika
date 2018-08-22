//
//  FyUpdateView.h
//  CashLoan
//
//  Created by lilianpeng on 2017/12/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyUpdateView : UIView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, copy) void (^updateBlock)(void);


- (void)show;


@end
