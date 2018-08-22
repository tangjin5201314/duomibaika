//
//  YMLeaseTimeLimitCell.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMLeaseLimitModel.h"
#import "FyFindIndexModelV2.h"

typedef NS_ENUM(NSInteger, YMLeaseTimeLimitType) {
    YMLeaseTimeLimitDay7,
    YMLeaseTimeLimitDay15,
    YMLeaseTimeLimitLease
};

@interface YMLeaseTimeLimitCell : UITableViewCell
@property (nonatomic, copy) void (^applyBlock)(YMLeaseTimeLimitType type);

- (void)displayWithModel:(YMLeaseLimitModel *)model homeModel:(FyFindIndexModelV2 *)homeModel;
@end
