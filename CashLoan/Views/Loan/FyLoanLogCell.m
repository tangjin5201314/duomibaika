//
//  FyLoanLogCell.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanLogCell.h"
#import "RoundButton.h"

@interface FyLoanLogCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet RoundButton *rightBtn;
@property (weak, nonatomic) IBOutlet RoundButton *longRightBtn;

@end

@implementation FyLoanLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rightBtn.corners = UIRectCornerBottomLeft|UIRectCornerTopLeft;
    self.rightBtn.borderWidth = 1;
    self.rightBtn.radius = 15;
    
    self.longRightBtn.corners = UIRectCornerBottomLeft|UIRectCornerTopLeft;
    self.longRightBtn.borderWidth = 1;
    self.longRightBtn.radius = 15;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftBtnClick:(id)sender {
    if (self.protocolBlock) {
        self.protocolBlock();
    }
}

- (IBAction)rightBtnClick:(id)sender {
    
}


- (void)setModel:(FyLoanLogModel *)model{
    if (_model != model) {
        _model = model;
        
        [self configCellWithModel:model];
    }
}

- (void)configCellWithModel:(FyLoanLogModel *)model{
    _timeLabel.text = model.creditTimeStr;
    _moneyLabel.text = [NSString stringWithFormat:@"%@",model.amount];
    
    if (model.state == LoanStateOverdue || model.state == LoanStateDerateRepay) {
        //逾期
        [self updateBtnStateWithColor:[UIColor outtimeColor] title:model.stateStr button:_rightBtn];
    }else if(model.state == LoanStateWaitingRefund){
        //待还款
        [self updateBtnStateWithColor:[UIColor statusColor] title:model.stateStr button:_rightBtn];
        
    }else{
        //其他
        if (model.stateStr.length > 3) {
            [self updateBtnStateWithColor:[UIColor separatorColor] title:model.stateStr  button:_longRightBtn];
        }else{
            [self updateBtnStateWithColor:[UIColor separatorColor] title:model.stateStr  button:_rightBtn];
        }
    }
}

- (void)updateBtnStateWithColor:(UIColor *)color title:(NSString *)title button:(RoundButton *)btn {
//    [btn setBackgroundColor:color];
    btn.borderColor = color;
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    if ([btn isEqual:_rightBtn]) {
        _rightBtn.hidden = NO;
        _longRightBtn.hidden = YES;
    }else{
        _rightBtn.hidden = YES;
        _longRightBtn.hidden = NO;
        
    }
    
}


@end
