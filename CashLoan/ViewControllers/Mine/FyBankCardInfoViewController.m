//
//  FyBankCardInfoViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBankCardInfoViewController.h"
//#import "FYCardBin.h"
#import "FyH5PageUtil.h"
#import <YYText/YYText.h>
#import "BankCardModel.h"
#import "NSString+LPAddtions.h"
#import "FyBankModelRequest.h"
#import "FyBindingBankViewController.h"

@interface FyBankCardInfoViewController (){
    NSURLSessionTask *bank_task;
}

@property (weak, nonatomic) IBOutlet YYLabel *disLabel;
@property (weak, nonatomic) IBOutlet UIImageView *banImgV;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (nonatomic, strong) FYCardBin *cardBin;
@property (nonatomic, strong) BankCardModel *bankCardModel;
@property (weak, nonatomic) IBOutlet UITableViewCell *disCell;

@end

@implementation FyBankCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    self.fy_navigationBarColor = self.fy_navigationBarLineColor = [UIColor clearColor];
    [self configDisLabel];
    self.title = @"我的银行卡";
    [self requestDataComplete:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDisLabel {
    _disLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _disLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    _disLabel.numberOfLines = 0;
    NSString *str = @"借款申请通过后，我们会将您的所借款项发放到该银行卡。若重新绑卡，则新卡会激活为收款银行卡。未完成借款期间不允许更换银行卡。";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_color = [UIColor subTextColor];
    text.yy_lineSpacing = 12;
    _disLabel.attributedText = text;
    
    [self cell:self.disCell setHeight:[self heightForDesCellWithAttributedText:text]];
    [self reloadDataAnimated:NO];
}

- (CGFloat)heightForDesCellWithAttributedText:(NSAttributedString *)attributedText{
    CGFloat width = CGRectGetWidth(self.view.frame)-50;
    
    YYTextContainer  *titleContarer = [YYTextContainer new];
    titleContarer.size = CGSizeMake(width,CGFLOAT_MAX);
    YYTextLayout *titleLayout = [YYTextLayout layoutWithContainer:titleContarer text:attributedText];
    
    CGFloat titleLabelHeight = titleLayout.textBoundingSize.height;
    return titleLabelHeight + 30;
}

-(void)requestDataComplete:(void(^)(void)) complete{
    [self showGif];
    FyBankModelRequest *t = [[FyBankModelRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            self.bankCardModel = model;
            [self setupData];
        }
        else{
            [self fy_toastMessages:error.errorMessage];
        }
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
            [self fy_toastMessages:error.errorMessage];
        }
        if (complete) {
            complete();
        }

    }];
}

- (void)setupData {
    _bankNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber2:[_bankCardModel.cardNo LPTrimString]];
    _nameLabel.text = _bankCardModel.bankName;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:CHECKNULL(_bankCardModel.desc)];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_color = [UIColor subTextColor];
    text.yy_lineSpacing = 5;

    _disLabel.attributedText = text;
    [self.banImgV sd_setImageWithURL:[NSURL URLWithString:self.bankCardModel.greyImgUrl]];

    [self cell:self.disCell setHeight:[self heightForDesCellWithAttributedText:text]];
    [self reloadDataAnimated:NO];
}

- (IBAction)reBindBankCardClick:(id)sender {
    if (!self.bankCardModel) {
        [self requestDataComplete:^{
            if (self.bankCardModel) {
                [self reBindBankCardClick:nil];
            }
        }];
        return;
    }
    
    if (_bankCardModel.changeable) {
        //可以改绑
        //点击绑卡按钮
        [self bandingCard];
    }else{
        [self LPShowAletWithContent:@"您尚有未完成账单，暂时不可换绑银行卡" okClick:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)bandingCard{
    //绑卡
    WS(weakSelf)
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    vc.reBind = YES;
    vc.bindSuccessBlock =  ^(NSString *bankName, NSString *bankNumber, NSString *imageUrl) {
        weakSelf.bankNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber:[bankNumber LPTrimString]];
        weakSelf.nameLabel.text = bankName;
        [weakSelf.banImgV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
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
