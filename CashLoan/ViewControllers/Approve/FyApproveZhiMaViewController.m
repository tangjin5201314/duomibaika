//
//  FyApproveZhiMaViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveZhiMaViewController.h"
#import "FyApproveGetZhiMaUrlRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FyApproveStepUtil.h"
#import "FyApproveHeaderView.h"
#import "YMApproveManager.h"
/*CB_YZZBScriptMessageHandler.h*/
#import <Foundation/Foundation.h>
#import "YMApproveManager.h"
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface CB_YZZBScriptMessageHandler : NSObject<WKScriptMessageHandler>

@property (nullable, nonatomic, weak)id <WKScriptMessageHandler> delegate;

/** 创建方法 */
- (instancetype)initWithDelegate:(id <WKScriptMessageHandler>)delegate;

/** 便利构造器 */
+ (instancetype)scriptWithDelegate:(id <WKScriptMessageHandler>)delegate;;

@end

NS_ASSUME_NONNULL_END


/*CB_YZZBScriptMessageHandler.m*/
@implementation CB_YZZBScriptMessageHandler

-(instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    if (self = [super init])
    {
        _delegate = delegate;
    }
    
    return self;
}


+(instancetype)scriptWithDelegate:(id<WKScriptMessageHandler>)delegate {
    return [[CB_YZZBScriptMessageHandler alloc] initWithDelegate:delegate];
}


#pragma mark - <WKScriptMessageHandler>
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end


@interface FyApproveZhiMaViewController ()<WKScriptMessageHandler>{
    BOOL hasPush;
    BOOL shouldShowGif;
}

@property (nonatomic, strong) YMApproveManager *approveManager;
@end

@implementation FyApproveZhiMaViewController

- (void)dealloc {
    [[self.wkWebView configuration].userContentController removeScriptMessageHandlerForName:@"webReturn"];
}


- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView{
    progressView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.autoNext) {
    } else {
        self.title = @"芝麻信用认证";
    }
    self.method = RDWebViewSendMethodGET;
//    if (self.autoNext) {
//        [self addWebViewHeaderView];
//    }
    [self requestZhiMaUrl];
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
    view.currentStep = 1;
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(0));
        make.height.mas_equalTo(@(40));
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(40));
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
}


- (void)requestZhiMaUrl {

    [self showGif];

    FyApproveGetZhiMaUrlRequest *task = [[FyApproveGetZhiMaUrlRequest alloc] init];

    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyApproveUrlModel * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self hideGif];
            if (!model.url) {
                [self fy_toastMessages:@"网络开小差了"];

            }else{
                self.url = model.url;
                [self loadH5Page];
            }
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

- (void)clickOperator{
//    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepOperator autoNext:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.approveManager loadAprroveData:self block:nil];
//    [self removeSelfWhenPushToNext];
}

//url解码
-(NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // Disable all the '_blank' target in page's target.
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    NSLog(@"%@", absoluteString);
    shouldShowGif = YES;
    
    if ([absoluteString rangeOfString:@"api/actzm/mine/zhima/AuthCallBack.htm"].location !=NSNotFound && [absoluteString rangeOfString:@"error_code="].location !=NSNotFound) {
        shouldShowGif = NO;

        absoluteString = [self URLDecodedString:absoluteString];
        NSArray *array = [absoluteString componentsSeparatedByString:@"error_code="];
        
        if (array.count > 1) {
            if (array.count > 1) {
                if ([array.lastObject isEqualToString:@"SUCCESS"]) {
                    [self zhimaSuccess];
                } else {
                    [self zhimaFail];
                }
                
            }
        }
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if ([navigationAction.request.URL.absoluteString isEqualToString:kAX404NotFoundURLKey]) {
        [self requestZhiMaUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)zhimaSuccess{
    if (!hasPush) {
        hasPush = YES;
        if (self.autoNext) {
            [self clickOperator];
        }else {
            [self LPShowAletWithContent:@"操作成功" okClick:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    }
}

- (void)zhimaFail{
    [self LPShowAletWithContent:@"操作失败" okClick:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    [super webView:webView didStartProvisionalNavigation:navigation];
    if (shouldShowGif && !hasPush)
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"webReturn"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        
        NSString *params = message.body;
        if ([params rangeOfString:@"code="].location !=NSNotFound && [params rangeOfString:@"msg="].location !=NSNotFound) {
            NSArray *paramsArray = [params componentsSeparatedByString:@","];
            if (paramsArray.count < 2) return;
            ////0 fail ;1 success
            NSInteger code = [[paramsArray[0] stringByReplacingOccurrencesOfString:@"code=" withString:@""] integerValue];
            NSString *msg = [paramsArray[1] stringByReplacingOccurrencesOfString:@"msg=" withString:@""];

            if (code == 1) {
                [self zhimaSuccess];
            }else{
                [self LPShowAletWithContent:msg];
            }
        }
        
    }
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
