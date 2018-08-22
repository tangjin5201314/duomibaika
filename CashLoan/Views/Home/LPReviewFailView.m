//
//  LPReviewFailView.m
//  CashLoan
//
//  Created by lilianpeng on 2017/9/22.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "LPReviewFailView.h"
#import "LoanStatusItemModel.h"

@interface LPReviewFailView()

@property (weak, nonatomic) IBOutlet UIImageView *topImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;


@end

@implementation LPReviewFailView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)configWithHomeStatusModel:(FyHomeStatusModel *)model{
    if (model) {
        LoanStatusItemModel *dataModel = [model defaultLoanStautsItem];
        
        _moneyLabel.text = dataModel.amount;
        _daysLabel.text = dataModel.timeLimit;
        _stateLabel.text = dataModel.state;
        if (dataModel.type == LoanHomeTypeNoPass) {
            //失败
            [_topImgV setImage:[UIImage imageNamed:@"icon_jj_time"]];
            _timeLabel1.text = dataModel.remainTime.day;
            _timeLabel2.text = dataModel.remainTime.hour;
            _timeLabel3.text = dataModel.remainTime.min;

            _stateDiscriptionLabel.text = dataModel.remark;
        }
        
    }
}


@end
