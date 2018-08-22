//
//  FySuccessView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYGradientView.h"
#import <YYText/YYText.h>

@interface FySuccessView : FYGradientView

@property (weak, nonatomic) IBOutlet YYLabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSAttributedString *text;

@property (nonatomic, copy)  void(^popBlock)(void);

- (void)show;

@end
