//
//  YMHomeLeaseTipViewCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/25.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeLeaseTipViewCell.h"
@interface YMHomeLeaseTipViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation YMHomeLeaseTipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayWithModel:(FyFindIndexModelV2 *)model {
    if (model.mobile.udid.length == 0) {
        self.title.text = @"本机";
    } else {
        self.title.text = [NSString stringWithFormat:@"%@,%@G",model.mobile.phone_model,model.mobile.phone_memory];
    }
    if (model.mobile.isSelected) {
        self.selectedIcon.hidden = NO;
    } else {
        self.selectedIcon.hidden = YES;
    }
}


@end
