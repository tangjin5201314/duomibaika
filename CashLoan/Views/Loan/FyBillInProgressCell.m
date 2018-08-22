//
//  FyBillInProgressCell.m
//  CashLoan
//
//  Created by fyhy on 2017/11/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillInProgressCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FyBillInProgressCell()

@property (nonatomic, weak) IBOutlet UIButton *rightStautsBtn;
@property (nonatomic, weak) IBOutlet UIImageView *nextImageView;


@end

@implementation FyBillInProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLoanLog:(FyOrderDetailModel *)loanLog{
    if(_loanLog != loanLog){
        _loanLog = loanLog;
        
        [self configUI];
    }
}

//LoanStateInView = 10, //审核中
//LoanStatePass = 20, //审核通过
//LoanStateNoPass = 21, //审核不通过
//LoanStateWaitingRecheck = 22, //自动审核不通过等人工复审
//LoanStateRecheckPass = 26, //人工复审通过
//LoanStateRecheckNoPass = 27, //人工复审不通过
//LoanStateInLoan = 29, //放款中
//LoanStateWaitingRefund = 30, //待还款
//LoanStateInRefund = 35, // 还款中
//LoanStateOverdueInRefund = 36, //逾期还款中
//LoanStateHasRepay = 40,  //已还款
//LoanStateDerateRepay = 41,  //减免还款
//LoanStateOverdue = 50,  //逾期
//LoanStateBillBae = 90,  //坏账


- (void)configUI{
//    self.amountLabel.text = [self.loanLog displayLoanAmount];
    self.statusLabel.text = self.loanLog.statusStr;
    self.dateLabel.text = self.loanLog.createTime;
    self.statusImageView.image = nil;

    
    self.statusLabel.textColor = self.loanLog.status == FyOrderStatusOverDue ? [UIColor promptColorV2] : [UIColor textColorV2];
    
    UIImage *image = nil;
    switch (self.loanLog.status) {
            //审核中
            case FyOrderStatusInReview:
            {
                image = [UIImage imageNamed:@"zd_icon_shenhe"];
            }
            break;
            
            //审核不通过
            case FyOrderStatusReviewNoPass: 
            {
                
            }
            break;
            
            //放款中
            case FyOrderStatusPaying:
            {
                image = [UIImage imageNamed:@"zd_icon_fangkuan"];
            }
            break;
            
            //待还款
            case FyOrderStatusPaySuccess:
            {
                image = [UIImage imageNamed:@"zd_icon_dhk"];
            }
            break;

            //逾期
            case FyOrderStatusOverDue: 
            {
                image = [UIImage imageNamed:@"zd_icon_yq"];
            }
            break;

            //还款中
            case FyOrderStatusRepaying: 
            {
                image = [UIImage imageNamed:@"zd_icon_huankuan"];
            }
            break;
            
            //已还款
            case FyOrderStatusRepaySuccess:
            {
                
            }
            break;

        default:
            break;
    }
    
    self.rightStautsBtn.hidden = YES;
    self.nextImageView.hidden = NO;

//    if(self.loanLog.state == LoanStateWaitingRefund || self.loanLog.state == LoanStateOverdue){
//        self.rightStautsBtn.hidden = NO;
//        self.nextImageView.hidden = YES;
//    }else{
//        self.rightStautsBtn.hidden = YES;
//        self.nextImageView.hidden = NO;
//    }
    
    self.statusImageView.image = image;
    if (self.loanLog.icon.length && [NSURL URLWithString:self.loanLog.icon]) {
        [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:self.loanLog.icon]];
    }
}

- (IBAction)handleAciton:(id)sender{
    if (self.showDetailBlock) {
        self.showDetailBlock();
    }
}

@end
