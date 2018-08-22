//
//  FyWaitingRefundView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyWaitingRefundView.h"

@interface FyWaitingRefundView()

@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end


@implementation FyWaitingRefundView


- (void)configWithHomeStatusModel:(FyHomeStatusModel *)model {
    if (model) {
        LoanStatusItemModel *dataModel = [model defaultLoanStautsItem];
        
        _moneyLabel.text = dataModel.amount;
        _daysLabel.text = dataModel.timeLimit;
        _stateDiscriptionLabel.text = dataModel.remark;
        _stateLabel.text = dataModel.state;
        _stateMoneyLabel.text = dataModel.overdue;
        
        //审核中
        if (dataModel.type == LoanHomeTypeWaitingRefund) {
            [_topImgV setImage:[UIImage imageNamed:@"image_dhk"]];
        }
        
    }
}
 
- (IBAction)refreshBtnClick:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
