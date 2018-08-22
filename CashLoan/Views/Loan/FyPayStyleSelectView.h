//
//  FyPayStyleSelectView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyPayStyleSelectView : UIView

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, copy) void (^selectBlock)(NSString *typeString, NSInteger index);


@end
