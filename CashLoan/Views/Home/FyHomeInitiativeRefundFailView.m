//
//  FyInitiativeLoanFailView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeInitiativeRefundFailView.h"

@interface FyHomeInitiativeRefundFailView ()

@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *finalDisLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayDisLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayResultLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end


@implementation FyHomeInitiativeRefundFailView


- (void)configWithHomeStatusModel:(FyHomeStatusModel *)model {
    if (model) {
        LoanStatusItemModel *dataModel = [model defaultLoanStautsItem];
        
        _stateDiscriptionLabel.text = dataModel.remark;
        _finalMoneyLabel.text = [NSString stringWithFormat:@"%@元",dataModel.overdue];
        _repayDisLabel.text = dataModel.repayRecordModel.content;
        _repayResultLabel.text = [dataModel.repayRecordModel.title stringByReplacingOccurrencesOfString:@"！" withString:@""];
        _dateLabel.text = dataModel.repayRecordModel.repayDate;
        _timeLabel.text = dataModel.repayRecordModel.repayTime;
        
        //待还款
        if (dataModel.type == LoanHomeTypeWaitingRefund) {
            [_topImgV setImage:[UIImage imageNamed:@"image_dhk"]];
            _finalDisLabel.text = @"待还金额";
            _finalDisLabel.textColor = [UIColor waitingRepaymentColor];
            _stateDiscriptionLabel.textColor = [UIColor waitingRepaymentColor];
            _finalMoneyLabel.textColor = [UIColor waitingRepaymentColor];
            
            
        }else if (dataModel.type == LoanHomeTypeOverdue) {
            //逾期
            [_topImgV setImage:[UIImage imageNamed:@"image_yq"]];
            _finalDisLabel.text = @"逾期总额";
            _finalDisLabel.textColor = [UIColor promptColor];
            _stateDiscriptionLabel.textColor = [UIColor promptColor];
            _finalMoneyLabel.textColor = [UIColor promptColor];
        }
    }
}

- (IBAction)nextBtnClick:(id)sender {
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
