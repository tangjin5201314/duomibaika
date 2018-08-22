//
//  YMMineActionCell.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YMMineActionCellType) {
    YMMineActionIdentification,
    YMMineActionLeaseRecord,
    YMMineActionBankCard
};

@interface YMMineActionCell : UITableViewCell
@property (nonatomic, copy) void (^applyBlock)(YMMineActionCellType type);

@end
