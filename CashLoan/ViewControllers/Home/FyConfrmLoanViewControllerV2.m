//
//  FyConfrmLoanViewControllerV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyConfrmLoanViewControllerV2.h"
#import "FyLoanDetailTextTreeCell.h"
#import "FyLoanDetailLightTextCell.h"
#import "RichLabel.h"
#import "RDWebViewController.h"
#import "FyH5PageUtil.h"
#import "FyDayTagView.h"
#import "NSString+FormatNumber.h"
#import "FyBindingBankViewController.h"
#import "FyLaonDetailDefaultTextCell.h"
#import "FyInStagesRateRequest.h"
#import "FyRepaySchedulePopView.h"
#import "NSString+LPAddtions.h"
#import "FySetLoginPwdViewController.h"
#import "FyPwdUtil.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "FyLoanApplyRequestV2.h"
#import "EventHanlder.h"
#import "FyAutoDismissResultView.h"
#import <LCActionSheet/LCActionSheet.h>
#import "AuthDictListModel.h"
#import "AuthDictService.h"
#import "FyLoanProtocolRequest.h"
#import "NSString+fyUrl.h"

#define numberFormatter @"###,###"
#define maxNumberCount 7
#define kDetailHeight 35

typedef void(^ActionBlock)();


@interface FyConfirmDetailsCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *values;

@end

@implementation FyConfirmDetailsCell
static NSString *const reuseaIdentifier_cell = @"reuseaIdentifier_cell";

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableView registerClass:[FyLoanDetailLightTextCell class] forCellReuseIdentifier:reuseaIdentifier_cell];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)setValues:(NSArray *)values{
    if (_values != values) {
        _values = values;
        
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FyInStagesAmountModel *model = self.values[indexPath.row];
    
    FyLoanDetailLightTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseaIdentifier_cell];
    if (!cell) {
        cell = [[FyLoanDetailLightTextCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.fyTextLabel.text = model.name;
    cell.fySubTextLabel.text = [model displayPrice];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kDetailHeight;
}

@end


@interface FyConfirmHeaderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *textfield;
@property (nonatomic, strong) IBOutlet UIButton *allBtn;
@property (nonatomic, strong) IBOutlet UIButton *clearBtn;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) IBOutlet FyDayTagView *tagView;

@property (nonatomic, copy) ActionBlock allBlock;
@property (nonatomic, copy) ActionBlock clearBlock;

- (void)scrollToVisible;

@end

@implementation FyConfirmHeaderCell

- (void)dealloc{
    NSLog(@"%s", __FUNCTION__);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}


- (void)scrollToVisible{
    [self.tagView scrollToVisible];
}

- (IBAction)handleAll:(id)sender{
    if (self.allBlock) {
        self.allBlock();
    }
}

- (IBAction)handleClear:(id)sender{
    if (self.clearBlock) {
        self.clearBlock();
    }
}
@end

@interface FyConfirmNoBankCardCell : UITableViewCell
@property (nonatomic, copy) ActionBlock bindBlock;
@end

@implementation FyConfirmNoBankCardCell

- (IBAction)handleBind:(id)sender{
    if (self.bindBlock) {
        self.bindBlock();
    }
}

@end

@interface FyConfirmBankCardCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *bankNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *cardNoLabel;

@end

@implementation FyConfirmBankCardCell
@end

@interface FyLoanUsageCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *fyTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *fySubTextLabel;

@end

@implementation FyLoanUsageCell
@end



@interface FyConfirmCommitCell : UITableViewCell

@property (nonatomic, copy) void (^agreeBlock)(BOOL);
@property (nonatomic, copy) ActionBlock commitBlock;
@property (nonatomic, strong) IBOutlet UIButton *agreeBtn;
@property (nonatomic, strong) IBOutlet UIButton *commitBtn;
@property (nonatomic, strong) IBOutlet RichLabel *richLabel;
@property (nonatomic, assign) BOOL agree;

@end

@implementation FyConfirmCommitCell

- (IBAction)handleAgree:(id)sender{
    self.agree = !self.agree;
}

- (IBAction)handleCommit:(id)sender{
    if (self.commitBlock) {
        self.commitBlock();
    }

}


- (void)setAgree:(BOOL)agree{
    _agree = agree;
    self.agreeBtn.selected = self.agree;
    if (self.agreeBlock) {
        self.agreeBlock(agree);
    }
}

@end

@interface FySelectDayMoneyModelV2 : NSObject

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *day;

@end

@implementation FySelectDayMoneyModelV2

@end


@interface FyConfrmLoanViewControllerV2 ()<UITextFieldDelegate, LCActionSheetDelegate>{
    NSURLSessionDataTask *_calculateTask;
    NSURLSessionDataTask *_protocolTask;

}

@property (nonatomic, assign) BOOL topOpen;
@property (nonatomic, assign) BOOL bottomOpen;
@property (nonatomic, assign) BOOL agree;

@property (nonatomic, strong) FyTradePwdView  *tradePwdView;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *coordinate;

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet FyConfirmHeaderCell *headerCell;
@property (nonatomic, weak) IBOutlet FyConfirmNoBankCardCell *noBankCardCell;
@property (nonatomic, weak) IBOutlet FyConfirmBankCardCell *bankCardCell;
@property (nonatomic, weak) IBOutlet FyConfirmCommitCell *commitCell;


@property (nonatomic, weak) IBOutlet FyLoanDetailTextTreeCell *topTreeCell;

@property (nonatomic, weak) IBOutlet FyLaonDetailDefaultTextCell *planStyleCell; //还款方式
@property (nonatomic, weak) IBOutlet FyLoanUsageCell *usageCell; //借款用途

@property (nonatomic, weak) IBOutlet FyLoanDetailTextTreeCell *bottomTreeCell;

@property (nonatomic, weak) IBOutlet FyConfirmDetailsCell *topDetailCell;
@property (nonatomic, weak) IBOutlet FyConfirmDetailsCell *bottomDetailCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *lineCell;

@property (nonatomic, weak) IBOutlet UITableViewCell *tempCell1; //临时的cell，某些情况下需要隐藏
@property (nonatomic, weak) IBOutlet UITableViewCell *tempCell2;
@property (nonatomic, weak) IBOutlet UITableViewCell *tempCell3;
@property (nonatomic, weak) IBOutlet UITableViewCell *tempCell4; //临时的cell，某些情况下需要隐藏
@property (nonatomic, weak) IBOutlet UITableViewCell *tempCell5; //临时的cell，某些情况下需要隐藏

@property (nonatomic, strong) FySelectDayMoneyModelV2 *selectModel;
@property (nonatomic, strong) FyInStagesRateModel *rateModel; //借款费率
@property (nonatomic, strong) AuthDictListModel *dictListModel;

@property (nonatomic, strong) FyProtocolListModel *protocolList; //协议列表

@end

@implementation FyConfrmLoanViewControllerV2

- (void)dealloc{
    [self.selectModel removeObserver:self forKeyPath:@"day"];
    [self.selectModel removeObserver:self forKeyPath:@"money"];
}

- (void)setTradePwdView:(FyTradePwdView *)tradePwdView{
    if (_tradePwdView != tradePwdView) {
        if (_tradePwdView) {
            [_tradePwdView fy_Hidden];
        }
        WS(weakSelf)
        tradePwdView.changeToTradePwdViewBlock = ^(FyTradePwdView *v) {
            weakSelf.tradePwdView = v;
        };
        _tradePwdView = tradePwdView;
    }
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
//        _locationManager.delegate = self;
        [self setLocationManagerForHundredMeters];
    }
    return _locationManager;
}

-(void)setLocationManagerForHundredMeters{
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //2.定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // tableView 偏移20/64适配
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor bgColor];
    self.fy_navigationBarColor = [UIColor whiteColor];
    [self loadNavigationItems];
    [self configCells];
    [self configCellAcitons];
    [self configProtocol];
    self.title = @"富卡";

    [self hiddenCellInNeed];
    [self addMoneyCalculateNotifify];

    [self defaultConfigs];
    _agree = NO;

    [self requestDictComplete:nil];

}

-(void)requestDictComplete:(void (^)(void))complete{
    [AuthDictService requestDictWithType:AuthDictTypeLoanUsage resultModel:^(AuthDictListModel *model, FyResponse *error) {
        if (model) {
            self.dictListModel = model;
        }
        else{
            [self fy_toastMessages:error.errorMessage];
        }
        if (complete) {
            complete();
        }
    }];
}

-(void)requestProtocolComplete:(void (^)(void))complete{
    FyLoanProtocolRequest *task = [[FyLoanProtocolRequest alloc] init];
    
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyProtocolListModel * model) {
        weakSelf.protocolList = model;
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete();
        }
    }];

}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configBank];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (![FyAuthorizationUtil allowLocation]) {
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:nil];
    }

}

- (void)loadNavigationItems{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"立马拿钱";
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor textColorV2];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    self.navigationItem.titleView = label;
    self.navigationItem.leftBarButtonItems = [self fy_createBackButton];
}

-(NSArray<UIBarButtonItem *>*) fy_createBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.frame = CGRectMake(0, 0, 60, 32);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    return @[[[UIBarButtonItem alloc] initWithCustomView:backBtn]];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addMoneyCalculateNotifify{
    [self.selectModel addObserver:self forKeyPath:@"day" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.selectModel addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.selectModel) {
        id newValue = change[NSKeyValueChangeNewKey];
        id oldValue = change[NSKeyValueChangeOldKey];
        
        if (![newValue isKindOfClass:[NSString class]]) {
            newValue = @"";
        }
        
        if (![oldValue isKindOfClass:[NSString class]]) {
            oldValue = @"";
        }


        if ([newValue doubleValue] != [oldValue doubleValue]) {
            [self calculateDetailRequest];
        }
    }
}

- (void)configCells{
    [self cell:self.topDetailCell setHidden:YES];
    [self cell:self.bottomDetailCell setHidden:YES];
    [self reloadDataAnimated:NO];

    self.topTreeCell.fyTextLabel.text = @"每期应还金额";
    self.topTreeCell.fySubTextLabel.text = @"0.00";
    
    self.bottomTreeCell.fyTextLabel.text = @"到账金额";
    self.bottomTreeCell.fySubTextLabel.text = @"0.00";
    
    self.planStyleCell.fyTextLabel.text = @"还款方式";
    self.planStyleCell.fySubTextLabel.text = @"等额本息";
    
//    self.topTreeCell.open = _topOpen;
//    self.bottomTreeCell.open = _bottomOpen;
    
    self.headerCell.clearBtn.hidden = YES;
    
    self.headerCell.textfield.delegate = self;
}

- (void)hiddenCellInNeed{
    if (self.loanModel.product.defaultLimit.length ==0 || self.loanModel.product.defaultPrice.length == 0) {
        [self hiddenDetailCells:YES];
    }
}

- (void)hiddenDetailCells:(BOOL)hidden{
    [self cell:self.tempCell1 setHidden:hidden];
    [self cell:self.tempCell2 setHidden:hidden];
    [self cell:self.tempCell3 setHidden:hidden];
    [self cell:self.tempCell4 setHidden:hidden];
    [self cell:self.tempCell5 setHidden:hidden];

    [self cell:self.planStyleCell setHidden:hidden];
    [self cell:self.usageCell setHidden:hidden];
    [self cell:self.topTreeCell setHidden:hidden];

    [self cell:self.topDetailCell setHidden:(hidden || !_topOpen)];
    [self cell:self.bottomDetailCell setHidden:(hidden || !_bottomOpen)];
    
    [self cell:self.bottomTreeCell setHidden:hidden];
    [self cell:self.lineCell setHidden:hidden];
    [self cell:self.commitCell setHidden:hidden];
    [self reloadDataAnimated:NO];
}

- (NSString *)maxCredit{
//    NSString *maxString = [self.loanModel.creditInfo.credit doubleValue] > [self.loanModel.product.singleMax doubleValue] ? self.loanModel.product.singleMax : self.loanModel.creditInfo.credit;
//    return maxString;
    return self.loanModel.creditInfo.credit;
}

- (void)defaultConfigs{
    self.selectModel.day = self.loanModel.product.defaultLimit;
    self.selectModel.money = self.loanModel.product.defaultPrice;
    self.headerCell.textfield.text = [self formatterStringWithString:self.loanModel.product.defaultPrice];
    self.headerCell.tagView.selectedValue = self.loanModel.product.defaultLimit;
    self.headerCell.tagView.dayStrArray = self.loanModel.product.periodValue;
    [self.headerCell scrollToVisible];
    
    if (self.headerCell.textfield.text.length > 0) {
        self.headerCell.textfield.font = [UIFont fontWithName:@"DINPro-Regular" size:40];
    }else{
        self.headerCell.textfield.font = [UIFont fontWithName:@"DINPro-Regular" size:24];
    }
    
    self.headerCell.textfield.placeholder = [NSString stringWithFormat:@"最高可借%@元", [NSString stringNumberFormatterWithDoubleAutoDot:[[self maxCredit] doubleValue]]];
    self.headerCell.tipLabel.text = self.loanModel.product.productInfo;
    
    self.headerCell.allBtn.hidden = self.loanModel.product.defaultPrice.length > 0;
    self.headerCell.clearBtn.hidden = self.loanModel.product.defaultPrice.length == 0;

    [self calculateDetailRequestIfNeed];

}

- (void)configBank{
    BOOL hasBankNo = self.loanModel.userInfo.bank.bankNo.length > 0;
    
    [self cell:self.bankCardCell setHidden:!hasBankNo];
    [self cell:self.noBankCardCell setHidden:hasBankNo];
    [self reloadDataAnimated:NO];
    
    self.bankCardCell.bankNameLabel.text = self.loanModel.userInfo.bank.bankName;
    self.bankCardCell.cardNoLabel.text = [NSString encodeBankCardNumberWithCardNumber:[self.loanModel.userInfo.bank.bankNo LPTrimString]];
    
}

- (void)pushToProtocolWithModel:(H5PageModel *)model{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = model.name;
    vc.url = [model.value fy_UrlString];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToProtocol{
    if (!self.protocolList) {
        [self showGif];
        [self requestProtocolComplete:^{
            [self hideGif];
            if (self.protocolList) {
                [self pushToProtocol];
            }
        }];
        return;
    }
    
    NSMutableArray *tempArr = [@[] mutableCopy];
    for (H5PageModel *m in self.protocolList.list) {
        [tempArr addObject:m.name];
    }
    WS(weakSelf)
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:tempArr];
    actionSheet.clickedHandler = ^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            [weakSelf pushToProtocolWithModel:weakSelf.protocolList.list[buttonIndex-1]];
        }
    };

    actionSheet.titleFont = [UIFont systemFontOfSize:18];
    actionSheet.titleColor = [UIColor textColorV2];
    actionSheet.buttonFont = [UIFont systemFontOfSize:17];
    actionSheet.buttonColor = [UIColor textColorV2];
    actionSheet.unBlur = YES;
    [actionSheet show];

    
}

- (void)configProtocol{
    NSString *protocolName = @"《富卡借款协议》";
    self.commitCell.richLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.commitCell.richLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    self.commitCell.richLabel.numberOfLines = 1;
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
    
    self.commitCell.richLabel.attributedText = text;
}

- (void)configCellAcitons{
    WS(weakSelf)
    
    self.topTreeCell.openBlock = ^(BOOL open) {
        [weakSelf openTopTree:open];
    };
    
    self.topTreeCell.helpBlock = ^{
        [weakSelf showRepaySchedule];
    };
    
    self.bottomTreeCell.openBlock = ^(BOOL open) {
        [weakSelf openBottomTree:open];
    };
    
    self.headerCell.tagView.selectIndexBlock = ^(NSInteger index) {
        FyPeriodModel *limitModel = weakSelf.loanModel.product.periodValue[index];
        weakSelf.selectModel.day = limitModel.value;
        [weakSelf calculateDetailRequestIfNeed];
    };
    
    self.headerCell.allBlock = ^{
        weakSelf.headerCell.textfield.text = [weakSelf formatterStringWithString:[weakSelf maxCredit]];
        weakSelf.headerCell.textfield.font = [UIFont fontWithName:@"DINPro-Regular" size:40];
        weakSelf.headerCell.allBtn.hidden = YES;
        weakSelf.headerCell.clearBtn.hidden = NO;

        [weakSelf calculateDetailRequestIfNeed];
    };
    
    self.headerCell.clearBlock = ^{
        weakSelf.headerCell.textfield.text = @"";
        weakSelf.headerCell.textfield.font = [UIFont fontWithName:@"DINPro-Regular" size:24];
        weakSelf.headerCell.allBtn.hidden = NO;
        weakSelf.headerCell.clearBtn.hidden = YES;
        [weakSelf calculateDetailRequestIfNeed];
    };
    
    self.noBankCardCell.bindBlock = ^{
        [weakSelf bandingCard];
    };
    
    self.commitCell.commitBlock = ^{
        [weakSelf commitIfNeed];
    };
    

    self.commitCell.agreeBlock = ^(BOOL agree) {
        weakSelf.agree = agree;
    };
}

- (void)openBottomTree:(BOOL)open{
    _bottomOpen = open;
    [self cell:self.lineCell setHidden:!open];
    [self cell:self.bottomDetailCell setHidden:!open];
    [self reloadDataAnimated:NO];

}

- (void)openTopTree:(BOOL)open{
    _topOpen = open;
    [self cell:self.topDetailCell setHidden:!open];
    [self reloadDataAnimated:NO];
}


- (void)showRepaySchedule{
    FyRepaySchedulePopView *view = [FyRepaySchedulePopView loadNib];
    view.repaySchedule = self.rateModel.repaySchedule;
    view.fyTouchDismiss = YES;
    view.fyShowStyle = FyViewShowStyleCenter;
    view.fy_height = MIN(400, self.rateModel.repaySchedule.count * 44 + 65);
    [view fy_Show];
}

- (void)bandingCard{
    //绑卡
    WS(weakSelf)
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    vc.reBind = YES;
    vc.bindSuccessBlock =  ^(NSString *bankName, NSString *bankNumber, NSString *imageUrl) {
        weakSelf.loanModel.userInfo.bank.bankName = bankName;
        weakSelf.loanModel.userInfo.bank.bankNo = bankNumber;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commitIfNeed{
    [self.view endEditing:YES];
#pragma mark -- test
    /*
    if (self.selectModel.money.length == 0) {
        [self fy_toastMessages:@"请填写借款金额"];
        return;
    }

    if (self.selectModel.day.length == 0) {
        [self fy_toastMessages:@"请选择借款期限"];
        return;
    }

    if (!_agree) {
        [self fy_toastMessages:@"请先阅读并同意《富卡借款协议》"];
        return;
    }

    if (self.loanModel.userInfo.bank.bankNo.length > 0) {
        //借钱
        [self commitAciton];
    }else{
        //绑卡
        [self LPShowAletWithContent:@"您尚未绑定银行借记卡" left:@"取消" right:@"去绑定" rightClick:^{
            [self bandingCard];
        }];
    }
    */
    [self commitAciton];

}


- (void)commitAciton {
    WS(weakSelf)
#pragma mark -- test
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
//    [weakSelf checkParam];

}

- (void)getLoactionCoordinate:(AMapLocatingCompletionBlock)block{
    NSLog(@"实现分类方法");
    if (![FyAuthorizationUtil allowLocation]) {
        [FyAuthorizationUtil showRequestLoacationTipFromViewController:self autoPop:YES];
        return;
    }
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
}


- (void)calculateDetailRequestIfNeed{
    if (self.headerCell.textfield.text.length == 0){
        self.selectModel.money = @"";
        return;
    }
    
    NSString *accountString = [self orignStringWithFormatterString:self.headerCell.textfield.text];
    
    //借款金额小于最小借款金额
    if ([accountString doubleValue] < [self.loanModel.product.singleMin doubleValue]) {
        [self fy_toastMessages:[NSString stringWithFormat:@"最小输入金额为%@", [NSString stringNumberFormatterWithDoubleAutoDot:[self.loanModel.product.singleMin doubleValue]]]];
        accountString = self.loanModel.product.singleMin;
        
    }
    
    //借款金额大于最大借款金额
    if ([accountString doubleValue] > [[self maxCredit] doubleValue]) {
        [self fy_toastMessages:@"输入金额超过可借金额"];
        accountString = [self maxCredit];
    }

    
    NSInteger account = [accountString integerValue];
    NSInteger step = self.loanModel.product.step > 0 ?  self.loanModel.product.step : 100;
    if (account % step > 0) { //化为100的倍数
        account = account/step*step;
        [self fy_toastMessages:[NSString stringWithFormat:@"输入金额为%ld的倍数", (long)step]];
    }
    
    self.headerCell.textfield.text = [self formatterStringWithString:[NSString stringWithFormat:@"%ld", (long)account]];

    self.selectModel.money = [self orignStringWithFormatterString:self.headerCell.textfield.text];
}

- (void)configRateUI{
    BOOL isEditing = [self.headerCell.textfield isFirstResponder];
    [self cell:self.topDetailCell setHeight:kDetailHeight*[self validAvgAmountDetails].count];
    [self cell:self.bottomDetailCell setHeight:kDetailHeight*[self validArrivalDetails].count];
    [self reloadDataAnimated:NO];
    
    WS(weakSelf)
    if ([self validArrivalDetails].count == 0) {
        [self openBottomTree:NO];
        self.bottomTreeCell.openBlock = nil;
    }else{
        self.bottomTreeCell.openBlock = ^(BOOL open) {
            [weakSelf openBottomTree:open];
        };
    }
    
    if ([self validAvgAmountDetails].count == 0) {
        [self openTopTree:NO];
        self.topTreeCell.openBlock = nil;
    }else{
        self.topTreeCell.openBlock = ^(BOOL open) {
            [weakSelf openTopTree:open];
        };

    }
    
    
    if (isEditing) {
        [self.headerCell.textfield becomeFirstResponder];
    }
    
    self.planStyleCell.fySubTextLabel.text = self.rateModel.calculateMode;
    self.topDetailCell.values = [self validAvgAmountDetails];
    self.bottomDetailCell.values = [self validArrivalDetails];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"约" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor weakTextColor]}];
    NSAttributedString *str1= [[NSAttributedString alloc] initWithString:[self.rateModel displayAvgAmount] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor textColorV2]}];
    
    [str appendAttributedString:str1];
    self.topTreeCell.fySubTextLabel.attributedText = str;
    self.bottomTreeCell.fySubTextLabel.text = [self.rateModel displayArrival];
}

- (NSArray *)validArrivalDetails{
    NSMutableArray *tempAtrr = [@[] mutableCopy];
    for (FyInStagesAmountModel *model in self.rateModel.arrivalDetails) {
        if ([model.price doubleValue] > 0) {
            [tempAtrr addObject:model];
        }
    }
    return tempAtrr;
}

- (NSArray *)validAvgAmountDetails{
    NSMutableArray *tempAtrr = [@[] mutableCopy];
    for (FyInStagesAmountModel *model in self.rateModel.avgAmountDetails) {
        if ([model.price doubleValue] > 0) {
            [tempAtrr addObject:model];
        }
    }
    return tempAtrr;
}


- (void)calculateDetailRequest{
    if (self.selectModel.money.length == 0 || self.selectModel.day.length == 0) return;
    [_calculateTask cancel];
    
    [self hiddenDetailCells:NO];
    
    FyInStagesRateRequest *t = [[FyInStagesRateRequest alloc] init];
    t.peroidValue = self.selectModel.day;
    t.principal = self.selectModel.money;
    t.calculateMode = 2;

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rate" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"%@", jsonString);
//        self.rateModel = [FyInStagesRateModel mj_objectWithKeyValues:jsonString];
//        [self configRateUI];
//
//    });
    
    WS(weakSelf)
    _calculateTask = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (model) {
            weakSelf.rateModel = model;
            [weakSelf configRateUI];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {

    }];
}


- (void)checkParam {
#pragma mark -- test
    /*
    if ([FyUserCenter sharedInstance].payPwd == false) {
        //设置密码 支付
        self.tradePwdView = [FyPwdUtil configPwdWithnetBeginBlock:^{
            [self showGif];
        } complete:^(NSString *pwd1, NSString *pwd2, BOOL success, NSString *message) {
            [self hideGif];
            if (success) {
//                self.model.isPwd = YES;
                [self doRequestWithPwd:pwd1];
            }else{
                [self fy_toastMessages:message];
            }
        }];
    }else{
        //支付
        self.tradePwdView = [FyPwdUtil checkPwdWithShowTitle:self.selectModel.money Complete:^(NSString *pwd) {
            [self doRequestWithPwd:pwd];
        } forgetPwd:^{
            [self forgetPwd];
        }];
    }
    */
    //支付
    self.tradePwdView = [FyPwdUtil checkPwdWithShowTitle:self.selectModel.money Complete:^(NSString *pwd) {
        [self doRequestWithPwd:pwd];
    } forgetPwd:^{
        [self forgetPwd];
    }];
}

- (void)forgetPwd{
    //忘记交易密码
    self.tradePwdView = nil;
    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    vc.pwdType = Pwd_ForgetPay;
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)doRequestWithPwd:(NSString *)pwd{
    NSLog(@"贷款操作");
    
    FyLoanApplyRequestV2 *t = [[FyLoanApplyRequestV2 alloc] init];
    t.coordinate = self.coordinate;
    t.principal = self.selectModel.money;
    t.peroidValue = [self.selectModel.day integerValue];
    t.tradePwd = pwd;
    t.calculateMode = 2;
    t.loanUsage = self.usageCell.fySubTextLabel.text;
    
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            self.tradePwdView = nil;

            [self loadSuccessView];
            [EventHanlder trackCommitTradersPwdEventWithSuccess:YES];
        }else{
            [EventHanlder trackCommitTradersPwdEventWithSuccess:NO];

            if (error.errorCode == RDP2PAppErrorTypeTradePwdError){
                self.tradePwdView.pwdError = YES;

                [self fyShowAletWithContent:@"密码错误，请重新输入" left:@"找回密码" right:@"确定" leftClick:^{
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

- (void)loadSuccessView{
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.dismissBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYNOTIFICATION_LOAN object:nil];
    };
    
    [view show];
}


- (NSString *)formatterStringWithString:(NSString *)string{
    if (string.length == 0) {
        return @"";
    }
    return [NSString stringFormatString:numberFormatter doubleValue:[string doubleValue]];
}

- (NSString *)orignStringWithFormatterString:(NSString *)string{
    if (string.length == 0) {
        return @"";
    }
    return [NSString stringWithFormat:@"%0.0f", [NSString numberFormatString:numberFormatter stringValue:string]];
}

- (FySelectDayMoneyModelV2 *)selectModel{
    if (!_selectModel) {
        _selectModel = [[FySelectDayMoneyModelV2 alloc] init];
    }
    return _selectModel;
}

#pragma mark - UITextFieldDelegate
//输入框限制位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *targetString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (targetString.length > 0) {
        textField.font = [UIFont fontWithName:@"DINPro-Regular" size:40];
    }else{
        textField.font = [UIFont fontWithName:@"DINPro-Regular" size:24];
        
    }

    self.headerCell.allBtn.hidden = targetString.length > 0;
    self.headerCell.clearBtn.hidden = targetString.length == 0;

    return  targetString.length <= maxNumberCount;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = [self orignStringWithFormatterString:textField.text];
    self.tableView.scrollEnabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.text = [self formatterStringWithString:textField.text];

    [self calculateDetailRequestIfNeed];
    self.tableView.scrollEnabled = YES;

}

//借款用途按钮点击
- (void)loanUsageBtnClick:(id)sender {
    //actionsheet
    
    if (!self.dictListModel) {
        [self showGif];
        [self requestDictComplete:^{
            [self hideGif];
            if (self.dictListModel) {
                [self loanUsageBtnClick:nil];
            }
        }];
        return;
    }
    
    NSMutableArray *tempArr = [@[] mutableCopy];
    for (AuthDictModel *m in self.dictListModel.loanPurposeList) {
        [tempArr addObject:m.value];
    }
    WS(weakSelf)
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"选择借款用途" delegate:nil cancelButtonTitle:@"取消" otherButtonTitleArray:tempArr];
    actionSheet.clickedHandler = ^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            weakSelf.usageCell.fySubTextLabel.text = tempArr[buttonIndex - 1];
        }
    };
    actionSheet.titleFont = [UIFont systemFontOfSize:18];
    actionSheet.titleColor = [UIColor textColorV2];
    actionSheet.buttonFont = [UIFont systemFontOfSize:17];
    actionSheet.buttonColor = [UIColor textColorV2];
    actionSheet.unBlur = YES;
    [actionSheet show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.usageCell) {
        [self loanUsageBtnClick:nil];
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
