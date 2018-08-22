//
//  FyApproveCenterViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveCenterViewController.h"
#import "LPApproveLabel.h"
#import "AuthStateModel.h"
#import "FyAuthCenterRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FyApproveStepUtil.h"
#import "MoxieSDK.h"
#import "FyMailApproveModel.h"
#import "FyLoadMoxieRequest.h"
#import "FyLoadTaobaoRequest.h"
#import <WecashTaobao/WETaobaoWebViewController.h>
#import "FyLoanPremiseModelV2.h"
#import "NSString+FormatNumber.h"
#import "FyMoxieRetureRequest.h"
#import "FyTBReturnRequest.h"
#import "FyCalculatePopView.h"
#import "FyCountCreditRequest.h"
#import "FyLoanUtil.h"
#import "FyAuthorizationUtil.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//Apikey,您的APP使用SDK的API的权限
//#define theApiKey @"b00d8e8f65bf4350b19204a16fbe79c3"
//用户ID,您APP中用以识别的用户ID
//#define theUserID @"moxietest_iosdemo"

#define kStateFinesh @"您已完成该认证"
#define kStateWait @"认证中，请稍后再试"

@interface FyApproveCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@property (nonatomic, weak) IBOutlet UILabel *fyTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *fySubTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *nextView;
@property (nonatomic, weak) IBOutlet UILabel *fyFinishLabel;
@property (nonatomic, weak) IBOutlet UILabel *fyActionLabel;

@end

@implementation FyApproveCell
@end


@interface FyApproveCenterViewController ()<MoxieSDKDelegate, WecashTaobaoWebViewDelegate, AMapLocationManagerDelegate>{
    NSURLSessionDataTask *_task;
    NSURLSessionDataTask *_moxieTask;

}

@property (nonatomic, strong) NSString  *coordinate;
@property(nonatomic,strong)AMapLocationManager *locationManager;

//@property (weak, nonatomic) IBOutlet FyApproveHeaderCell *headerCell;
@property (weak, nonatomic) IBOutlet FyApproveCell *trueNameCell;
//@property (weak, nonatomic) IBOutlet FyApproveCell *zhimaCell;
@property (weak, nonatomic) IBOutlet FyApproveCell *operatorCell;
@property (weak, nonatomic) IBOutlet FyApproveCell *contactCell;
//@property (weak, nonatomic) IBOutlet FyApproveOptionCell *optionCell;


@property (nonatomic, strong) FyLoanPremiseModelV2 *stateModel;
@property (nonatomic, strong) FyMailApproveModel *mailModel;
@property (nonatomic, strong) FyTaobaoApproveModel *tbModel;

@end

@implementation FyApproveCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"认证中心";

    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.navigationController.navigationBar.hidden = NO;

    self.tableView.backgroundColor = [UIColor bgColor];
    [self configCells];
    [self configWithModel:nil];
    
    [[FyUserCenter sharedInstance] submitTokenkeyIfNeed];
}

//- (void)loadMailModelComplete:(void (^)()) complete{
//    [_moxieTask cancel];
//    FyLoadMoxieRequest *t = [[FyLoadMoxieRequest alloc] init];
//
//    _moxieTask = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
//        self.mailModel = model;
//        [self configMoxieSDK];
//
//        if(complete){
//            complete();
//        }
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        if(complete){
//            complete();
//        }
//    }];
//}

//- (void)loadTBModelComplete:(void (^)()) complete{
//    [_moxieTask cancel];
//    FyLoadTaobaoRequest *t = [[FyLoadTaobaoRequest alloc] init];
//
//    _moxieTask = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
//        self.tbModel = model;
//        if(complete){
//            complete();
//        }
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        if(complete){
//            complete();
//        }
//    }];
//}


//-(void)configMoxieSDK{
//    /***必须配置的基本参数*/
//    [MoxieSDK shared].delegate = self;
//    [MoxieSDK shared].userId = self.mailModel.uuid;
//    [MoxieSDK shared].apiKey = self.mailModel.apiKey;
//    [MoxieSDK shared].fromController = self;
//
//    /******** 如果需要自定义 moxieStatusView 请实现 dataSource****/
//    /********（第一步：请先添加<MoxieSDKDataSource>协议） *********/
//    /********（第二步：设置dataSource） *********/
//    //    [MoxieSDK shared].dataSource = self;
//    //-------------更多自定义参数，请参考文档----------------//
//};


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fy_headerBeginRefreshing];
}

- (BOOL)fy_allowPullDown{
    return YES;
}

- (void)configCells{
    self.trueNameCell.fyTitleLabel.text = @"实名认证";
    self.trueNameCell.fySubTitleLabel.text = @"人脸识别认证及身份证OCR扫描";
    self.trueNameCell.iconView.image = [UIImage imageNamed:@"rz_icon_shiming"];
    
//    self.zhimaCell.fyTitleLabel.text = @"芝麻认证";
//    self.zhimaCell.fySubTitleLabel.text = @"芝麻信用认证及芝麻分授权";
//    self.zhimaCell.iconView.image = [UIImage imageNamed:@"rz_icon_zhima"];

    self.operatorCell.fyTitleLabel.text = @"运营商认证";
    self.operatorCell.fySubTitleLabel.text = @"三大运营商授权认证";
    self.operatorCell.iconView.image = [UIImage imageNamed:@"rz_icon_yunyingshang"];

    self.contactCell.fyTitleLabel.text = @"联系方式";
    self.contactCell.fySubTitleLabel.text = @"联系地址及通讯录授权认证";
    self.contactCell.iconView.image = [UIImage imageNamed:@"rz_icon_lianxiren"];
    
//    WS(weakSelf)
//    self.optionCell.mailBlock = ^{
//        [weakSelf handleMail];
//    };
//
//    self.optionCell.taobaoBlock = ^{
//        [weakSelf handleTaobao];
//    };
    
//    self.headerCell.actionBlock = ^{
//        [weakSelf headerAction];
//    };
}

- (void)headerAction{
    if ((self.stateModel.auth.isHasBaseAuth && self.stateModel.creditInfo.isHasCredit != CreditStautsSuccess)) {
        [self countCredit];
    }else{
        [self applyLoan];
    }
}

//计算额度
- (void)doCountCredit{
    FyCountCreditRequest *t = [[FyCountCreditRequest alloc] init];
    t.coordinate = self.coordinate;
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            _stateModel = model;
            [self configWithModel:model];
            [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusDefault];
        }else{
            [self fy_toastMessages:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
    }];

}

- (void)countCredit{
    if (self.stateModel.auth.auth.taobaoState == AuthStateTypeWait || self.stateModel.auth.auth.creditCardState == AuthStateTypeWait) {
        [self LPShowAletWithContent:@"提额项正在认证中，请稍后再试~"];
        return;
    }
    
    WS(weakSelf)
    if (self.stateModel.auth.auth.taobaoState != AuthStateTypePass || self.stateModel.auth.auth.creditCardState != AuthStateTypePass) {
        FyCalculatePopView *popView = [FyCalculatePopView loadNib];
        popView.fyShowStyle = FyViewShowStyleCenter;
        popView.commitBlock = ^{
            [weakSelf doCountCredit];
        };
        
        [popView fy_Show];
    }else{
        [self doCountCredit];
    }
}

//去借款
- (void)applyLoan{
    [FyLoanUtil applyIfNeededWithModel:nil fromViewController:self];
}

- (void)configWithModel:(FyLoanPremiseModelV2 *)model{
    [self configStateWithState:model.auth.auth.idState cell:self.trueNameCell];
//    [self configStateWithState:model.auth.auth.zhimaState cell:self.zhimaCell];
    [self configStateWithState:model.auth.auth.phoneState cell:self.operatorCell];
    [self configStateWithState:model.auth.auth.contactState cell:self.contactCell];
    
    [self configHeaderCell];
    [self configOptionCell];
}

- (void)configHeaderCell{
//    if (!self.stateModel || (!self.stateModel.auth.isHasBaseAuth) || self.stateModel.order.isHasOrder) {
//        self.headerCell.button.hidden = YES;
//    }
//
//    self.headerCell.amountLabel.text = [NSString stringNumberFormatterWithDouble:[self.stateModel.creditInfo.credit doubleValue]];
//    //完成基础认证 但是 没有计算额度， 显示计算额度
//    if (self.stateModel.auth.isHasBaseAuth && self.stateModel.creditInfo.isHasCredit != CreditStautsSuccess) {
//        self.headerCell.button.hidden = NO;
//
//        [self loadLocation];
//
//        [self.headerCell.button setTitle:@"计算额度" forState:UIControlStateNormal];
//        [self.headerCell.button setTitle:@"计算额度" forState:UIControlStateDisabled];
//
//        if (self.stateModel.creditInfo.isHasCredit == CreditStautsUnderWay) {
//            self.headerCell.button.enabled = NO;
//            self.headerCell.amountLabel.text = @"审核中...";
//
//        }else{
//            self.headerCell.button.enabled = YES;
//        }
//    }
//
//    //已计算额度 但是没有借款
//    if (self.stateModel.auth.isHasBaseAuth && self.stateModel.creditInfo.isHasCredit == CreditStautsSuccess && !self.stateModel.order.isHasOrder) {
//        self.headerCell.button.hidden = NO;
//        self.headerCell.button.enabled = YES;
//        [self.headerCell.button setTitle:@"立马拿钱" forState:UIControlStateNormal];
//        [self.headerCell.button setTitle:@"立马拿钱" forState:UIControlStateDisabled];
//    }
}

//淘宝响应
- (void)handleTaobao{
//    if (!self.stateModel) return;
//
//    if (self.stateModel.creditInfo.isHasCredit != CreditStautsNot) {
//        [self LPShowAletWithContent:@"计算额度后不可再进行授信额度提升"];
//        return;
//    }
//
//    if (!self.stateModel.auth.isHasBaseAuth) {
//        [self LPShowAletWithContent:@"请先进行基础认证"];
//        return;
//    }
//
//    if (self.stateModel.auth.auth.taobaoState == AuthStateTypeWait) {
//        [self LPShowAletWithContent:kStateWait];
//        return;
//    }
//
//    if (self.stateModel.auth.auth.taobaoState == AuthStateTypePass) {
//        [self LPShowAletWithContent:kStateFinesh];
//        return;
//    }
//
//    [self tbImportClick];
}

- (void)handleMail{
//    if (!self.stateModel) return;
//
//    if (self.stateModel.creditInfo.isHasCredit != CreditStautsNot) {
//        [self LPShowAletWithContent:@"计算额度后不可再进行授信额度提升"];
//        return;
//    }
//
//    if (!self.stateModel.auth.isHasBaseAuth) {
//        [self LPShowAletWithContent:@"请先进行基础认证"];
//        return;
//    }
//
//    if (self.stateModel.auth.auth.creditCardState == AuthStateTypeWait) {
//        [self LPShowAletWithContent:kStateWait];
//        return;
//    }
//
//    if (self.stateModel.auth.auth.creditCardState == AuthStateTypePass) {
//        [self LPShowAletWithContent:kStateFinesh];
//        return;
//    }
//
//    [self mailImportClick];

}

- (void)configOptionCell{
    //没有加载到数据 或 已经计算完额度 或 未完成基础认证， 不能在进行附加项认证
//    if (!self.stateModel || self.stateModel.creditInfo.isHasCredit != CreditStautsNot || !self.stateModel.auth.isHasBaseAuth) {
//        self.optionCell.fyActionLabe2.hidden = self.optionCell.fyActionLabel1.hidden = self.optionCell.nextView2.hidden = self.optionCell.nextView1.hidden = YES;
//        self.optionCell.fyFinishLabel1.hidden = self.optionCell.fyFinishLabe2.hidden = NO;
////        self.optionCell.button1.userInteractionEnabled = self.optionCell.button2.userInteractionEnabled = NO;
//    }else{
//        if (self.stateModel.auth.auth.taobaoState != AuthStateTypePass && self.stateModel.auth.auth.taobaoState != AuthStateTypeWait) {
//            self.optionCell.fyActionLabel1.hidden = self.optionCell.nextView1.hidden = NO;
//            self.optionCell.fyFinishLabel1.hidden = YES;
////            self.optionCell.button1.userInteractionEnabled = YES;
//
//            if (self.stateModel.auth.auth.taobaoState == AuthStateTypeFail) {
//                self.optionCell.fyActionLabel1.text = @"认证失败";
//            }else{
//                self.optionCell.fyActionLabel1.text = @"去提额";
//            }
//
//        }else{
//            self.optionCell.fyActionLabel1.hidden = self.optionCell.nextView1.hidden = YES;
//            self.optionCell.fyFinishLabel1.hidden = NO;
////            self.optionCell.button1.userInteractionEnabled = NO;
//        }
//
//        if (self.stateModel.auth.auth.creditCardState != AuthStateTypePass && self.stateModel.auth.auth.creditCardState != AuthStateTypeWait) {
//            self.optionCell.fyActionLabe2.hidden = self.optionCell.nextView2.hidden = NO;
//            self.optionCell.fyFinishLabe2.hidden = YES;
////            self.optionCell.button2.userInteractionEnabled = YES;
//
//            if (self.stateModel.auth.auth.creditCardState == AuthStateTypeFail) {
//                self.optionCell.fyActionLabe2.text = @"认证失败";
//            }else{
//                self.optionCell.fyActionLabe2.text = @"去提额";
//            }
//
//        }else{
//            self.optionCell.fyActionLabe2.hidden = self.optionCell.nextView2.hidden = YES;
//            self.optionCell.fyFinishLabe2.hidden = NO;
////            self.optionCell.button2.userInteractionEnabled = NO;
//        }
//
//    }

//    if (self.stateModel.auth.auth.taobaoState != AuthStateTypePass) {
//        if (self.stateModel.auth.auth.taobaoState != AuthStateTypeWait) {
//            self.optionCell.fyFinishLabel1.text = @"未提额";
//        }else{
//            self.optionCell.fyFinishLabel1.text = @"认证中";
//        }
//        self.optionCell.iconView1.image = [UIImage imageNamed:@"rz_icon_taobao_gray"];
//    }else{
//        self.optionCell.fyFinishLabel1.text = @"已提额";
//        self.optionCell.iconView1.image = [UIImage imageNamed:@"rz_icon_taobao_orange"];
//
//    }
//
//    if (self.stateModel.auth.auth.creditCardState != AuthStateTypePass) {
//        if (self.stateModel.auth.auth.creditCardState != AuthStateTypeWait) {
//            self.optionCell.fyFinishLabe2.text = @"未提额";
//        }else{
//            self.optionCell.fyFinishLabe2.text = @"认证中";
//        }
//        self.optionCell.iconView2.image = [UIImage imageNamed:@"rz_icon_mail_gray"];
//
//    }else{
//        self.optionCell.fyFinishLabe2.text = @"已提额";
//        self.optionCell.iconView2.image = [UIImage imageNamed:@"rz_icon_mail_blue"];
//    }
}

- (void)fy_loadServerData {
    _stateModel = nil;
    [self configWithModel:nil];
    FyAuthCenterRequest *task = [[FyAuthCenterRequest alloc] init];
 
    [_task cancel];
    _task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        _stateModel = model;
        [self configWithModel:model];
        [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusDefault];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode == NSURLErrorCancelled) {
            [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusCancelled];
        }else{
            [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusFailed];
            [self fy_toastMessages:error.errorMessage];
        }

    }];
}

- (void)configStateWithState:(AuthStateType)state cell:(FyApproveCell *)cell{
    
    
    NSString *str = @"";
    switch (state) {
        case AuthStateTypeNone:
        {
            str = @"去认证";
        }
            break;
        case AuthStateTypeWait:
        {
            str = @"认证中";
        }
            break;
        case AuthStateTypePass:
        {
            str = @"已完成";
        }
            break;
        case AuthStateTypeTimeout:
        {
            str = @"认证超时";
        }
            break;
        case AuthStateTypeFail:
        {
            str = @"认证失败";
        }
            break;
        default:
            break;
    }
    
    cell.fyFinishLabel.text = cell.fyActionLabel.text = str;
    
    if(state == AuthStateTypeUnknown || (cell != self.trueNameCell && _stateModel.auth.auth.idState != AuthStateTypePass)){
        cell.fyActionLabel.hidden = YES;
        cell.fyFinishLabel.hidden = YES;
        cell.nextView.hidden = YES;
    }else if(state == AuthStateTypeNone || state == AuthStateTypeFail || state == AuthStateTypeTimeout){
        cell.fyActionLabel.hidden = NO;
        cell.fyFinishLabel.hidden = YES;
        cell.nextView.hidden = NO;

    }else{
        cell.fyActionLabel.hidden = YES;
        cell.fyFinishLabel.hidden = NO;
        cell.nextView.hidden = YES;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_stateModel) return;

    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        if (_stateModel.auth.auth.idState != AuthStateTypePass) {
            WS(weakSelf)
             [self LPShowAletWithContent:@"请先完成实名认证" left:@"取消" right:@"去认证" rightClick:^{
                 [weakSelf tureNameApprove];
             }];
            return;
        }
    }
    
    switch (indexPath.row) {
        case 1:
        {
            //实名
            [self tureNameApprove];
        }
            break;
//        case 2:
//        {
//            //芝麻
//            [self zhimaApprove];
//
//        }
//            break;
            
        case 2:{
            //运营商
            [self operatorApprove];
        }
            break;
        case 3:{
            if (_stateModel.auth.auth.phoneState != AuthStateTypePass) {
                WS(weakSelf)
                [self LPShowAletWithContent:@"请先完成运营商认证" left:@"取消" right:@"去认证" rightClick:^{
                    [weakSelf operatorApprove];
                }];
                return;
            }
            //联系人
            [self contactApprove];
        }
            break;
        default:
            break;
    }
}

- (void)tureNameApprove {
    if (_stateModel.auth.auth.idState == AuthStateTypePass) {
        [self LPShowAletWithContent:kStateFinesh];
        return;
    }

    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyApproveStepTureName autoNext:NO];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zhimaApprove{
    if (_stateModel.auth.auth.zhimaState == AuthStateTypePass) {
        [self LPShowAletWithContent:kStateFinesh];
        return;
    }
    
    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepZhiMa autoNext:NO];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)operatorApprove{
    if (_stateModel.auth.auth.phoneState == AuthStateTypeNone || _stateModel.auth.auth.phoneState == AuthStateTypeFail || _stateModel.auth.auth.phoneState == AuthStateTypeTimeout) {
        UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepOperator autoNext:NO];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(_stateModel.auth.auth.phoneState == AuthStateTypeWait){
        //不可点
        [self LPShowAletWithContent:kStateWait];
        return;
    } else{
        //不可点
        [self LPShowAletWithContent:kStateFinesh];
        return;
    }
}

- (void)contactApprove{
    if (_stateModel.auth.auth.contactState == AuthStateTypePass) {
        [self LPShowAletWithContent:kStateFinesh];
        return;
    }
    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepContact autoNext:NO];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)moxieReturn{
    [self showGif];
    FyMoxieRetureRequest *t = [[FyMoxieRetureRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        [self fy_loadServerData];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
    }];
}

- (void)tbReturn{
    [self showGif];
    FyTBReturnRequest *t = [[FyTBReturnRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        [self fy_loadServerData];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
    }];
}


#pragma MoxieSDK Result Delegate
//魔蝎SDK --- 回调数据结果
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    //任务结果code，详细参考文档
    int code = [resultDictionary[@"code"] intValue];
    //是否登录成功
    BOOL loginDone = [resultDictionary[@"loginDone"] boolValue];
    //任务类型
    NSString *taskType = resultDictionary[@"taskType"];
    //任务Id
    NSString *taskId = resultDictionary[@"taskId"];
    //描述
    NSString *message = resultDictionary[@"message"];
    //当前账号
    NSString *account = resultDictionary[@"account"];
    //用户在该业务平台上的userId，例如支付宝上的userId（目前支付宝，淘宝，京东支持）
    NSString *businessUserId = resultDictionary[@"businessUserId"]?resultDictionary[@"businessUserId"]:@"";
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,message:%@,account:%@,loginDone:%d，businessUserId:%@",code,taskType,taskId,message,account,loginDone,businessUserId);
    //【登录中】假如code是2且loginDone为false，表示正在登录中
    if(code == 2 && loginDone == false){
        NSLog(@"任务正在登录中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
        [self moxieReturn];
    }
    //【采集中】假如code是2且loginDone为true，已经登录成功，正在采集中
    else if(code == 2 && loginDone == true){
        NSLog(@"任务已经登录成功，正在采集中，SDK退出后不会再回调任务状态，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
        [self moxieReturn];
    }
    //【采集成功】假如code是1则采集成功（不代表回调成功）
    else if(code == 1){
        [self moxieReturn];
        NSLog(@"任务采集成功，任务最终状态会从服务端回调，建议轮询APP服务端接口查询任务/业务最新状态");
    }
    //【未登录】假如code是-1则用户未登录
    else if(code == -1){
        NSLog(@"用户未登录");
    }
    //【任务失败】该任务按失败处理，可能的code为0，-2，-3，-4
    else{
        NSLog(@"任务失败");
    }
}

//邮箱导入
- (void)mailImportClick{
//    if (!self.mailModel) {
//        [self showGif];
//        [self loadMailModelComplete:^{
//            [self hideGif];
//            if (self.mailModel) {
//                [self mailImportClick];
//            }else{
//                [self fy_toastMessages:@"网络开小差了"];
//            }
//        }];
//        return;
//    }
//
//    [MoxieSDK shared].taskType = @"email";
//    [MoxieSDK shared].delegate = self;
//    [[MoxieSDK shared] start];
}

//taobao
- (void)tbImportClick{
//    if (!self.tbModel) {
//        [self showGif];
//        [self loadTBModelComplete:^{
//            [self hideGif];
//            if (self.tbModel) {
//                [self tbImportClick];
//            }else{
//                [self fy_toastMessages:@"网络开小差了"];
//            }
//        }];
//        return;
//    }
//
//    
//    [WETaobaoWebViewController authTaobaoWecashKey:self.tbModel.secret andDeviceId:[UIDevice currentDevice].identifierForVendor.UUIDString andSource:self.tbModel.source andCustomerId:self.tbModel.uuid];
//    WETaobaoWebViewController *taobaoVC = [[WETaobaoWebViewController alloc] init];
//    
//    taobaoVC.delegate = self;
//    [self.navigationController pushViewController:taobaoVC animated:YES];
}

-(void)authorizationSuccessWithResponse:(WEDataTransferObject *)transferObject{
    NSLog(@"%@",transferObject.tbusername);
    NSLog(@"%@",transferObject.taobaoID);
    if (transferObject.status) {
        [self tbReturn];
    }
}


//定位
- (void)loadLocation{
    if (self.coordinate.length > 0) return;
    WS(weakSelf)
    [self getLoactionCoordinate:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        weakSelf.coordinate = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
    }];
    
}

- (void)getLoactionCoordinate:(AMapLocatingCompletionBlock)block{
    NSLog(@"实现分类方法");
    if (![FyAuthorizationUtil allowLocation]) {
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
        return;
    }
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
}

- (void)setLocationManagerForHundredMeters{
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //2.定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [self setLocationManagerForHundredMeters];
    }
    return _locationManager;
}

@end
