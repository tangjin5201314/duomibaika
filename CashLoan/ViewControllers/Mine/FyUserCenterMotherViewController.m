//
//  FyUserCenterMotherViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserCenterMotherViewController.h"
#import "FyH5PageUtil.h"
#import "FyShareAppRequest.h"
//#import "FYShareUtil.h"

@interface FyUserCenterMotherViewController ()

@property (nonatomic, strong) UIButton *phoneBtn;

@end

@implementation FyUserCenterMotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addFloatTel];
//    [self setNeedsStatusBarAppearanceUpdate];
    //    [self preferredStatusBarStyle];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的";
    self.nav.hidden = YES;
//    if ([FYShareUtil hasSuportPlatforms]) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"my_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFloatTel {
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_phoneBtn setBackgroundImage:[UIImage imageNamed:@"usercenter_tel"] forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(telButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_phoneBtn];
    [self.view bringSubviewToFront:_phoneBtn];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(@-46);
        make.right.mas_equalTo(@-20);
        make.width.mas_equalTo(@(SCALE6Width(67)));
        make.height.mas_equalTo(@(SCALE6Width(67)));

    }];
    
}
- (void)telButtonClick {
    [self LPShowAletWithTitle:[FyH5PageUtil phoneNumber] Content:@"" left:@"取消" right:@"拨打" leftClick:^{
    } rightClick:^{
        //拨打电话
        [FyH5PageUtil call];
    }];
}


- (void)share{
    [self showGif];
    FyShareAppRequest *t = [[FyShareAppRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess && model){
//            [FYShareUtil shareWithShareObjectModel:model];
        }else{
            if (error.errorCode != NSURLErrorCancelled) {
                 [self fy_toastMessages:error.errorMessage];
                
            }
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode != NSURLErrorCancelled ) {
            if (error.errorCode != NSURLErrorCancelled) {
                 [self fy_toastMessages:error.errorMessage];
            }
        }
    }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
