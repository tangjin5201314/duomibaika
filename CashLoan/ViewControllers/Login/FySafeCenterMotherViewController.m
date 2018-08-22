//
//  FySafeCenterMotherViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySafeCenterMotherViewController.h"

@interface FySafeCenterMotherViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation FySafeCenterMotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"安全中心";
    self.loginOutBtn.layer.borderColor = [UIColor colorWithHexString:@"c9d3e0"].CGColor;
}

- (IBAction)logOUt:(id)sender {
    [self LPShowAletWithTitle:@"确定要登出当前账号？" Content:@"" left:@"取消" right:@"确定" leftClick:^{
        
    } rightClick:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYNOTIFICATION_LOGOUT object:nil];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
