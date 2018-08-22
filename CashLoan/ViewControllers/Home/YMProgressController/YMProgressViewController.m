//
//  YMProgressViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMProgressViewController.h"
#import "UAProgressView.h"
#import "YMEvaluateViewController.h"
#import "RichLabel.h"
#import "FyLoginUtil.h"
#import "LEEAlertManager.h"
#import "FyApproveCenterViewController.h"
#import "FyBindingBankViewController.h"
#import "YMLeaseTimeLimitViewController.h"
#import "FyHomePageStateRequestV2.h"
#import "FyFindIndexModelV2.h"
#import "YMApproveManager.h"
#import "YMTool.h"
@interface YMProgressViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UILabel *progressLab;
@property (nonatomic, assign) CGFloat localProgress;
@property (nonatomic, strong) UIImageView *progressImgView;
@property (nonatomic, strong) NSMutableArray *imagesMArr;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *detailContentLab;
@property (nonatomic, strong) UILabel *discriptionLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UILabel *numberBottomLab;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIImageView *starTipImgV;
@property (nonatomic, strong) RichLabel *tipLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) RichLabel *tipTitleLabel;
@property (nonatomic, strong) RichLabel *tipContentLabel;

@property (nonatomic, strong) UIButton *bottomBtn;

@property (nonatomic, strong) YMApproveManager *approveManager;


@end

@implementation YMProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setParamse];
}

- (void)setParamse {
    self.contentLab.text = [NSString stringWithFormat:@"%@ / %@",[YMTool getDeviceName],[YMTool getDivceSize]];
//    NSInteger location = [self.contentLab.text rangeOfString:@"("].location;
//    NSInteger length = [YMTool getDivceSize].length + 2;
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:self.contentLab.text];
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range: NSMakeRange(location, length)];
//    self.contentLab.attributedText = attrStr;
    self.detailContentLab.text = [NSString stringWithFormat:@"%ld",(NSInteger)self.model.mobile.assessment_value];
    self.discriptionLab.text = @"本机估值（元）";
    self.numberBottomLab.text = @"评估进度";
    self.tipLabel.text = @"注: 准时交租等良好信用表现，有助于提高您的手机估值";



}

- (void)setNumberLabText:(NSInteger)count {
    if (count ==0 ||count ==25 || count == 50 || count == 75 || count == 100) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.numberLab.text = [NSString stringWithFormat:@"%ld%%",count];

        });

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.progressImgView startAnimating];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //默认状态栏颜色为白色
    [[FyUserCenter sharedInstance] loadUserInfoData];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressImgView stopAnimating];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self cleanTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.progressImgView stopAnimating];
}

- (void)cleanTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressImgView stopAnimating];
            self.progressImgView.image = [UIImage imageNamed:@"1_000017"];

        });
        [self startUIAnimation];

    }
}

- (void)repeatSelector {
    
    self.count++;
    [self setNumberLabText:self.count];
    if (self.count == 100) {
        [self cleanTimer];
//        YMEvaluateViewController *vc = [[YMEvaluateViewController alloc] init];
//        vc.model = self.model;
//        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark -- ui

- (void)setupUI {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.nav.backgroundColor = [UIColor clearColor];
    self.nav.lbl_title.textColor = [UIColor textColor];
    [self.nav setNavLeftItemImage:[UIImage imageNamed:@"icon_back"] title:nil];

    self.title = @"手机评估";

    [self.view addSubview:self.bgScrollView];
    [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT - 80);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    
    [self.bgScrollView addSubview:self.progressImgView];
    [self.progressImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(120);

    }];
    [self.view bringSubviewToFront:self.nav];
    
    [self.bgScrollView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(170);
        make.top.mas_equalTo(_progressImgView.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.bgScrollView addSubview:self.detailContentLab];
    [self.detailContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(170);
        make.top.mas_equalTo(self.contentLab.mas_bottom).offset(20);
        make.height.mas_equalTo(40);

    }];
    
    
    [self.bgScrollView addSubview:self.discriptionLab];
    [self.discriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(170);
        make.top.mas_equalTo(self.detailContentLab.mas_bottom).offset(10);
        make.height.mas_equalTo(20);

    }];
    
    [self.progressImgView addSubview:self.numberLab];
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.progressImgView.mas_centerX);
        make.centerY.mas_equalTo(self.progressImgView.mas_centerY).offset(-10);
    }];
    
    [self.progressImgView addSubview:self.numberBottomLab];
    [self.numberBottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.progressImgView.mas_centerX);
        make.centerY.mas_equalTo(self.progressImgView.mas_centerY).offset(20);
        
    }];
    
    [self.bgScrollView addSubview:self.starTipImgV];
    [self.starTipImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.progressImgView.mas_bottom).offset(40);
        make.width.and.height.mas_equalTo(SCALE6Width(6));
        
    }];
    
    [self.bgScrollView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.starTipImgV.mas_right).offset(5);
        make.width.mas_equalTo(kScreenWidth - 30 - 5 - self.starTipImgV.width);
        make.top.equalTo(self.progressImgView.mas_bottom).offset(38);
        make.height.mas_equalTo(35);

    }];
    
    [self.bgScrollView addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(.5);
        make.width.mas_equalTo(kScreenWidth - 30);
        
    }];
    
    [self.bgScrollView addSubview:self.tipTitleLabel];
    [self.tipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.separatorLine.mas_left);
        make.top.equalTo(self.separatorLine.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(kScreenWidth - 30);

    }];
    
    [self.bgScrollView addSubview:self.tipContentLabel];
    [self.tipContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.separatorLine.mas_left);
        make.top.equalTo(self.tipTitleLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(kScreenWidth - 30);
        make.height.mas_equalTo(200);

    }];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-25);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(42);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.count = 0;
    [self setNumberLabText:self.count];
    [self loadImages];
    [self positionConfig];

    dispatch_queue_t urls_queue = dispatch_queue_create("com.duomi.duomibaika", NULL);
    
    dispatch_async(urls_queue, ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(repeatSelector) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        
    });
    [self.progressImgView startAnimating];


}

- (void)loadImages {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resourcePath = [bundle pathForResource:@"progress" ofType:@"bundle"];
    for (NSInteger i = 1; i < 18; i++) {
        NSString *filePath = [[NSBundle bundleWithPath:resourcePath] pathForResource:[NSString stringWithFormat:@"1_0000%ld",i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [self.imagesMArr addObject:image];
    }
    self.progressImgView.animationImages = self.imagesMArr;
    self.progressImgView.animationDuration = 2;
    self.progressImgView.animationRepeatCount = 1;
}

#pragma mark -- lazy load

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.showsVerticalScrollIndicator = NO;
    }
    return _bgScrollView;
}

- (UIImageView *)progressImgView {
    if (!_progressImgView) {
        _progressImgView = [[UIImageView alloc] init];
    }
    return _progressImgView;
}

- (NSMutableArray *)imagesMArr {
    if (!_imagesMArr) {
        _imagesMArr = [NSMutableArray arrayWithCapacity:17];
    }
    return _imagesMArr;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:18];
        _contentLab.textColor = [UIColor textColor];
    }
    return _contentLab;
}

- (UILabel *)detailContentLab {
    if (!_detailContentLab) {
        _detailContentLab = [[UILabel alloc] init];
        _detailContentLab.font = [UIFont systemFontOfSize:44];
        _detailContentLab.textColor = [UIColor textColor];
    }
    return _detailContentLab;
}

- (UILabel *)discriptionLab {
    if (!_discriptionLab) {
        _discriptionLab = [[UILabel alloc] init];
        _discriptionLab.font = [UIFont systemFontOfSize:12];
        _discriptionLab.textColor = [UIColor weakTextColor];
    }
    return _discriptionLab;
}

- (UILabel *)numberLab {
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.font = [UIFont systemFontOfSize:22];
        _numberLab.textColor = [UIColor textColor];
        _numberLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLab;
}

- (UILabel *)numberBottomLab {
    if (!_numberBottomLab) {
        _numberBottomLab = [[UILabel alloc] init];
        _numberBottomLab.font = [UIFont systemFontOfSize:12];
        _numberBottomLab.textColor = [UIColor weakTextColor];
        _numberBottomLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberBottomLab;
}

- (UIImageView *)starTipImgV {
    if (!_starTipImgV) {
        _starTipImgV = [[UIImageView alloc] init];
        _starTipImgV.image = [UIImage imageNamed:@"starTip"];
    }
    return _starTipImgV;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorWithHexString:@"ebf0f3"];
    }
    return _separatorLine;
}

- (RichLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[RichLabel alloc] init];
        _tipLabel.font = [UIFont boldSystemFontOfSize:15];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor textColor];
    }
    return _tipLabel;
}

- (RichLabel *)tipTitleLabel {
    if (!_tipTitleLabel) {
        _tipTitleLabel = [[RichLabel alloc] init];
        _tipTitleLabel.font = [UIFont systemFontOfSize:13];
        _tipTitleLabel.numberOfLines = 0;
        _tipTitleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _tipTitleLabel.textColor = [UIColor subTextColor];
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:@"点击“确认”前，请注意阅读以下信息:"];
        contentText.yy_font = [UIFont systemFontOfSize:13];
        contentText.yy_lineSpacing = 12;
        contentText.yy_color = [UIColor subTextColor];
        [contentText yy_setTextHighlightRange:[contentText.string rangeOfString:@"确认"] color:[UIColor textColor] backgroundColor:[UIColor clearColor] tapAction:nil];
        _tipTitleLabel.attributedText = contentText;
    }
    return _tipTitleLabel;
}

- (RichLabel *)tipContentLabel {
    if (!_tipContentLabel) {
        _tipContentLabel = [[RichLabel alloc] init];
        _tipContentLabel.font = [UIFont systemFontOfSize:13];
        _tipContentLabel.numberOfLines = 0;
        _tipContentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:@"多米白卡会将您的履约记录同步至芝麻信用、信联(国家级个人征信基础数据库) 等第三方征信平台，逾期交租等违约表现将会影响个人征信:\n1.对房贷、车贷、信用卡申请等产生极其严重的负面影响;\n2.出行、子女教育等都将受阻;\n3.无法享受第三方平台(如芝麻信用) 提供的汽车租赁等生活服务。"];
        contentText.yy_font = [UIFont systemFontOfSize:13];
        contentText.yy_lineSpacing = 12;
        contentText.yy_color = [UIColor subTextColor];
        [contentText yy_setTextHighlightRange:[contentText.string rangeOfString:@"芝麻信用、信联(国家级个人征信基础数据库)"] color:[UIColor textColor] backgroundColor:[UIColor clearColor] tapAction:nil];
        [contentText yy_setTextHighlightRange:[contentText.string rangeOfString:@"\n1.对房贷、车贷、信用卡申请等产生极其严重的负面影响;\n2.出行、子女教育等都将受阻;\n3.无法享受第三方平台(如芝麻信用) 提供的汽车租赁等生活服务。"] color:[UIColor textColor] backgroundColor:[UIColor clearColor] tapAction:nil];

        _tipContentLabel.attributedText = contentText;
        CGSize introSize = CGSizeMake(kScreenWidth-60, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:contentText];
        _tipContentLabel.textLayout = layout;
    }
    return _tipContentLabel;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"btn_lmnq-b"] forState:UIControlStateNormal];
        [_bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_bottomBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"508dff"]];
        [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)btnClick {
    //确认
//    YMEvaluateViewController *vc = [[YMEvaluateViewController alloc] init];
//    vc.model = self.model;
//    [self.navigationController pushViewController:vc animated:YES];
    [self confirmBtnAction];
}

- (void)dealloc {
    [self.imagesMArr removeAllObjects];
    self.imagesMArr = nil;
    NSLog(@"%s",__func__);
}

- (void)positionConfig {
    
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.contentLab layoutIfNeeded];
    
    [self.detailContentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.detailContentLab layoutIfNeeded];

    
    [self.discriptionLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.discriptionLab layoutIfNeeded];

    [self.starTipImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.starTipImgV layoutIfNeeded];

    [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.tipLabel layoutIfNeeded];


    [self.separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(500);
    }];
    [self.separatorLine layoutIfNeeded];

    self.tipTitleLabel.alpha = 0;
    self.tipContentLabel.alpha = 0;
    self.bottomBtn.alpha = 0;

}

- (void)startUIAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        //告知需要更改约束
        [self.view setNeedsUpdateConstraints];
        [UIView animateWithDuration:1 animations:^{
            
            [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(170);
            }];

            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.contentLab.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.view setNeedsUpdateConstraints];
            [UIView animateWithDuration:1 animations:^{
                
                [self.detailContentLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(170);
                }];
                
                [self.discriptionLab mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(170);
                }];
                
                [self.detailContentLab.superview layoutIfNeeded];
                [self.discriptionLab.superview layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self.view setNeedsUpdateConstraints];
                [UIView animateWithDuration:1 animations:^{
                    
                    [self.starTipImgV mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                    }];
                    
                    [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(26) ;
                    }];
                    
                    [self.separatorLine mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(15);
                    }];
                    
                    //告知父类控件绘制，不添加注释的这两行的代码无法生效
                    [self.starTipImgV.superview layoutIfNeeded];
                    [self.tipLabel.superview layoutIfNeeded];
                    [self.separatorLine.superview layoutIfNeeded];
                    
                } completion:^(BOOL finished) {
                    [self.view setNeedsUpdateConstraints];
                    [UIView animateWithDuration:1.5 animations:^{
                        
                        self.tipTitleLabel.alpha = 1;
                        self.tipContentLabel.alpha = 1;
                        self.bottomBtn.alpha = 1;
                        
                        //告知父类控件绘制，不添加注释的这两行的代码无法生效
                    }];
                }];
            }];
        }];
    });

}


- (void)confirmBtnAction {
    
    WS(weakSelf)
    if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        return;
    }
    
    if (![FyUserCenter sharedInstance].userInfoModel.idState) {
        [self LPShowAletWithContent:@"您还没有完成认证，是否前往认证？" left:@"取消" right:@"确认" rightClick:^{
            [weakSelf approveVC];
        }];
        return;
    }
    
    [self nextStep];
}

- (void)nextStep {
    
    WS(weakSelf)
    if (![FyUserCenter sharedInstance].userInfoModel.bankCardState) {
        //可以绑卡
        [self LPShowAletWithContent:@"您还没有绑定银行卡，是否前往绑定？" left:@"取消" right:@"确认" rightClick:^{
            [weakSelf bindBankCard];
        }];
        return;
    }
    
    [self showPactAlert];
}

- (void)bindBankCard {
    //开始绑卡
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击认证中心
- (void)approveVC {
    //    上传同盾token
    [[FyUserCenter sharedInstance] submitTokenkeyIfNeed];
    
    self.approveManager =  [[YMApproveManager alloc] init];
    WS(weakSelf)
    [self.approveManager loadAprroveData:self block:nil];
    [LEEAlertManager sharedManager].successBlock = ^{
        [weakSelf nextStep];
        [[FyUserCenter sharedInstance] loadUserInfoData];
    };
}

- (void)showPactAlert {
    WS(weakSelf)
    [self YMLeasePactAlertWithTitle:@"开始租赁" Content:@"您在使用多米白卡产品回收租赁手机服务前，请确认已经理解并同意《多米白卡手机融资租赁合同》和《多米白卡居间服务协议》。" left:@"取消" right:@"确认" leftClick:^{
        [LEEAlertManager sharedManager].isPactShow = NO;
    } rightClick:^{
        [LEEAlertManager sharedManager].isPactShow = NO;
        [weakSelf toPushLeaseTimeLimitVC];
        
    }];
    [LEEAlertManager sharedManager].clickBlock = ^{
        [[LEEAlertManager sharedManager] showTostWithTitle:@"请先阅读并同意《租赁相关协议》"];
    };
}

- (void)toPushLeaseTimeLimitVC {
    //  先判断登录
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        //判断是否有未完成订单
        [self loadHomeDataComplete:^{
            if (self.model.IsUnfished == 0) {
                
                YMLeaseTimeLimitViewController *vc = [[YMLeaseTimeLimitViewController alloc] init];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self fy_toastMessages:@"您有未完成订单哦~"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];


    }
}

- (void)loadHomeDataComplete:(void(^)())complete{
    
    FyHomePageStateRequestV2 *t = [[FyHomePageStateRequestV2 alloc] init];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        weakSelf.model = model;
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (error.errorCode == NSURLErrorCancelled) {
        }else{
        }
        if (complete) {
            complete();
        }
    }];
}


@end
