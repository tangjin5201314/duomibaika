//
//  FyBindingBankViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBindingBankViewController.h"
#import "FYCardBin.h"
#import "RichLabel.h"
#import "FyUerApproveInfoRequest.h"
#import "FyH5PageUtil.h"
#import "RDWebViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NSString+Validation.h"
#import "NSString+LPAddtions.h"
//#import "LLPaySdk.h"
#import "FySaveBankCardRequest.h"
#import "FyBankAuthSignRequest.h"
#import "FyBankSelectViewController.h"
#import "FyAffirmAlertView.h"
#import "JVFloatLabeledTextField.h"
#import <LLTokenPaySDK.h>

/*************global const variables and macros*****/
//the max length of card number
static const int kCardNumberLen       = 19;
//the format space of card number
static const int kCardSpaceStep       = 4;

//the exception string
static NSString *kExceptionStr =  @"0123456789\b";
/**************************************************/


@interface FyBindingBankViewController ()<UITextFieldDelegate>{
    FyApproveInfoModel *infoModel;
    NSString *_bankName;
    BOOL _agreeProtocol;
    UIButton *_backBtn;
    UIButton *_supportBtn;
    UILabel *_titleLabel;
    CGRect lastFrame;

}

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *banknameLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumberTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITableViewCell *commitCell;

@property (nonatomic, strong) FYCardBin *carBin;

@end

@implementation FyBindingBankViewController

- (FYCardBin *)carBin{
    if (!_carBin) {
        __weak typeof(self) wSelf = self;
        _carBin = [[FYCardBin alloc] initWithSuccessBlock:^(FYCardBinModel *cardModel) {
            if (cardModel.bankName.length > 0) {
                wSelf.banknameLabel.text = cardModel.bankName;
                [wSelf.iconView sd_setImageWithURL:[NSURL URLWithString:cardModel.greyImgUrl]];
            }
        }];
    }
    return _carBin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
   
    [self layoutNavigationItems];
    self.fy_navigationBarColor = self.fy_navigationBarLineColor = [UIColor clearColor];

    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    [self.phoneTF setPlaceholder:@"请输入银行预留手机号" floatingTitle:@"银行预留手机号"];
    self.title = self.reBind ? @"重绑银行卡" : @"银行卡认证";
    _agreeProtocol = YES;
    _bankCardNumberTF.delegate = self;
    _phoneTF.delegate = self;
    [_bankCardNumberTF setValue:[UIColor fy_colorWithHexString:@"#cecefb"] forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTF.placeholderColor = [UIColor subTextColorV2];
    _phoneTF.textColor = [UIColor textColorV2];
    _phoneTF.text = [FyUserCenter sharedInstance].userName;
//    暂时屏蔽协议
//    [self configProcotol];
    self.protocolBtn.hidden = YES;
    
    [self requestOpearatorInfo];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.view.frame, lastFrame)) {
        lastFrame = self.view.frame;
        CGFloat h = MAX(200, CGRectGetHeight(self.view.frame) - 300 - 100);
        [self cell:self.commitCell setHeight:h];
        [self reloadDataAnimated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //默认状态栏颜色为白色
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)layoutNavigationItems{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[self zd_createBackButton]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightBtn]];
    
    self.navigationItem.leftBarButtonItems = @[leftItem];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.navigationItem.titleView = [self titleLabel];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.text = @"绑定银行卡";
        [titleLabel sizeToFit];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton *)rightBtn{
    if (!_supportBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.frame = CGRectMake(0, 0, 90, 26);
        [btn setTitle:@"支持银行" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(supportBank) forControlEvents:UIControlEventTouchUpInside];

        _supportBtn = btn;
    }
    return _supportBtn;
}

-(UIButton *) zd_createBackButton{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.frame = CGRectMake(0, 0, 60, 32);
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [backBtn addTarget:self action:@selector(bk_popself) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"topbar-back"] forState:UIControlStateNormal];
        _backBtn = backBtn;
    }
    return _backBtn;
}

- (void)bk_popself{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)configProcotol{
    NSString * protocolName = @"《委托代扣款授权书》";
    
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

- (void)requestOpearatorInfo{
    [self showGif];
    
    FyUerApproveInfoRequest *task = [[FyUerApproveInfoRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        infoModel = model;
        
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self hideGif];
            _idCardLabel.text = [NSString getNewIDNumWitOldIDNum:infoModel.idNo];
            _nameLabel.text = [NSString getDisplayNameWitName:infoModel.name];
        }else{
            [self hideGif];
            [self LPShowAletWithContent:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
    }];
    
}

- (void)pushToProtocol{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"委托代扣款授权书";
    vc.url = [FyH5PageUtil urlPathWithType:FyH5PageTypeBindCard];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToScan{//扫描银行卡
  /*
    MGBankCardManager *cardManager = [[MGBankCardManager alloc] init];
    cardManager.orientation = MGBankCardOrientationLandscape;
    cardManager.viewType = MGBankCardViewCardBox;
    [cardManager CardStart:self finish:^(MGBankCardModel * _Nullable result) {
        [self performSelector:@selector(configModel:) withObject:result afterDelay:0.5];
//        [self configModel:result];
    }];
    */
}

- (void)saveWithButton:(UIButton *)button{
    [self.tableView endEditing:YES];
    NSString *errorMsg;
    
    if (!_agreeProtocol) {
        [self LPShowAletWithTitle:@"请先同意《委托代扣款授权书》" Content:@"" left:@"取消" right:@"确定" rightClick:^{
        }];
        return;
    }
    
    if ([[FyUserCenter sharedInstance].userId integerValue] != 1) {
        if (self.banknameLabel.text.length == 0 || [self.banknameLabel.text isEqualToString:@"请选择开户银行"]) {
            [self LPShowAletWithContent:@"请选择开户银行"];
            return;
        }
    }
    
    if (![[self trimCardNumber:_bankCardNumberTF.text] validationType:ValidationTypeBankCard]){
        errorMsg = @"请输入正确的银行卡号";
        [self LPShowAletWithContent:errorMsg];
    }else if (![[self trimCardNumber:_phoneTF.text] validationType:ValidationTypePhone]){
        errorMsg = @"请输入正确的手机号码";
        [self LPShowAletWithContent:errorMsg];
    }
    else{
        WS(wSelf);
        self.commitBtn.enabled = NO;
        [self showGif];
        [self.carBin loadCardNameIfNeedSuccessBlock:^(FYCardBinModel *cardModel) {
            [wSelf bindingCardWithCardBinModel:cardModel];
        }];
//        FYCardBinModel *cardModel = [[FYCardBinModel alloc] init];
//        cardModel.cardNo = @"6228230127052880162";
//        cardModel.bankName = @"中国农业银行";
//        cardModel.isSupport = YES;
//        cardModel.bankCode = @"CBBC";
//        [wSelf bindingCardWithCardBinModel:cardModel];
    }
}

- (void)bindingCardWithCardBinModel:(FYCardBinModel *)cardModel{
    if (cardModel && cardModel.bankName.length && cardModel.bankCode.length) {
        NSString *bankNumberString= [_bankCardNumberTF.text LPTrimString];
        
        if (!cardModel.isSupport) {
            self.commitBtn.enabled = YES;
            [self hideGif];
            if (cardModel.cardType == 3) {//3表示信用卡
                [self LPShowAletWithContent:@"暂不支持信用卡"];
            }else{
                [self LPShowAletWithContent:@"暂不支持该银行"];
            }
        }else{
            FySaveBankCardRequest *task = [[FySaveBankCardRequest alloc] init];
            task.cardNO = bankNumberString;
            task.bank = cardModel.bankName;
            task.bindMob = _phoneTF.text;
            [self uploadBankCard:task button:self.commitBtn];

        }
    }else{
        self.commitBtn.enabled = YES;
        [self hideGif];
        
        [self fy_toastMessages:@"未识别银行卡"];
    }

}

-(void)uploadBankCard:(FySaveBankCardRequest *)task button:(UIButton *)btn{
    WS(weakSelf)
    btn.enabled = NO;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *t, FyResponse *error, id model) {
        btn.enabled = YES;
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            NSLog(@"%@",model);
            if (!model[@"token"]) {
                [weakSelf LPShowAletWithContent:@"绑卡失败"];
            } else {
                [weakSelf payToLLPay:model];
            }
        }else{
            btn.enabled = YES;
            [weakSelf LPShowAletWithContent:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        btn.enabled = YES;
        [weakSelf hideGif];
        [weakSelf fy_toastMessages:error.errorMessage];
    }];
}

- (void)payToLLPay:(NSDictionary *)data {
//    // 进行签名
//    [LLPaySdk sharedSdk].sdkDelegate = self;
//    //接入什么产品就传什么LLPayType
//    [[LLPaySdk sharedSdk] presentLLPaySignInViewController:self
//                                               withPayType:LLPayTypeVerify
//                                             andTraderInfo:data];
    WS(weakSelf)
    [[LLTokenPaySDK sharedSdk] signApply:data inVC:self complete:^(LLPayResult result, NSDictionary *dic) {
        [weakSelf paymentEnd:result withResultDic:dic];
    }];
}

#pragma - mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSLog(@"%@", dic)
    __block NSString *msg = @"异常";
    switch (resultCode) {
        case kLLPayResultSuccess: {
            [self showGif];
            WS(wSelf);
            [self.carBin loadCardNameIfNeedSuccessBlock:^(FYCardBinModel *cardModel) {
                [self hideGif];
                msg = @"成功";
                FyBankAuthSignRequest *task = [[FyBankAuthSignRequest alloc] init];
                task.agreeNO = [dic objectForKey:@"no_agree"] ?: @"";
                task.uuID = [FyUserCenter sharedInstance].userId ?: @"";
                task.bankCode = cardModel.bankCode ?: @"01030000";
                task.cardNO = [_bankCardNumberTF.text LPTrimString];
                task.bank = [_bankCardNumberTF.text getBankName];
                task.bindMob = _phoneTF.text;

                [wSelf signReturnActionWithTask:task];
            }];

        } break;
        case kLLPayResultFail: {
            msg = dic[@"ret_msg"];
            msg = msg.length ? msg : @"失败";
            [self LPShowAletWithContent:msg];

        } break;
        case kLLPayResultCancel: {
            msg = @"用户中途取消操作";
            [self LPShowAletWithContent:msg];

        } break;
        case kLLPayResultInitError: {
            msg = @"sdk初始化异常";

            [self LPShowAletWithContent:msg];

        } break;
        case kLLPayResultInitParamError: {
            msg = dic[@"ret_msg"];

            [self LPShowAletWithContent:msg];
        } break;
        default:
            break;
    }
}

//remove the space of string
- (NSString*)trimCardNumber:(NSString*)cardNumber{
    return [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)formatCardNumber:(NSString*)cardNumber{
    cardNumber = [self trimCardNumber:cardNumber];
    if (!cardNumber){
        return nil;
    }
    
    NSMutableString *formatCardNumber = [NSMutableString stringWithString:[cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    //insert space step by step,ex: 123456789015 -> 1234 56789015 -> 1234 5678 9015
    int insertPos = kCardSpaceStep;
    while(formatCardNumber.length > insertPos)
    {
        [formatCardNumber insertString:@" " atIndex:insertPos];
        insertPos += (kCardSpaceStep + 1);
    }
    
    return formatCardNumber;
}

- (void)configModel:(MGBankCardModel *)model {
    _bankCardNumberTF.text = [self formatCardNumber:model.bankCardNumber];
    _banknameLabel.text = model.bankNameString;
    self.carBin.cardNo = model.bankCardNumber;
    
    FyAffirmAlertView *alertView = [FyAffirmAlertView loadNib];
    alertView.fy_width = MAX(kScreenWidth-40, 300);
    alertView.fy_height = 182;
    alertView.tipLabel.text = @"信息有误将影响授信结果";
    alertView.titleKeyLabel.text = @"开户银行";
    alertView.subTitleKeyLabel.text = @"银行卡号";
    alertView.titeValueLabel.text = model.bankNameString;
    alertView.subTiteValueLabel.text = [self formatCardNumber:model.bankCardNumber];
    alertView.modifyBlock = ^{
        [self bankEditBtnClick:nil];
    };
    
    [alertView fy_Show];

}


- (IBAction)protocolBtnClick:(id)sender {
    _protocolBtn.selected = !_protocolBtn.selected;
    _agreeProtocol = _protocolBtn.selected;
    [_protocolBtn setBackgroundImage:[UIImage imageNamed:!_protocolBtn.selected ? @"checkBox-n" : @"checkbox-s"] forState:UIControlStateNormal];
}

- (IBAction)scanBtnClick:(id)sender {
    [FyAuthorizationUtil canReadCameraWithBlock:^(BOOL canRead, AVAuthorizationStatus authorStatus) {
        if (canRead) {
            [self pushToScan];
        }else{
            [FyAuthorizationUtil showRequestCameraTipFromViewController:self];
        }
    }];

}

- (IBAction)bindBtnClick:(id)sender {
    if (!_agreeProtocol) {
        [self LPShowAletWithContent:@"请先阅读并同意《委托代扣款授权书》"];
        return;
    }
    
    UIButton *btn = (UIButton *)sender;
    [self saveWithButton:btn];
}

- (IBAction)bankEditBtnClick:(id)sender {
    [_bankCardNumberTF becomeFirstResponder];
}


- (void)supportBank{
    FyBankSelectViewController *vc = [[FyBankSelectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//绑卡
-(void)signReturnActionWithTask:(FyBankAuthSignRequest *)task{
    [self showGif];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *t, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            if (self.bindSuccessBlock) {
                self.bindSuccessBlock(task.bank, _bankCardNumberTF.text, self.carBin.carBinModel.greyImgUrl);
            }
            [self LPShowAletWithContent:error.errorMessage dismissText:@"确定" okClick:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self LPShowAletWithContent:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];
    }];
    
}

#pragma mark - textField delegate methods
//do the formatting while textfield text is changing
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _phoneTF) {
        if (string.length == 0) return YES;
        
        NSString *phone = [_phoneTF.text stringByReplacingCharactersInRange:range withString:string];
        
        return phone.length <= 11;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:kExceptionStr];
    
    NSString *checkStr = [self trimCardNumber:string];
    if ([checkStr rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
        return NO;
    
    // -----process the textField text
    BOOL ret = NO;
    if([string length] <= 0)
    {
        // if received the backspace then delete one char
        NSString* text = textField.text;
        NSLog(@"slected range: location %ld, length %ld", (long)(unsigned long)range.location, (long)range.length);
        
        if(range.location == text.length - 1)
        {
            // delete the last char, because already delete one char, so it is text.length - 1
            
            //actually it will delete twice, first the backspace then delete the space
            if(text.length >=2 && [text characterAtIndex:text.length-2] == ' ')
            {
                [textField deleteBackward];
            }
            
            
            //must return YES here
            ret = YES;
        }
        else
        {
            // delete in the middle
            
            NSInteger offset = range.location;
            
            NSLog(@"seleted textrange %@", textField.selectedTextRange);
            
            if(range.location < text.length && [text characterAtIndex:range.location - 1] == ' ')
            {
                // Remove the character just before the cursor and redisplay the text.
                [textField deleteBackward];
                offset--;
            }
            [textField deleteBackward];
            
            //format the  string
            textField.text = [self formatCardNumber:textField.text];
            
            //reset the cursor pos
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        }
    }
    else
    {
        // insert chars in tail or in the middle
        
        NSLog(@"text len: %ld, string len: %ld, range len: %ld", (unsigned long)[self trimCardNumber:textField.text].length,
              (unsigned long)string.length, (unsigned long)range.length);
        //limit the number of digits
        //consider the paste and replace several charcters at one time,ex: 135169 -> 14169, that is:6 + 1 - 2 <19
        NSInteger editedCardNumberLen = [self trimCardNumber:textField.text].length + string.length - range.length;
        if(editedCardNumberLen <= kCardNumberLen)
        {
            //add the character text to the cursor and redisplay the text
            [textField insertText:string];
            
            //format the string
            textField.text = [self formatCardNumber:textField.text];
            
            //move the cursor to the new location
            NSInteger offset = range.location + string.length;
            for(int newLocation = kCardSpaceStep; newLocation <= kCardNumberLen; newLocation += (kCardSpaceStep + 1))
            {
                if(range.location == newLocation)
                {
                    offset++;
                    break;
                }
            }
            
            //reset the cursor pos
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        }
    }
    
    return ret;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _phoneTF) return;
    _bankCardNumberTF.text = textField.text;
    self.carBin.cardNo = _bankCardNumberTF.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _phoneTF) return;

    [self.carBin cancel];
}



@end
