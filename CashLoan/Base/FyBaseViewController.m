//
//  FyBaseViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseViewController.h"

@interface FyBaseViewController ()

@end

@implementation FyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customSet];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nav setNavTitle:self.title];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)customSet {

    if (self.nav) {
        return;
    }
    //输入法
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    JENavView *nav = [[JENavView alloc] init];
    [nav setNavLeftItemImage:[UIImage imageNamed:@"icon_back"] title:nil];

    WS(weakSelf)
    [nav setBlkTouchLeftItem:^{
        [weakSelf backAction];
    }];
    [nav setBlkTouchRightItem:^{
        [weakSelf rightAction];
    }];
    
    self.nav = nav;
    [self.view addSubview:nav];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightAction{
    
}


@end
