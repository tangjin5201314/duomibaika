//
//  FyLoanDetailViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanDetailViewController.h"
#import "FyLoanDetailTextCell.h"
#import "FyLoanDetailLightTextCell.h"
#import "FyLoanDetailRequest.h"
#import "FYCardBin.h"
#import "RDWebViewController.h"
#import "FyH5PageUtil.h"
#import "TooltipManager.h"
#import "FyRepayHistoryViewController.h"
#import "FyRepayMotherViewController.h"


@interface FyLoanDetailHeaderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *stateImageView;
@property (nonatomic, strong) IBOutlet UILabel *leftTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *leftSubTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *rightTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *rightSubTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *bottomTextLabel;

@property (nonatomic, strong) IBOutlet UILabel *fyTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *fySubTextLabel;

@property (nonatomic, strong) FyLoanDetailBorrowListModel *listModel;

@end

@interface FyLoanDetailRefundCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *fyTitleLable;
@property (nonatomic, strong) IBOutlet UILabel *fyStateLabel;
@property (nonatomic, strong) IBOutlet UILabel *fyTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *fySubTextLabel;

@end


@implementation FyLoanDetailHeaderCell

@end

@implementation FyLoanDetailRefundCell

@end


@interface FyLoanDetailViewController ()

@property (nonatomic, strong) IBOutlet FyLoanDetailHeaderCell *headerCell;
@property (nonatomic, strong) IBOutlet FyLoanDetailLightTextCell *cell24;

@property (nonatomic, strong) IBOutlet FyLoanDetailTextCell *cell1;
@property (nonatomic, strong) IBOutlet FyLoanDetailTextCell *cell2;
@property (nonatomic, strong) IBOutlet FyLoanDetailTextCell *cell3;
@property (nonatomic, strong) IBOutlet FyLoanDetailTextCell *cell4;

@property (nonatomic, strong) IBOutlet FyLoanDetailLightTextCell *cell11;
@property (nonatomic, strong) IBOutlet FyLoanDetailLightTextCell *cell21;
@property (nonatomic, strong) IBOutlet FyLoanDetailLightTextCell *cell22;
@property (nonatomic, strong) IBOutlet FyLoanDetailLightTextCell *cell23;

@property (nonatomic, strong) IBOutlet FyLoanDetailRefundCell *refundCell; //还款记录
@property (nonatomic, strong) IBOutlet UITableViewCell *repayCell; //还款按钮cell
@property (nonatomic, strong) IBOutlet UITableViewCell *protocolCell; //协议cell
@property (nonatomic, strong) IBOutlet UITableViewCell *topCell; //top cell
@property (nonatomic, strong) IBOutlet UITableViewCell *bottomCell; //bottom cell

//上面的cell
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel; //服务费
@property (weak, nonatomic) IBOutlet UIButton *upArrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *upArrowBtn_bg;


//下面的开关cell
@property (weak, nonatomic) IBOutlet UILabel *shouldRepaymentLabel; //应还金额
@property (weak, nonatomic) IBOutlet UILabel *downLeftMoneyTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *downArrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *downArrowBtn_bg;


@property (nonatomic, strong) FyLoanDetailBorrowListModel *listModel;


@end

@implementation FyLoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addColorBackgroundView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"借款详情";
    [self hiddenAllCells];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topMoreBtnClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _upArrowBtn.selected = btn.selected;
    [_upArrowBtn setBackgroundImage:[UIImage imageNamed:!btn.selected ? @"btn_open" : @"btn_close"] forState:UIControlStateNormal];
    [self cell:_cell11 setHidden:!btn.selected];
    [self reloadDataAnimated:NO];
}

- (IBAction)bottomMoreBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@"downBtn.selected == %d",btn.selected);
    btn.selected = !btn.selected;
    _downArrowBtn.selected = btn.selected;
    [_downArrowBtn setBackgroundImage:[UIImage imageNamed:!btn.selected ? @"btn_open" : @"btn_close"] forState:UIControlStateNormal];
    [self cell:_cell21 setHidden:!btn.selected];
    [self cell:_cell22 setHidden:!btn.selected];
    [self cell:_cell24 setHidden:!btn.selected];
    [self cell:self.cell23 setHidden:YES];

    FyBorrowDetailModel *borrowModel = [self.listModel defaultBorrowDetailModel];

    switch (_borrowState) {
        case LoanStateInView:
        case LoanStateOverdueInRefund:
        case LoanStateHasRepay:
        case LoanStateDerateRepay:
        case LoanStateOverdue:
        case LoanStateBillBae:
        {
            if (borrowModel.penalty == FyPenaltyStateOverdue) {
                [self cell:self.cell23 setHidden:!btn.selected];
            }
        }
            
            break;
            
        default:
            break;
    }
    
    [self reloadDataAnimated:NO];
    
}


- (IBAction)protocolBtnClick:(id)sender {
    if(_upArrowBtn.selected == YES) {
        [self topMoreBtnClick:_upArrowBtn_bg];
        
    }
    if(_downArrowBtn.selected == YES) {
        [self bottomMoreBtnClick:_downArrowBtn_bg];
    }
    
    
    FyBorrowDetailModel *borrowModel = [self.listModel defaultBorrowDetailModel];
    if (!borrowModel) return;
    
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"富卡借款协议";
    vc.url = [FyH5PageUtil loanProcotolWithBorrowH5Link:borrowModel.h5Link];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)explainBtnClick:(id)sender {
    FyBorrowDetailModel *borrowModel = [self.listModel defaultBorrowDetailModel];
    if (borrowModel.cardNo.length > 3) {
        [TooltipManager sharedInstance].cardNo = [borrowModel.cardNo substringFromIndex:borrowModel.cardNo.length - 3];
    }else{
        [TooltipManager sharedInstance].cardNo = @"xxx";
    }
    [[TooltipManager sharedInstance] resetFlow:@"load_detail"];
    [[TooltipManager sharedInstance] startFlowIfNeeded:self flowID:@"load_detail"];
}

//主动还款
- (IBAction)selfRepaymentBtnClick:(id)sender {
    FyRepayMotherViewController *vc = [FyRepayMotherViewController loadFromStoryboardName:@"LoanStoryboard" identifier:nil];
    vc.borrowID = self.borrowID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)pushToRefundHistory{
    FyRepayHistoryViewController *vc = [[FyRepayHistoryViewController alloc] init];
    vc.borrowID = self.borrowID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hiddenAllCells{
    [self cell:self.refundCell setHidden:YES];
    [self cell:self.repayCell setHidden:YES];
    [self cell:self.protocolCell setHidden:YES];
    [self cell:self.headerCell setHidden:YES];
    
    [self cell:self.cell1 setHidden:YES];
    [self cell:self.cell2 setHidden:YES];
    [self cell:self.cell3 setHidden:YES];
    [self cell:self.cell4 setHidden:YES];
    
    [self cell:self.topCell setHidden:YES];
    [self cell:self.bottomCell setHidden:YES];
    [self reloadDataAnimated:NO];
}

- (void)showCells{
    [self cell:self.protocolCell setHidden:NO];
    [self cell:self.headerCell setHidden:NO];
    
    [self cell:self.cell1 setHidden:NO];
    [self cell:self.cell2 setHidden:NO];
    [self cell:self.cell3 setHidden:NO];
    [self cell:self.cell4 setHidden:NO];
    
    [self cell:self.topCell setHidden:NO];
    [self cell:self.bottomCell setHidden:NO];

}

- (void)configData{
    FyBorrowDetailModel *borrowModel = [self.listModel defaultBorrowDetailModel];
    FyRepayDetailModel *repayModel = [self.listModel defaultRepayModel];
    if (borrowModel) {
        NSDictionary *stateDict = @{
                                    @"40":@"jk_state_yihk",
                                    @"30":@"jk_state_daihk",
                                    @"50":@"jk_state_yuqi",
                                    @"41":@"jk_state_yuqi",
                                    @"27":@"jk_state_weitg",
                                    @"21":@"jk_state_weitg",
                                    @"20":@"jk_state_fangkuan",
                                    @"26":@"jk_state_fangkuan",
                                    @"10":@"jk_state_shenhe",
                                    @"22":@"jk_state_shenhe",
                                    @"35":@"jk_state_huankz",
                                    @"36":@"jk_state_huankz"
                                    };

        NSString *key = [NSString stringWithFormat:@"%ld", (long)self.borrowState];
        NSString *stateString = stateDict[key];
        self.headerCell.stateImageView.image = [UIImage imageNamed:stateString];
        
        NSString *headerLeftSubText = @"";
        NSString *headerleftText = @"";
        NSString *headerRightText = @"";
        NSString *headerRightSubText = @"";
        NSString *headerBottomText = @"";
        NSString *headerKeyText = @"";
        NSString *headerValueText = @"";

        NSString *cell1KeyText = @"";
        NSString *cell1ValueText = @"";

        NSString *cell2KeyText = @"";
        NSString *cell2ValueText = @"";

        NSString *cell3KeyText = @"";
        NSString *cell3ValueText = @"";

        NSString *cell4KeyText = @"";
        NSString *cell4ValueText = @"";
        
        NSString *cell23KeyText = @"逾期罚息";
        NSString *cell23ValueText = @"";
        
        NSString *bottomKeyText = @"应还金额";
        NSString *bottomVauleText = [borrowModel displayOverdueAmount];
        
        [self showCells];
        [self cell:self.refundCell setHidden:YES]; //还款记录
        [self cell:self.repayCell setHidden:YES]; //主动还款
        
        switch (self.borrowState) {
            case LoanStateHasRepay: //已还款
            {
                [self cell:self.cell23 setHidden:YES];
                [self cell:self.cell3 setHidden:YES];
                [self cell:self.cell4 setHidden:YES];

                headerBottomText = [NSString stringWithFormat:@"借款期限    %@",[borrowModel displayTimeLimit]];
                headerleftText = @"申请日期";
                headerLeftSubText = borrowModel.creditTimeStr;
                headerRightText = @"借款金额（元）";
                headerRightSubText = [borrowModel displayAmountNoYuan];
                headerKeyText = @"实际到账";
                headerValueText = [borrowModel displayRealAmount];
                
                cell1KeyText = @"还款日期";
                cell1ValueText = repayModel.repayTimeStr;
                
                cell2KeyText = @"还款银行";
                cell2ValueText = [borrowModel displayBankCardNameAndNo];
                
                bottomKeyText = @"已还金额";
                bottomVauleText = borrowModel.overdueAmount;
                
                cell23KeyText = @"逾期罚息";
                cell23ValueText = [NSString stringWithFormat:@"%@元",borrowModel.penaltyAmount];
                
                if (borrowModel.penalty == FyPenaltyStateOverdue) { //逾期还款
                    [self cell:self.cell23 setHidden:NO];

                }

            }
                break;
            case LoanStateWaitingRefund: //待还款
            {
                [self cell:self.cell23 setHidden:YES];
                [self cell:self.cell3 setHidden:YES];
                [self cell:self.cell4 setHidden:YES];
                [self cell:self.repayCell setHidden:NO];

                headerBottomText = [NSString stringWithFormat:@"借款期限    %@",[borrowModel displayTimeLimit]];
                headerKeyText = @"还款日期";
                headerValueText = [borrowModel displayRealAmount];
                
                headerleftText = @"还款日期";
                headerLeftSubText = repayModel.repayTimeStr;
                headerRightText = @"借款金额（元）";
                headerRightSubText = [borrowModel displayAmountNoYuan];

                
                cell1KeyText = @"申请日期";
                cell1ValueText = borrowModel.creditTimeStr;
                
                cell2KeyText = @"还款银行";
                cell2ValueText = [borrowModel displayBankCardNameAndNo];
                
            }
                break;
                
            case LoanStateOverdue: //逾期
            case LoanStateBillBae: //坏账
            case LoanStateOverdueInRefund: //逾期还款中
            {
                if (self.borrowState != LoanStateOverdueInRefund) {
                    [self cell:self.repayCell setHidden:NO];
                }

                headerBottomText = [NSString stringWithFormat:@"还款日期    %@",repayModel.repayTimeStr];
                headerKeyText = @"借款金额";
                headerValueText = [borrowModel displayLoanAmount];
                headerleftText = @"逾期天数（天）";
                headerLeftSubText = borrowModel.penaltyDay;
                headerRightText = @"罚息金额（元）";
                headerRightSubText = [borrowModel displayPenaltyAmountNoYuan];
                
                cell1KeyText = @"借款期限";
                cell1ValueText = [borrowModel displayTimeLimit];
                
                cell2KeyText = @"实际到账";
                cell2ValueText = [borrowModel displayRealAmount];
                
                cell3KeyText = @"申请日期";
                cell3ValueText = borrowModel.creditTimeStr;
                
                cell4KeyText = @"还款银行";
                cell4ValueText = [borrowModel displayBankCardNameAndNo];
                
                cell23KeyText = @"逾期罚息";
                cell23ValueText = [borrowModel displayPenaltyAmount];
            }
                break;
            case LoanStateInView: //审核中
            case LoanStatePass: //审核通过
            case LoanStateNoPass: //审核不通过
            case LoanStateWaitingRecheck: //自动审核不通过等人工审核
            case LoanStateRecheckPass: //人工复审通过
            case LoanStateRecheckNoPass: //人工复审不通过
            case LoanStateInLoan: //放款中
            {
                [self cell:self.cell23 setHidden:YES];
                [self cell:self.cell2 setHidden:YES];
                [self cell:self.cell3 setHidden:YES];
                [self cell:self.cell4 setHidden:YES];
                
                headerBottomText = [NSString stringWithFormat:@"借款期限    %@",[borrowModel displayTimeLimit]];
                headerKeyText = @"借款金额";
                headerValueText = [borrowModel displayLoanAmount];
                headerleftText = @"申请日期";
                headerLeftSubText = borrowModel.creditTimeStr;
                headerRightText = @"实际到账（元）";
                headerRightSubText = [borrowModel displayRealAmountNoYuan];

                cell1KeyText = @"还款银行";
                cell1ValueText = [borrowModel displayBankCardNameAndNo];
            }
                
                break;
            case LoanStateInRefund: //还款中
            {
                [self cell:self.repayCell setHidden:NO];
                [self cell:self.cell23 setHidden:YES];
                [self cell:self.cell3 setHidden:YES];
                [self cell:self.cell4 setHidden:YES];
                headerBottomText = [borrowModel displayCreateTime];
                headerKeyText = @"实际到账";
                headerValueText = [borrowModel displayRealAmount];
                headerleftText = @"还款日期";
                headerLeftSubText = repayModel.repayTimeStr;
                headerRightText = @"借款金额（元）";
                headerRightSubText = [borrowModel displayAmountNoYuan];
                
                cell1KeyText = @"还款银行";
                cell1ValueText = [borrowModel displayBankCardNameAndNo];
                
                cell1KeyText = @"申请日期";
                cell1ValueText = borrowModel.creditTimeStr;
                
                cell2KeyText = @"还款银行";
                cell2ValueText = [borrowModel displayBankCardNameAndNo];
            }
                break;

            default:
            {
                [self cell:self.cell1 setHidden:YES];
                [self cell:self.cell2 setHidden:YES];
                [self cell:self.cell3 setHidden:YES];
                [self cell:self.cell4 setHidden:YES];
            }
                break;
        }
        
        self.serviceLabel.text = [borrowModel displayAuthFee];
        self.headerCell.leftTextLabel.text = headerleftText;
        self.headerCell.leftSubTextLabel.text = headerLeftSubText;
        self.headerCell.rightTextLabel.text = headerRightText;
        self.headerCell.rightSubTextLabel.text = headerRightSubText;
        self.headerCell.bottomTextLabel.text = headerBottomText;
        self.headerCell.fySubTextLabel.text = headerValueText;
        self.headerCell.fyTextLabel.text = headerKeyText;
        
        _shouldRepaymentLabel.text = bottomVauleText;
        _downLeftMoneyTipLabel.text = bottomKeyText;
        
        self.cell23.fyTextLabel.text = cell23KeyText;
        self.cell23.fySubTextLabel.text = cell23ValueText;

        self.cell11.fyTextLabel.text = @"支付信息费";
        self.cell11.fySubTextLabel.text = [borrowModel displayAuthFee];
        
        self.cell21.fyTextLabel.text = @"账户管理费";
        self.cell21.fySubTextLabel.text = [borrowModel displayServiceFee];
        
        self.cell22.fyTextLabel.text = @"利息费用";
        self.cell22.fySubTextLabel.text = [borrowModel displayInterest];
        
        self.cell24.fyTextLabel.text = @"借款金额";
        self.cell24.fySubTextLabel.text = [borrowModel displayLoanAmount];
        
        self.cell1.fyTextLabel.text = cell1KeyText;
        self.cell1.fySubTextLabel.text = cell1ValueText;
        
        self.cell2.fyTextLabel.text = cell2KeyText;
        self.cell2.fySubTextLabel.text = cell2ValueText;
        
        self.cell3.fyTextLabel.text = cell3KeyText;
        self.cell3.fySubTextLabel.text = cell3ValueText;
        
        self.cell4.fyTextLabel.text = cell4KeyText;
        self.cell4.fySubTextLabel.text = cell4ValueText;

        [self cell:_cell11 setHidden:YES];
        [self cell:_cell21 setHidden:YES];
        [self cell:_cell22 setHidden:YES];
        [self cell:_cell23 setHidden:YES];
        [self cell:_cell24 setHidden:YES];

        
        //还款记录
        if (borrowModel.repayRecordModel) {
            [self cell:self.refundCell setHidden:NO]; //还款记录
        
            self.refundCell.fyTitleLable.text = @"还款记录";
            self.refundCell.fyTextLabel.text = [NSString stringWithFormat:@"%@   %@",borrowModel.repayRecordModel.repayDate,borrowModel.repayRecordModel.repayTime];
            self.refundCell.fySubTextLabel.text = borrowModel.repayRecordModel.content;
            self.refundCell.fyStateLabel.text = [borrowModel.repayRecordModel displayState];
            
            if (borrowModel.repayRecordModel.state == FyRepayStateInRefund) {
                self.refundCell.fyStateLabel.textColor = [UIColor promptColor];
            }else if(borrowModel.repayRecordModel.state == FyRepayStateSuccess){
                self.refundCell.fyStateLabel.textColor = [UIColor approveSuccessBorderColor];
            }else if(borrowModel.repayRecordModel.state == FyRepayStateFailure){
                self.refundCell.fyStateLabel.textColor = [UIColor promptColor];
            }
        }
        [self reloadDataAnimated:NO];
    }
}

-(void)requestData
{
    [self showGif];
    
    FyLoanDetailRequest *task = [[FyLoanDetailRequest alloc] init];
    task.borrowID = self.borrowID;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            self.listModel = model;
            [self configData];
        }
        [self hideGif];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
             [self fy_toastMessages:error.errorMessage];
            
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.refundCell]) {
        //跳转还款历史
        [self pushToRefundHistory];
    }
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
