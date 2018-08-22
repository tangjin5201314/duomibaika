//
//  FyHomeWaitingForViewView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeWaitingForViewView.h"

@interface FyHomeWaitingForViewView()

@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@end

@implementation FyHomeWaitingForViewView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)configWithHomeStatusModel:(FyHomeStatusModel *)model {
    if (model) {
        LoanStatusItemModel *dataModel = [model defaultLoanStautsItem];
        
        _moneyLabel.text = dataModel.amount;
        _daysLabel.text = dataModel.timeLimit;
        _stateLabel.text = dataModel.state;
        
        //审核中
        if (dataModel.type == LoanHomeTypeInView) {
            [_topImgV setImage:[UIImage imageNamed:@"icon_shz"]];
            _stateDiscriptionLabel.text = dataModel.remark;
            
        }else if (dataModel.type == LoanHomeTypeHasLoan) {
            //放款中
            [_topImgV setImage:[UIImage imageNamed:@"icon_fkz"]];
            _stateDiscriptionLabel.text = dataModel.remark;
        }else if (dataModel.type == LoanHomeTypeNoPass) {
            //失败
            [_topImgV setImage:[UIImage imageNamed:@"icon_fail"]];
            _stateDiscriptionLabel.text = dataModel.remark;
        }else if (dataModel.type == LoanHomeTypeInRefund || dataModel.type == LoanHomeTypeOverdueInRefund) {
            [_bottomBtn setTitle:@"还款详情" forState:UIControlStateNormal];
            //还款中
            [_topImgV setImage:[UIImage imageNamed:@"icon_hkz"]];
            _stateDiscriptionLabel.text = dataModel.remark;
            if (dataModel.type == LoanHomeTypeOverdueInRefund) {
                _leftLabel.text = @"罚息金额/元";
                _rightLabel.text = @"逾期天数/天";
            }
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
