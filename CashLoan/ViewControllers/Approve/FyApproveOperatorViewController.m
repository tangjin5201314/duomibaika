//
//  FyApproveOperatorViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveOperatorViewController.h"
#import "FyApproveGetOperatorUrlRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FyApproveChectOperatorTaskIDRquest.h"
#import "FyApproveStepUtil.h"
#import "FyApproveHeaderView.h"
#import "NSString+fyUrl.h"
#import "YMApproveManager.h"
@interface FyApproveOperatorViewController ()

@property (nonatomic, strong) YMApproveManager *approveManager;
@end

@implementation FyApproveOperatorViewController

- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView{
    progressView.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.method = RDWebViewSendMethodGET;
    if (self.autoNext) {
//        [self addWebViewHeaderView];
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.title = @"运营商认证";;
    }
    
    [self requestOperatorUrl];
    

    self.extendedLayoutIncludesOpaqueBars = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.autoNext) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addWebViewHeaderView {
    
    FyApproveHeaderView *view = [FyApproveHeaderView loadNib];
    view.currentStep = 2;
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(0));
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@40);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}

- (void)requestOperatorUrl{
    [self showGif];
    FyApproveGetOperatorUrlRequest *task = [[FyApproveGetOperatorUrlRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyApproveUrlModel * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self hideGif];
            self.url = [error.responseObject[@"resultData"] fy_UrlString];
            [self loadH5Page];
        }
        else{
            [self hideGif];
            [self fy_toastMessages:error.errorMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];

    }];
}

- (void)clickContacts{
//    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepContact autoNext:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.approveManager loadAprroveData:self block:nil];
//    [self removeSelfWhenPushToNext];

}

- (void)operatorApproveSuccess{
    if (self.autoNext) {
        [self clickContacts];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//url解码
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (void)uploadTaskID:(NSString *)taskID{
    [self showGif];
    
    FyApproveChectOperatorTaskIDRquest *task = [[FyApproveChectOperatorTaskIDRquest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            [self operatorApproveSuccess];
        }else{
            [self fy_toastMessages:error.errorMessage];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];

    }];
}



#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // Disable all the '_blank' target in page's target.
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    NSString *lowerAbsoluteString = [absoluteString lowercaseString];
    NSLog(@"%@", absoluteString);
    
//    nextStep://
    if ([lowerAbsoluteString rangeOfString:@"nextstep://"].location != NSNotFound) {
        NSLog(@"nextstep");
        [self operatorApproveSuccess];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
//failStep://
    if ([lowerAbsoluteString rangeOfString:@"failstep://"].location != NSNotFound) {
        NSLog(@"failStep");
        [self operatorApproveSuccess];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    
    if ([lowerAbsoluteString rangeOfString:@"returnurl"].location ==NSNotFound && [lowerAbsoluteString rangeOfString:@"auth_shanyin"].location !=NSNotFound){
        [self uploadTaskID:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    if ([lowerAbsoluteString rangeOfString:@"auth_operator"].location !=NSNotFound && [absoluteString rangeOfString:@"task_id="].location !=NSNotFound){
        NSString *task_id = @"";
        
        NSArray *arr = [absoluteString componentsSeparatedByString:@"task_id="];
        if (arr.count > 0) {
            task_id = [arr lastObject];
            
            arr = [task_id componentsSeparatedByString:@"&"];
            if (arr.count > 0) {
                task_id = [arr firstObject];
            }
        }
        
        [self uploadTaskID:task_id];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([navigationAction.request.URL.absoluteString isEqualToString:kAX404NotFoundURLKey]) {
        [self requestOperatorUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [super webView:webView didStartProvisionalNavigation:navigation];
    [self showGif];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [super webView:webView didFinishNavigation:navigation];
    [self hideGif];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    [super webView:webView didFailNavigation:navigation withError:error];
    [self hideGif];
}

- (YMApproveManager *)approveManager {
    if (!_approveManager) {
        _approveManager = [[YMApproveManager alloc] init];
    }
    return _approveManager;
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
