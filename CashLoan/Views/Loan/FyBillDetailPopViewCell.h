//
//  FyBillDetailPopViewCell.h
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyPopCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@end

@interface FyBillDetailPopViewCell : UIView

@property (nonatomic, strong) FyPopCellModel *model;

@end
