//
//  FyConfrmLoanViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyConfrmLoanViewController.h"
#import "RichLabel.h"
#import "NSString+FormatNumber.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AuthStateModel.h"
#import "FYCardBin.h"
#import "NSString+LPAddtions.h"
#import "FyAuthStateRequest.h"
#import "NSString+FormatNumber.h"
#import "EventHanlder.h"
#import "RDPayPasswordView.h"
#import "FyForgetPayPwdViewController.h"
#import "FyBindingBankViewController.h"
#import "FyH5PageUtil.h"
#import "RDWebViewController.h"
#import "FySetLoanPwdRequest.h"
#import "NSString+fyBase64.h"
#import "FyLoanApplyRequest.h"
#import "EventHanlder.h"
#import "FyAutoDismissResultView.h"
#import "FySuccessView.h"
#import "FyPwdUtil.h"

@interface FyConfrmLoanViewController ()<AMapLocationManagerDelegate>{
    BOOL _agree;
    BOOL isOpen;
    
    NSURLSessionDataTask *task;
}

@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *coordinate;

@property(nonatomic,strong)AMapLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *topRadiusView;
@property (weak, nonatomic) IBOutlet UIView *bottomRadiusView;
@property (weak, nonatomic) IBOutlet UIButton *upArrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *downArrowBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell00;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell01;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell02;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell10;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImgV;
@property (weak, nonatomic) IBOutlet UIView *bindingBGView;

@property (weak, nonatomic) IBOutlet UILabel *loanMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanLimitDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouldRepaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccountManageLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *ApplyMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *AuditMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ActualToAccountMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) __block AuthStateModel *stateModel;

@property (nonatomic, strong) FYCardBin *cardBin;


@end

@implementation FyConfrmLoanViewController

- (void)dealloc{
    NSLog(@"dealloc %s", __func__);
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [self setLocationManagerForHundredMeters];
    }
    return _locationManager;
}

- (FYCardBin *)cardBin{
    if (!_cardBin) {
        WS(weakSelf)
        _cardBin = [[FYCardBin alloc] initWithSuccessBlock:^(FYCardBinModel *cardModel) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *bankName = [weakSelf.model.bankNum getBankName];
                [weakSelf.bankLogoImgV setImage:[UIImage imageNamed:[NSString getBankImageNameWithBankName:bankName bankCode:cardModel.bankCode]]];
            });
            
        }];
    }
    return _cardBin;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self cell:_cell00 setHidden:YES];
    [self cell:_cell01 setHidden:YES];
    [self cell:_cell02 setHidden:YES];
    [self cell:_cell10 setHidden:YES];
    [self reloadDataAnimated:NO];

    _agree = YES;
    [self addColorBackgroundView];
    [self configData];
    [self configProtocol];
    [self refreshBankStatus];
    
    self.title = @"确认借款";

//    if ([FyUserCenter sharedInstance].appIsInView) {
//        [self.commitBtn setTitle:@"知道了" forState:UIControlStateNormal];
//        self.title = @"利息计算";
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![FyAuthorizationUtil allowLocation]) {
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushToProtocol{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"富卡借款协议";
    vc.url = [FyH5PageUtil urlPathWithType:FyH5PageTypeLoanEGProtocol];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)configProtocol{
    NSString *protocolName = @"《富卡借款协议》";
    self.protocolLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.protocolLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.protocolLabel.numberOfLines = 1;
    NSString *str = [NSString stringWithFormat:@"我已阅读并同意%@",protocolName];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = [UIColor textColor];
    text.yy_lineSpacing = 12;
    NSString *str1 = protocolName;
    NSRange range1 = [str rangeOfString:str1 ];
    WS(weakSelf)
    [text yy_setTextHighlightRange:range1
                             color:[UIColor textLinkColor]
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                             [weakSelf pushToProtocol];
                         }];
    
    self.protocolLabel.attributedText = text;
}

- (void)configData {
    _loanMoneyLabel.text = self.model.amount;
    _loanLimitDaysLabel.text = self.model.timeLimit;
    _cardNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber:_model.bankNum];
    _shouldRepaymentLabel.text = [NSString stringWithFormat:@"%.2f元",self.model.amount.floatValue + self.calculateModel.feeDetail.interest.floatValue + self.calculateModel.feeDetail.serviceFee.floatValue];
    _AccountManageLabel.text = [NSString stringWithFormat:@"%@元",self.calculateModel.feeDetail.serviceFee];
    _interestLabel.text = [NSString stringWithFormat:@"%@元",self.calculateModel.feeDetail.interest];
    _ApplyMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.model.amount floatValue]];
    _serviceLabel.text = [NSString stringWithFormat:@"%@元",self.calculateModel.feeDetail.infoAuthFee];
    _AuditMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.calculateModel.feeDetail.infoAuthFee];
    _ActualToAccountMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.model.realAmount floatValue]];
}


- (void)refreshBankStatus{
    [task cancel];
    [self showGif];
    WS(weakSelf)
    FyAuthStateRequest *t = [[FyAuthStateRequest alloc] init];
    task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            weakSelf.stateModel = model;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.stateModel.bankCardState == 30) {
                    weakSelf.bindingBGView.hidden = YES;
                    weakSelf.cardNumberLabel.hidden = NO;
                    weakSelf.cardNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber:weakSelf.model.bankNum];
                    weakSelf.bankLogoImgV.hidden = NO;
                }else{
                    weakSelf.bindingBGView.hidden = NO;
                    weakSelf.cardNumberLabel.hidden = YES;
                }
            });
            
            
            NSString *bankName = [_model.bankNum getBankName];
            [weakSelf.bankLogoImgV setImage:[UIImage imageNamed:[NSString getBankImageNameWithBankName:bankName]]];
            weakSelf.cardBin.cardNo = _model.bankNum;
            [weakSelf.cardBin loadCardName];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
             [self fy_toastMessages:error.errorMessage];
        }
        
    }];
    
}


- (IBAction)bottomMoreBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _downArrowBtn.selected = btn.selected;
    [_downArrowBtn setBackgroundImage:[UIImage imageNamed:!btn.selected ? @"btn_open" : @"btn_close"] forState:UIControlStateNormal];
    [self cell:_cell10 setHidden:!btn.selected];
    [self reloadDataAnimated:NO];
    
}

- (IBAction)topMoreBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _upArrowBtn.selected = btn.selected;
    [_upArrowBtn setBackgroundImage:[UIImage imageNamed:!btn.selected ? @"btn_open" : @"btn_close"] forState:UIControlStateNormal];
    [self cell:_cell00 setHidden:!btn.selected];
    [self cell:_cell01 setHidden:!btn.selected];
    [self cell:_cell02 setHidden:!btn.selected];
    [self reloadDataAnimated:NO];
}
- (IBAction)confirmApplyBtnClick:(id)sender {
    
//    if ([FyUserCenter sharedInstance].appIsInView) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }

    
    if (!_agree) {
        [self LPShowAletWithContent:@"请先阅读并同意《富卡借款协议》"];
        return;
    }
    
    if (!_stateModel.bankCardState) {
        [self LPShowAletWithContent:@"不好意思，网络出小差了，请重试"];
        [self refreshBankStatus];
    }else if (_stateModel.bankCardState == 30) {
        //借钱
        [self getCoodinate];
        [EventHanlder trackLoanVerifyEventWithProductName:nil amount:[self.model.amount toFloat] dayLimit:[[self.model.timeLimit stringByReplacingOccurrencesOfString:@"天" withString:@""] integerValue] fee:[self.calculateModel.feeDetail.interest toFloat] auditFee:[self.calculateModel.feeDetail.infoAuthFee toFloat] accountManamageFee:[self.calculateModel.feeDetail.serviceFee toFloat] realAmount:[self.model.realAmount toFloat]];
        
    }else{
        //绑卡
        [self bindingCardBtnClick:nil];
    }
}

- (IBAction)protocolBtnClick:(id)sender {
    _protocolBtn.selected = !_protocolBtn.selected;
    _agree = _protocolBtn.selected;
    [_protocolBtn setBackgroundImage:[UIImage imageNamed:!_protocolBtn.selected ? @"checkBox-n" : @"checkbox-s"] forState:UIControlStateNormal];
    
}


- (void)bandingCard{
    //绑卡
    WS(weakSelf)
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    vc.reBind = YES;
    vc.bindSuccessBlock =  ^(NSString *bankName, NSString *bankNumber, NSString *url) {
        NSLog(@"bankName == %@ bankNumber == %@",bankName,bankNumber);
        [weakSelf refreshBankStatus];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cardNumberLabel.text = [NSString encodeBankCardNumberWithCardNumber:bankNumber];
            weakSelf.bindingBGView.hidden = YES;
            [weakSelf.bankLogoImgV setImage:[UIImage imageNamed:[NSString getBankImageNameWithBankName:bankName]]];
            weakSelf.bankLogoImgV.hidden = NO;
            weakSelf.cardNumberLabel.hidden = NO;
        });
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bindingCardBtnClick:(id)sender {
    [self bandingCard];
}


- (void)getCoodinate {
    WS(weakSelf)
#pragma mark -- test
    /*
    if (![FyAuthorizationUtil allowLocation]) {
        [FyAuthorizationUtil showRequestLoacationTipFromViewController:self autoPop:YES];
        return;
    }
    [self showGif];
    
    [self getLoactionCoordinate:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        weakSelf.coordinate = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
        weakSelf.address = regeocode.formattedAddress;
        NSLog(@"address == %@  _coordinate == %@",regeocode.formattedAddress,weakSelf.coordinate);
        [weakSelf hideGif];
        [weakSelf checkParam];
        
    }];
  */
    [self checkParam];

}

- (void)checkParam {
#pragma mark -- -test
    /*
    if (!_model.isPwd) {
        //设置密码 支付
        [FyPwdUtil configPwdWithnetBeginBlock:^{
            [self showGif];
        } complete:^(NSString *pwd1, NSString *pwd2, BOOL success, NSString *message) {
            [self hideGif];
            if (success) {
                self.model.isPwd = YES;
                [self doRequestWithPwd:pwd1];
            }else{
                [self fy_toastMessages:message];
            }
        }];
    }else{
        //支付
        [FyPwdUtil checkPwdWithShowTitle:_model.amount Complete:^(NSString *pwd) {
            [self doRequestWithPwd:pwd];
        } forgetPwd:^{
            [self forgetPwd];
        }];
    }
    */
    //支付
    [FyPwdUtil checkPwdWithShowTitle:_model.amount Complete:^(NSString *pwd) {
        [self doRequestWithPwd:pwd];
    } forgetPwd:^{
        [self forgetPwd];
    }];
    
}

- (void)forgetPwd{
    //忘记交易密码
    FyForgetPayPwdViewController *vc = [[FyForgetPayPwdViewController alloc] init];
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)doRequestWithPwd:(NSString *)pwd{
    NSLog(@"贷款操作");
    
    FyLoanApplyRequest *t = [[FyLoanApplyRequest alloc] init];
    t.address = self.address;
    t.coordinate = self.coordinate;
    t.amount = self.model.amount;
    t.cardId = self.model.cardId;
    t.fee = self.model.fee;
    t.realAmount = self.model.realAmount;
    t.timeLimit = self.model.timeLimit;
    t.tradePwd = pwd;
    t.userId = [FyUserCenter sharedInstance].userId ? : @"";
    
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            NSDate *date = [NSDate date];
            NSString *dateStr = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSLog(@"dateStr == %@",dateStr);
            NSLog(@"date.hour == %ld",(long)date.hour);
            
//            if (date.hour < 6) {
//                [self loadTipView];
//            }else{
//                [self loadSuccessView];
//            }
            [self loadSuccessView];
            [EventHanlder trackCommitTradersPwdEventWithSuccess:YES];
        }else{
            [EventHanlder trackCommitTradersPwdEventWithSuccess:NO];
            if (error.errorCode == 401){
                [self LPShowAletWithContent:@"密码错误，请重新输入" left:@"找回密码" right:@"确定" leftClick:^{
                    [self forgetPwd];
                } rightClick:^{
                    [self checkParam];
                }];
            }
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [EventHanlder trackCommitTradersPwdEventWithSuccess:NO];
        [self hideGif];
        
    }];
}


- (void)loadTipView{
    WS(weakSelf)
    FySuccessView *view = [FySuccessView loadNib];
    view.popBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    view.tipLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    view.tipLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    view.tipLabel.numberOfLines = 0;
    
    NSString *str = [NSString  stringWithFormat:@"因0:00至6:00系统核账，会造成审核延迟，对您造成的不便，请谅解~如有问题，请致电客服%@（9:00~18:00）", [FyH5PageUtil phoneNumber]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = [UIColor subTextColor];
    text.yy_lineSpacing = 5;
    NSString *str1 = [FyH5PageUtil phoneNumber];
    NSRange range1 = [str rangeOfString:str1 ];
    
    [text yy_setTextHighlightRange:range1
                             color:[UIColor colorWithHexString:@"0080f0"]
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             
                             NSLog(@"点击了电话");
                             [FyH5PageUtil call];
                         }];
    
    view.tipLabel.attributedText = text;
    [view show];

}

- (void)loadSuccessView{
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.dismissBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    };
    
    [view show];

}


- (void)getLoactionCoordinate:(AMapLocatingCompletionBlock)block{
    NSLog(@"实现分类方法");
    if (![FyAuthorizationUtil allowLocation]) {
        [FyAuthorizationUtil showRequestLoacationTipFromViewController:self autoPop:YES];
        return;
    }
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
}

-(void)setLocationManagerForHundredMeters{
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //2.定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
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
