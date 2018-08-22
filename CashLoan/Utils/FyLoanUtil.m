//
//  FyLoanUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/12/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanUtil.h"
#import "FyLoginUtil.h"
#import "FyApproveStepUtil.h"
#import "FyLoanPremiseModelRequest.h"
#import "FyRootTabBarViewController.h"
#import "FyConfrmLoanViewControllerV2.h"
#import "FyLackOfCreditPopView.h"
#import "NSString+FormatNumber.h"

@implementation FyLoanUtil

+ (void)applyIfNeededWithModel:(FyLoanPremiseModelV2 *)model fromViewController:(UIViewController *)viewController{
    
#pragma  mark -- test
    if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:viewController]) return;
    if (!model.auth){
        [viewController showGif];
        [self loadLoanPremiseModelComplete:^(FyLoanPremiseModelV2 *m){
            [viewController hideGif];
            if (m.auth) {
                [self applyIfNeededWithModel:m fromViewController:viewController];
            }else{
                [self showNoDataMessageFromViewController:viewController];
            }
        }];
     
        return;
    }
    
    if (model.auth.isHasBaseAuth == false || model.creditInfo.isHasCredit!= CreditStautsSuccess) {
        [self pushToApproveCenterFromViewController:viewController];
        return;
    }
    
    if (model.order.isHasOrder) {
        FyRootTabBarViewController *tabBarVC = (id)viewController.tabBarController;
        [tabBarVC selectLoandHistory];
        return;
    }
    
    if (!model.product) {
        [self showNoDataMessageFromViewController:viewController];
        return;
    }
    
    if ([model.creditInfo.credit doubleValue] < [model.product.singleMin doubleValue]) {
        [self showLackOfCreditPopViewWithModel:model];
        return;
    }
    [self applyLoanWithModel:model fromViewController:viewController];

}

+ (void)showLackOfCreditPopViewWithModel:(FyLoanPremiseModelV2 *)model{
    FyLackOfCreditPopView *view = [FyLackOfCreditPopView loadNib];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    NSString *text = [NSString stringWithFormat:@"很遗憾，您当前额度低于最低可借额度%@元。请持续关注富卡APP，额度会定期评估。", [NSString stringNumberFormatterWithDoubleAutoDot:[model.product.singleMin doubleValue]]];
    view.textLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    view.fyShowStyle = FyViewShowStyleCenter;
    [view fy_Show];

}

+ (void)loadLoanPremiseModelComplete:(void (^)(FyLoanPremiseModelV2 *model))complete{
    FyLoanPremiseModelRequest *t = [[FyLoanPremiseModelRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (complete) {
            complete(model);
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete(nil);
        }
    }];
}

+ (void)pushToApproveCenterFromViewController:(UIViewController *)viewController{
    if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:viewController]) return;
    UIViewController *vc = [FyApproveStepUtil approveCenterViewController];
    [viewController.navigationController pushViewController:vc animated:YES];
}


+ (void)showNoDataMessageFromViewController:(UIViewController *)viewController{
    [viewController fy_toastMessages:@"网络开小差了!"];
}

+ (void)applyLoanWithModel:(FyLoanPremiseModelV2 *)model fromViewController:(UIViewController *)viewController{
    FyConfrmLoanViewControllerV2 *vc = [FyConfrmLoanViewControllerV2 loadFromStoryboardName:@"LoanStoryboard" identifier:nil];
    vc.loanModel = model;
    [viewController.navigationController pushViewController:vc animated:YES];
}



@end
