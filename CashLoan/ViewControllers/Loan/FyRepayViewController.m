//
//  FyRepayViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayViewController.h"
#import "FyPayInAdvanceDetailModel.h"
#import "FYCardBin.h"
#import "NSString+LPAddtions.h"
#import "FyPayInAdvanceDetailRequest.h"
#import "FyPayStyleSelectView.h"
#import "UIView+fyShow.h"

@interface FyRepayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgV;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *unpayPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *unpaymanagerLabel;
@property (weak, nonatomic) IBOutlet UILabel *unpayDueFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unpayInterestLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *overdueCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *selectPayMothedCell;

@property (nonatomic, strong) FYCardBin *cardBin;
@property (nonatomic, strong) FyPayInAdvanceDetailModel *model;

@property (strong, nonatomic) IBOutlet UILabel *repayMethodLabel;

@end


@implementation FyRepayViewController

- (FYCardBin *)cardBin{
    if (!_cardBin) {
        WS(weakSelf)
        _cardBin = [[FYCardBin alloc] initWithSuccessBlock:^(FYCardBinModel *cardModel) {
            NSString *bankName = [weakSelf.model.cardNo getBankName];
            [weakSelf.bankLogoImgV setImage:[UIImage imageNamed:[NSString getBankImageNameWithBankName:bankName bankCode:cardModel.bankCode]]];
        }];
    }
    return _cardBin;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addColorBackgroundView];
    
    [self requestData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestData
{
    [self showGif];
    
    FyPayInAdvanceDetailRequest *task = [[FyPayInAdvanceDetailRequest alloc] init];
    task.borrowID = self.borrowID;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyPayInAdvanceDetailModel * model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            self.model = model;
            _bankNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber:model.cardNo];
            
            self.cardBin.cardNo = model.cardNo;
            [self.cardBin loadCardName];
            _unpayPrincipalLabel.text = [NSString stringWithFormat:@"%@元",model.duePrincipal];
            _unpayInterestLabel.text = [NSString stringWithFormat:@"%@元",model.dueInterest];
            _unpaymanagerLabel.text = [NSString stringWithFormat:@"%@元",model.dueServiceFee];
            if(model.penaltyState == FyPenaltyStateUnOverdue){
                [self cell:_overdueCell setHidden:YES];
                [self reloadDataAnimated:NO];
                
            }
            _unpayDueFeeLabel.text = [NSString stringWithFormat:@"%@元",model.duePenaltyAmout];
            if (self.moneyBlock) {
                self.moneyBlock(model.dueAmount, model.isPwd);
            }
            
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
         [self fy_toastMessages:error.errorMessage];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.selectPayMothedCell]) {
        [self selectPayMethod];
    }
}


- (void)selectPayMethod{
    FyPayStyleSelectView *view = [FyPayStyleSelectView loadNib];
    view.frame = CGRectMake(0, 0, 320, 175);
    
    if ([self.repayMethodLabel.text isEqualToString:@"普通还款"]) {
        view.selectIndex = 0;
    }
    if ([self.repayMethodLabel.text isEqualToString:@"快速还款"]) {
        view.selectIndex = 1;
    }

    
    view.selectBlock = ^(NSString *typeString, NSInteger index) {
        self.repayMethodLabel.text = typeString;
        if (self.selectPayMethodBlock) {
            self.selectPayMethodBlock(typeString, index);
        }
    };
    view.fyTouchDismiss = YES;
    
    [view fy_Show];
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
