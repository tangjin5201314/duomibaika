
//
//  YMLeaseDeatailBottomView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseDeatailBottomView.h"
@interface YMLeaseDeatailBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *buyOutBtn;
@property (weak, nonatomic) IBOutlet UIView *segmentLine;

@end
@implementation YMLeaseDeatailBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.segmentLine.backgroundColor = [UIColor separatorColor];
}

- (IBAction)buyOutAction:(id)sender {
    
    if (self.applyBlock) {
        self.applyBlock();
    }
}

- (void)setPriceLabText:(NSString *)price {
    self.priceLab.text = price;
}


@end
