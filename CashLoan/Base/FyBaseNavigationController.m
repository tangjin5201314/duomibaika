//
//  FyBaseNavigationController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseNavigationController.h"
#import "UIImage+Tools.h"
#import "UIViewController+fyBase.h"
#import "FyBaseNavigationBar.h"

@interface FyBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation FyBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FyBaseNavigationBar *bar = [[FyBaseNavigationBar alloc] init];
    [self setValue:bar forKey:@"navigationBar"];

    [self navigationViewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationViewDidLoad{
//    FyBaseNavigationBar *bar = (id)self.navigationBar;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor textColorV2]};
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.viewControllers.count > 1;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItems =[viewController createBackButton];
    }
    
}

@end
