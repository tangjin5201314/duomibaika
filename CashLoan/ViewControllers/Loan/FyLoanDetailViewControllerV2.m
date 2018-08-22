//
//  FyLoanDetailViewControllerV2.m
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanDetailViewControllerV2.h"
#import "FyBillHeaderCell.h"
#import "FyBillRepaymentPlanTitleCell.h"
#import "FyBillDetailRepaymentPlanCell.h"
#import "NSString+FormatNumber.h"
#import "FyLoanDetailRequest.h"
#import "RDWebViewController.h"
#import <LCActionSheet/LCActionSheet.h>
#import "FyLoanProtocolRequest.h"
#import "NSString+fyUrl.h"


#define maxPullDownDistance 150
#define numberFormatter @"###,##0.00"
#define numberFormatterNoDot @"###,###"

@interface FyLoanDetailViewControllerV2 (){
    UIButton *_backBtn;
    UIButton *_protocolBtn;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) FyProtocolListModel *protocolList; //协议列表


@end

@implementation FyLoanDetailViewControllerV2

static NSString *cellIdentifier_header = @"cellIdentifier_header";
static NSString *cellIdentifier_title = @"cellIdentifier_title";
static NSString *cellIdentifier_plan = @"cellIdentifier_plan";

- (NSString *)displayBankCardNameAndNo{
    if (self.orderModel.bank.bankName) {
        if (self.orderModel.bank.bankNo.length > 4) {
            return  [NSString stringWithFormat:@"%@(%@)",self.orderModel.bank.bankName,[self.orderModel.bank.bankNo substringFromIndex:self.orderModel.bank.bankNo.length - 4]];
        }else{
            return  [NSString stringWithFormat:@"%@(%@)",self.orderModel.bank.bankName,self.orderModel.bank.bankNo];

        }
    }
    return  nil;
}

- (NSAttributedString *)psDisplayAttributedString{
    if (self.orderModel.ps.length == 0) {
        return nil;
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.orderModel.ps attributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.4]}];

    NSRange range = [self.orderModel.ps rangeOfString:self.orderModel.boldPs];
    if (range.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1 alpha:0.6] range:range];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:range];
    }
    return attributedStr;
}

- (NSAttributedString *)amountDisplayAttributedString{
    NSString *amoutString = [NSString stringFormatString:numberFormatterNoDot doubleValue:[self.orderModel.principal doubleValue]];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:amoutString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"DINPro-Regular" size:40]}];
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"元" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"DINPro-Regular" size:18]}]];
    return [attributedStr copy];
}

- (NSAttributedString *)dayLimitDisplayAttributedString{
    if (!self.orderModel.peroid) {
        return nil;
    }
    NSString *timeString = [self numberStringFromString:self.orderModel.peroid.name];
    NSString *unitString = [self.orderModel.peroid.name stringByReplacingOccurrencesOfString:timeString withString:@""];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:timeString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"DINPro-Regular" size:40]}];
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:unitString attributes:@{NSFontAttributeName : [UIFont fontWithName:@"DINPro-Regular" size:18]}]];
    return [attributedStr copy];
}

- (NSString *)numberStringFromString:(NSString *)string{
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *str =[string stringByTrimmingCharactersInSet:nonDigits];
    return str.length > 0 ? str : @"0";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -maxPullDownDistance) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -maxPullDownDistance);
    }
    
    if (self.isViewLoaded && self.view.window) {
        [self refreshNavigationLayout];
    }
}

- (void)refreshNavigationLayout{
    CGFloat alpha = self.tableView.contentOffset.y/(170-64);
    alpha = MAX(0, alpha);
    alpha = MIN(1, alpha);
    
    UIColor *navBgColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    
    if (alpha < 0.2) {
        navBgColor = [UIColor clearColor];
    }
    
    self.fy_navigationBarColor = [UIColor colorWithWhite:1 alpha:alpha];
    
    if (alpha > 0.9) {
        _protocolBtn.selected = YES;
        _backBtn.selected = YES;
        _protocolBtn.layer.borderColor = [UIColor textColorV2].CGColor;
        _titleLabel.textColor = [UIColor textColorV2];
        self.fy_navigationBarLineColor = [UIColor separatorColor];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
    }else{
        _protocolBtn.selected = NO;
        _backBtn.selected = NO;
        _protocolBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _titleLabel.textColor = [UIColor whiteColor];
        self.fy_navigationBarLineColor = [UIColor clearColor];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}


- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNavigationItems];
    self.fy_navigationBarColor = [UIColor clearColor];
    self.fy_navigationBarLineColor = [UIColor clearColor];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor bgColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillHeaderCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_header];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillRepaymentPlanTitleCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_title];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillDetailRepaymentPlanCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_plan];

    [self requestData];
}

-(void)requestData
{
    [self showGif];
    
    FyLoanDetailRequest *task = [[FyLoanDetailRequest alloc] init];
    task.borrowID = self.orderModel.orderId;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            ((FyOrderDetailModel *)model).orderId = self.orderModel.orderId;
            self.orderModel = model;
            
            [self.tableView reloadData];
        }
        [self hideGif];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
            [self fy_toastMessages:error.errorMessage];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self refreshNavigationLayout];

}

- (BOOL)fy_allowPullDown{
    return NO;
}

- (void)layoutNavigationItems{
    UIButton *rightBtn = [self rightBtn];

    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [tempView addSubview:rightBtn];

    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
        make.right.left.bottom.top.mas_equalTo(@0);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@65);

    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[self zd_createBackButton]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:tempView];

    
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
        titleLabel.text = @"账单详情";
        [titleLabel sizeToFit];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIButton *)rightBtn{
    if (!_protocolBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, 0, 90, 20);
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = POINTSIZE(1);
        btn.layer.cornerRadius = 10;
        [btn setTitle:@"借款协议" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor textColorV2] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(pushToProtocol) forControlEvents:UIControlEventTouchUpInside];

        _protocolBtn = btn;
    }
    return _protocolBtn;
}

-(UIButton *) zd_createBackButton{
    if (!_backBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.frame = CGRectMake(0, 0, 60, 32);
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [backBtn addTarget:self action:@selector(jk_popself) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"topbar-back"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateSelected];
        _backBtn = backBtn;
    }
    return _backBtn;
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

-(void)requestProtocolComplete:(void (^)(void))complete{
    FyLoanProtocolRequest *task = [[FyLoanProtocolRequest alloc] init];
    task.orderId = self.orderModel.orderId;
    
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


- (void)jk_popself{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.orderModel.repayPlan.count > 0 ? 1 : 0;
    }
    if(section == 2){
        return self.orderModel.repayPlan.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FyBillHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_header forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.amountLabel.attributedText = [self amountDisplayAttributedString];
        cell.dayLimitLabel.attributedText = [self dayLimitDisplayAttributedString];
        cell.psLabel.attributedText = [self psDisplayAttributedString];
        
        cell.payStyleLabel.text = self.orderModel.calculateMode;
        cell.bankLabel.text = [self displayBankCardNameAndNo];
        cell.usageLabel.text = self.orderModel.loanUsage;
        
        return cell;
    }else
    if(indexPath.section == 1){
        FyBillRepaymentPlanTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_title forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        WS(weakSelf)
        FyRepayPlanModel *repayPlanModel = self.orderModel.repayPlan[indexPath.row];
        
        FyBillDetailRepaymentPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_plan forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.desLabel.text = [NSString stringWithFormat:@"%ld/%lu期 %@", (long)indexPath.row+1, (unsigned long)self.orderModel.repayPlan.count, repayPlanModel.dueTime];
        cell.amountLabel.text = [[NSString stringNumberFormatterWithDouble:[repayPlanModel.money doubleValue]] stringByAppendingString:@"元"];
        
        NSString *statusStr = [repayPlanModel.statusStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        cell.statusLabel.text = statusStr;
        cell.hiddenLine = statusStr.length == 0;
        
        if (repayPlanModel.status == FyRepayPlanStatusNow) {
            cell.statusLabel.gradientStartColor = [UIColor textGradientStartColor];
            cell.statusLabel.gradientEndColor = [UIColor textGradientEndColor];
        }else{
            cell.statusLabel.gradientStartColor = nil;
            cell.statusLabel.gradientEndColor = nil;
        }
        
        if (repayPlanModel.status == FyRepayPlanStatusNow || repayPlanModel.status == FyRepayPlanStatusUnOverDue) {
            cell.desLabel.textColor = [UIColor subTextColorV2];
            cell.amountLabel.textColor = [UIColor textColorV2];
        }else{
            cell.desLabel.textColor = [UIColor weakTextColorV2];
            cell.amountLabel.textColor = [UIColor weakTextColorV2];
        }
        
        cell.statusLabel.textColor = repayPlanModel.status == FyRepayPlanStatusUnOverDue ? [UIColor promptColorV2] : [UIColor weakTextColorV2];
        
        cell.detailList = [self repayPlanDetailListWithModel:repayPlanModel];
        cell.open = repayPlanModel.open;
        
        cell.openBlock = ^(BOOL open) {
            repayPlanModel.open = open;
            [weakSelf.tableView reloadData];
        };
        
        return cell;

    }
}

- (NSArray *)repayPlanDetailListWithModel:(FyRepayPlanModel *)model{
    NSMutableArray *arr = [@[] mutableCopy];
    FyPopCellModel *model1 = [[FyPopCellModel alloc] init];
    model1.title = @"应还本息";
    model1.subTitle = [[NSString stringFormatString:numberFormatter doubleValue:[model.principalInterest doubleValue]] stringByAppendingString:@"元"];
    
    FyPopCellModel *model2 = [[FyPopCellModel alloc] init];
    model2.title = @"服务费";
    model2.subTitle = [[NSString stringFormatString:numberFormatter doubleValue:[model.service_fee doubleValue]] stringByAppendingString:@"元"];

    [arr addObject:model1];
    [arr addObject:model2];

    if (model.status == FyRepayPlanStatusUnOverDue || [model.penalty doubleValue] > 0) {
        FyPopCellModel *model3 = [[FyPopCellModel alloc] init];
        model3.title = @"逾期罚息";
        model3.subTitle = [[NSString stringFormatString:numberFormatter doubleValue:[model.penalty doubleValue]] stringByAppendingString:@"元"];
        [arr addObject:model3];

    }
    return [arr copy];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 2) {
//        FyRepayPlanModel *repayPlanModel = self.orderModel.repayPlan[indexPath.row];
//
//        return repayPlanModel.open ? 165 : 80;
//    }
//    return UITableViewAutomaticDimension;
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
