//
//  YMLeaseTimeLimitViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseTimeLimitViewController.h"
#import "YMLeaseTimeLimitCell.h"
#import "FyPwdUtil.h"
#import "FyTradePwdView.h"
#import "FyLoanApplyRequestV2.h"
#import "EventHanlder.h"
#import "FySetLoginPwdViewController.h"
#import "FyAutoDismissResultView.h"
#import "UIView+fyShow.h"
#import "YMLeaseLimitModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "FyLoginUtil.h"
#import "YMTool.h"

static NSString *const kLeaseTimeLimitHeaderCell = @"kLeaseTimeLimitHeaderCell";

@interface YMLeaseTimeLimitViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) FyTradePwdView  *tradePwdView;
@property (nonatomic, strong) YMLeaseLimitModel  *limitManager;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *coordinate;
@end

@implementation YMLeaseTimeLimitViewController


//重写父类方法
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![FyAuthorizationUtil allowLocation]) {
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tradePwdView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 572;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMLeaseTimeLimitCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseTimeLimitHeaderCell];
    [cell displayWithModel:self.limitManager homeModel:self.model];
    WS(weakSelf)
    cell.applyBlock = ^(YMLeaseTimeLimitType type) {
        [weakSelf actionMethod:type];
    };
    return cell;
}

- (void)actionMethod:(YMLeaseTimeLimitType)type {
    if (type == YMLeaseTimeLimitDay7) {
        self.limitManager.dayType = 0;
        [self.tableView reloadData];
        return;
    }
    if (type == YMLeaseTimeLimitDay15) {
        self.limitManager.dayType = 1;
        [self.tableView reloadData];
        return;
    }
    if (type == YMLeaseTimeLimitLease) {
        [self toPay];
        return;
    }
}

- (void)toPay {
    WS(weakSelf)

//    先判断登录
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
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
            if (error) {
                [weakSelf fy_toastMessages:@"获取地理位置失败，请重试" hidenDelay:-1];
                return ;
            }
            [weakSelf checkParam];
        }];
    }
}

- (void)getLoactionCoordinate:(AMapLocatingCompletionBlock)block{
    NSLog(@"实现分类方法");
    if (![FyAuthorizationUtil allowLocation]) {
        [FyAuthorizationUtil showRequestLoacationTipFromViewController:self autoPop:YES];
        return;
    }
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
}

- (void)checkParam {
    WS(weakSelf)
    if ([FyUserCenter sharedInstance].payPwd == false) {
        //设置密码 支付
//        [self hiddenTradeView];
        self.tradePwdView = [FyPwdUtil configPwdWithnetBeginBlock:^{
            [weakSelf showGif];
        } complete:^(NSString *pwd1, NSString *pwd2, BOOL success, NSString *message) {
            [weakSelf hideGif];
            if (success) {
                [weakSelf doRequestWithPwd:pwd1];
            }else{
                [weakSelf fy_toastMessages:message];
            }
        }];
    }else{
        //支付
//        [self hiddenTradeView];
        self.tradePwdView = [FyPwdUtil checkPwdWithShowTitle:@"300" Complete:^(NSString *pwd) {
            [weakSelf doRequestWithPwd:pwd];
        } forgetPwd:^{
            [weakSelf forgetPwd];
        }];
    }

}

- (void)forgetPwd{
    //忘记交易密码
    [self hiddenTradeView];
    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    vc.pwdType = Pwd_ForgetPay;
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)doRequestWithPwd:(NSString *)pwd {
    NSLog(@"贷款操作");
    FyLoanApplyRequestV2 *t = [[FyLoanApplyRequestV2 alloc] init];
    if (self.model.mobile.udid.length == 0) {
        t.udid = CHECKNULL([YMTool getUdid]);
    } else {
        t.udid = self.model.mobile.udid;
    }
    t.phoneModel = CHECKNULL(self.model.mobile.phone_model);

    t.phoneMemory = [NSString stringWithFormat:@"%ld",[YMTool getDivceSizeInt]];
    t.coordinate = self.coordinate.length > 0 ? self.coordinate : @"";
    t.principal = @"0";
    
    YMHomePeriodListModel *listModel = self.model.periodList[self.limitManager.dayType];
    t.peroidValue = listModel.value;
    t.tradePwd = CHECKNULL(pwd);
    t.calculateMode = 3;
    t.loanUsage = @"";

    [self showGif];
    WS(weakSelf)
    [weakSelf hiddenTradeView];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            [weakSelf loadSuccessView];
            [EventHanlder trackCommitTradersPwdEventWithSuccess:YES];
        }else{
            [EventHanlder trackCommitTradersPwdEventWithSuccess:NO];
            
            if (error.errorCode == RDP2PAppErrorTypeTradePwdError){
                weakSelf.tradePwdView.pwdError = YES;
                [weakSelf fyShowAletWithContent:@"密码错误，请重新输入" left:@"找回密码" right:@"确定" leftClick:^{
                    [weakSelf forgetPwd];
                } rightClick:^{
                    [weakSelf toPay];
                }];
            }
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf hiddenTradeView];
        [EventHanlder trackCommitTradersPwdEventWithSuccess:NO];
        [self hideGif];
    }];
}

- (void)hiddenTradeView {
    [self.view endEditing:YES];
    [self.tradePwdView fy_Hidden];
    self.tradePwdView = nil;
}

- (void)loadSuccessView {
    [self.view endEditing:YES];
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.titleLabel.text = @"恭喜您，租赁成功";
    view.contentLabel.text = @"请您耐心等待，我们会尽快为您审核。";
    view.dismissBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYNOTIFICATION_LOAN object:nil];
    };
    [view show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupUI {
    self.title = @"租赁期限";
    self.limitManager = [[YMLeaseLimitModel alloc] init];
    
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(0);
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor bgColor];
        //        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLeaseBuyOutNormalCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseTimeLimitCell" bundle:nil] forCellReuseIdentifier:kLeaseTimeLimitHeaderCell];
//
    }
    return  _tableView;
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

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
