//
//  FyRepayHistoryCell.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayHistoryCell.h"

@interface FyRepayHistoryCell()

@property (weak, nonatomic) IBOutlet UILabel *fyTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *fySubTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *fyStateLabel;

@end


@implementation FyRepayHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FyRepayModel *)model{
    if (_model != model) {
        _model = model;
        self.fyTextLabel.text = [NSString stringWithFormat:@"%@  %@",model.repayDate,model.repayTime];
        self.fySubTextLabel.text = model.content;
        self.fyStateLabel.text = [model  displayState];
        
        if (model.state == FyRepayStateInRefund) {
            self.fyStateLabel.textColor = [UIColor promptColor];
        }else if(model.state == FyRepayStateSuccess){
            self.fyStateLabel.textColor = [UIColor approveSuccessBorderColor];
        }else if(model.state == FyRepayStateFailure){
            self.fyStateLabel.textColor = [UIColor promptColor];
        }
    }
}

@end
