//
//  FyHelpViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHelpViewController.h"
#import "FYCustomerService.h"
#import "FyLoginUtil.h"

@interface FyHelpViewController ()

@property (nonatomic, strong) UIButton *kfBtn;

@end

@implementation FyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge) name:NOTICE_NEWMESSAGE object:nil];
}

//客服
- (void)pushToInLineHelp{
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        [[FYCustomerService defaultService] openCustomerServicePageFromViewController:self];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadBadge];
    
}

- (void)reloadBadge{
    self.kfBtn.selected = [[FYCustomerService defaultService] unreadCount] > 0 ? YES : NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
