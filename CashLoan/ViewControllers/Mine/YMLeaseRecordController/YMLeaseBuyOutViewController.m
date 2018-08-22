

//
//  YMLeaseBuyOutViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseBuyOutViewController.h"
#import "YMLeaseDeatailBottomView.h"
#import "YMLeaseBuyOutCell.h"
#import "YMLeaseDeatailNormalCell.h"
#import "YMLeaseBuyOutBankCell.h"
#import "YMBuyOutRequest.h"
#import "YMBuyOutNotifyRequest.h"
#import "NSString+fyBase64.h"
#import "FyAutoDismissResultView.h"
#import <LLTokenPaySDK.h>
#import "FyBuyoutTipView.h"

static NSString *const kLeaseBuyOutHeaderCell = @"kLeaseBuyOutHeader_cell";
static NSString *const kLeaseBuyOutNormalCell = @"kLeaseBuyOutNormal_cell";
static NSString *const kLeaseBuyOutBankCell = @"kLeaseBuyOutBankCell";

@interface YMLeaseBuyOutViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMLeaseDeatailBottomView *bottomView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, copy) NSString *orderNo;

@end

@implementation YMLeaseBuyOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)buyOutRequest {
    //买断页面加个判定，如果买断用户绑定的银行卡是后台设置的不支持银行卡类型，进行弹窗提示。

    WS(weakSelf)
    if (self.cardModel.isUnsupport) {
        FyBuyoutTipView *v = [FyBuyoutTipView loadNib];
        //    v.wechatBlock = ^{
        //        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        //        pasteboard.string = @"123";
        //        [weakSelf fy_toastMessages:@"微信账号已复制！"];
        //    };
        v.alipayBlock = ^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"18106967179";
            [weakSelf fy_toastMessages:@"支付宝账号已复制！"];
        };
        [v show];
    }else{

        YMBuyOutRequest *request = [[YMBuyOutRequest alloc] init];
        request.orderId = self.model.id;
        [self showGif];
        [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:request success:^(NSURLSessionDataTask *t, FyResponse *error, id model) {
            [weakSelf hideGif];
            if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
                [weakSelf loadFastRepaySuccessView];
            }else{
                [weakSelf LPShowAletWithContent:error.errorMessage];
            }
        } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
            [weakSelf hideGif];
            [weakSelf fy_toastMessages:error.errorMessage];
        }];
    }
}

- (void)payToLLPay:(NSDictionary *)data {
//    // 进行签名
//    [LLPaySdk sharedSdk].sdkDelegate = self;
//    //接入什么产品就传什么LLPayType
//    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
//                                               withPayType:LLPayTypeQuick
//                                             andTraderInfo:data];
    WS(weakSelf)
    [[LLTokenPaySDK sharedSdk] payApply:data inVC:self complete:^(LLPayResult result, NSDictionary *dic) {
        [weakSelf paymentEnd:result withResultDic:dic];
    }];
}

//#pragma - mark 支付结果 LLPaySdkDelegate
//// 订单支付结果返回，主要是异常和成功的不同状态
//// TODO: 开发人员需要根据实际业务调整逻辑
//
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSLog(@"%@", dic)
    YMBuyOutNotifyRequest *t = [[YMBuyOutNotifyRequest alloc] init];
    t.orderId = self.model.id;
    t.resultPay = resultCode == kLLPayResultSuccess ? @"SUCCESS":@"FAILURE";
    t.orderNo = self.orderNo;
    t.returnParams = [NSString convertToJSONData:dic];

    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];

    if (resultCode == kLLPayResultSuccess) {
        [self loadFastRepaySuccessView];
    }else{
        [self LPShowAletWithContent:[NSString stringWithFormat:@"错误代码%@,%@",dic[@"ret_code"],dic[@"ret_msg"]]];
    }
}

- (void)loadFastRepaySuccessView { 
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.titleLabel.text = @"恭喜您，买断申请成功";
    view.dismissBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    view.contentLabel.text = @"请确保绑定的银行卡余额充足。";
    [view show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor bgColor];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titleArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        YMLeaseBuyOutCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseBuyOutHeaderCell];
        NSString *phoneStr = [NSString stringWithFormat:@"租赁%@，%@G，%ld天",self.model.modelName,self.model.phoneMemory,self.model.period];
        [cell displayWithTitle:phoneStr type:title content:[NSString stringWithFormat:@"%ld",(NSInteger)self.model.overdueFee]];
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        YMLeaseBuyOutBankCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseBuyOutBankCell];
        NSString *cardNum = @"";
        if (self.cardModel.cardNo.length > 0) {
            cardNum = [self.cardModel.cardNo substringFromIndex:self.cardModel.cardNo.length - 4];
        }
        NSString *content = [NSString stringWithFormat:@"%@(%@)",self.cardModel.bankName,cardNum];
        [cell displayWithTitle:title content:content img:self.cardModel.imgUrl];
        return cell;
    }
    
    YMLeaseDeatailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseBuyOutNormalCell];
    NSString *content = @"";
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        content = [NSString stringWithFormat:@"%ld元",(long)self.model.depreciationFee];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        content = [NSString stringWithFormat:@"%.2f元",self.model.dayRentFee];
    }  else if (indexPath.section == 0 && indexPath.row == 3) {
        content = [NSString stringWithFormat:@"%ld元",(long)self.model.rentFee];
    }
    [cell displayWithTitle:title content:content];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupUI {
    self.title = @"买断";
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.titleArr = @[
                      @[@"逾期管理费",@"折旧费",@"日租金",@"总租金"],
                      @[@"银行卡"]
                      ];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-70);
    }];
    
}

- (YMLeaseDeatailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [YMLeaseDeatailBottomView loadNib];
        [_bottomView setPriceLabText:[NSString stringWithFormat:@"%.1f元",self.model.allFee]];
        WS(weakSelf)
        _bottomView.applyBlock = ^{
            [weakSelf buyOutRequest];
        };
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedRowHeight = 100;
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor bgColor];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLeaseBuyOutNormalCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseBuyOutCell" bundle:nil] forCellReuseIdentifier:kLeaseBuyOutHeaderCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseDeatailNormalCell" bundle:nil] forCellReuseIdentifier:kLeaseBuyOutNormalCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseBuyOutBankCell" bundle:nil] forCellReuseIdentifier:kLeaseBuyOutBankCell];
    }
    return  _tableView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
