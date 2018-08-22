//
//  FyDayTagButton.h
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyDayTag.h"

@interface FyDayTagButton : UIButton

+ (nonnull instancetype)buttonWithTag: (FyDayTag *)tag;
@property (nonatomic, strong) FyDayTag *fyTag;

@end
