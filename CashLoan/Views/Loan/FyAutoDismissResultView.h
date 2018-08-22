//
//  FyAutoDismissResultView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYGradientView.h"
#import "THLabel.h"

@interface FyAutoDismissResultView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet THLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, assign) int showTime;

@property (nonatomic, copy)  void(^dismissBlock)(void);
- (void)show ;
@end
