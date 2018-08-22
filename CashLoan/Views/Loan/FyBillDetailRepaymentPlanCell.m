//
//  FyBillDetailRepaymentPlanCell.m
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillDetailRepaymentPlanCell.h"
#import "FyBillDetailPopView.h"

@interface FyBillDetailRepaymentPlanCell ()

@property (nonatomic, weak) IBOutlet FyBillDetailPopView *popView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation FyBillDetailRepaymentPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOpen:(BOOL)open{
    _open = open;
    self.detailHeightConstraint.constant = open ? 80 : 0;
    self.popView.hidden = !open;
    self.btn.selected = !open;
}

- (void)setHiddenLine:(BOOL)hiddenLine{
    _hiddenLine = hiddenLine;
    self.lineView.hidden = hiddenLine;
}

- (void)setDetailList:(NSArray<FyPopCellModel *> *)detailList{
    if(_detailList != detailList){
        _detailList = detailList;
        
        [self configPopViewModel];
    }
}

- (void)configPopViewModel{
    self.popView.models = self.detailList;
}

- (IBAction)openAction:(id)sender{
    self.open = !self.open;
    if (self.openBlock) {
        self.openBlock(self.open);
    }
}

@end
