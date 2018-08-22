//
//  RDWebViewController.m
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/11.
//
//

#import "RDWebViewController.h"
#import <Masonry/Masonry.h>

NSString *const kAX404NotFoundURLKey = @"ax_404_not_found";

#ifndef kAX404NotFoundHTMLPath
#define kAX404NotFoundHTMLPath [[NSBundle bundleForClass:NSClassFromString(@"AXWebViewController")] pathForResource:@"AXWebViewController.bundle/html.bundle/404" ofType:@"html"]
#endif


static NSString const * htmlTitle = @"document.title";


@interface RDWebViewController ()

/**
 进度条
 */
@property (nonatomic, strong) UIProgressView * loadProgressView;

/**
 是否已post请求
 */
@property (nonatomic, assign) BOOL didPostRequest;

/**
 记录请求，刷新用
 */
@property (nonatomic, strong) NSURLRequest *temRequest;

@end

@implementation RDWebViewController
/*
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {} else {
        id<UILayoutSupport> topLayoutGuide = self.topLayoutGuide;
        id<UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(topLayoutGuide.length, 0.0, bottomLayoutGuide.length, 0.0);
        if (!UIEdgeInsetsEqualToEdgeInsets(contentInsets, self.wkWebView.scrollView.contentInset)) {
            [self.wkWebView.scrollView setContentInset:contentInsets];
        }
    }
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = NO;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _didPostRequest = NO;
    //创建web
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityCharacter;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    [_wkWebView setAllowsBackForwardNavigationGestures:true];

    //添加观察者
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:_wkWebView];
    
    
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(64));
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 绘制loadProgressView
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height, navigationBarBounds.size.width, progressBarHeight);
    
    
    _loadProgressView = [[UIProgressView alloc] initWithFrame:barFrame];// CGRectMake(0, 100, 375, 2)
    
    // [self.view addSubview:self.myProgressView];
    [self.view addSubview:_loadProgressView];
    
    
    [_loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@2);
    }];
    
    [self changeShowView:_wkWebView progressView:_loadProgressView];

    [self loadH5Page];
}

- (void)loadH5Page{
    if (_method == RDWebViewSendMethodGET) {
        
        if (_url.length == 0) {
            [self fy_toastMessages:@"连接失效..." hidenDelay:-1];
            return;
        }
        //请求
        NSURLComponents *components = [NSURLComponents componentsWithString:_url];
        NSMutableArray *queryItems = [NSMutableArray array];
        for (NSString *key in _param) {
            NSObject *object = _param[key];
            if ([object isKindOfClass:[NSString class]]) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:_param[key]]];
            }
            else
            {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@",object]]];
            }
        }
        //添加之前的参数
        if (queryItems.count) {
            [queryItems addObjectsFromArray:components.queryItems];
            components.queryItems = queryItems;
        }
        
        //创建完整url
        if (components.URL) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
            if (_headerParam) {
                [_headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [request setValue:obj forHTTPHeaderField:key];
                }];
            }
            _temRequest = request;

            [_wkWebView loadRequest:request];
        }
    }
    else
    {
        // 设置访问的URL
        NSURL *url = [NSURL URLWithString:_url];
        
        if (url) {
            // 根据URL创建请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
            // 设置请求方法为POST
            [request setHTTPMethod:@"POST"];
            // 设置请求参数
            NSData *data =  [NSJSONSerialization dataWithJSONObject:_param options:NSJSONWritingPrettyPrinted error:nil];
            [request setHTTPBody:data];

            // 实例化网络会话
            NSURLSession *session = [NSURLSession sharedSession];
            // 创建请求Task
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                // 将请求到的网页数据用loadHTMLString 的方法加载
                NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [_wkWebView loadHTMLString:htmlStr baseURL:nil];
            }];
            // 开启网络任务
            [task resume];
        }
    }
    
    NSLog(@"webUrl == %@",self.url);

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cleanCacheAndCookie];
}


/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)postRequest:(NSString *)postData
{
    NSString *postJSString = [NSString stringWithFormat:@"post('%@', {%@});", _url, postData];
    [_wkWebView evaluateJavaScript:postJSString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        
    }];
    _didPostRequest = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 刷新网页
 */
-(void)needRefreshWebView
{
    [_wkWebView loadRequest:_temRequest];
    //    [_wkWebView reload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [_wkWebView setNavigationDelegate:nil];
    [_wkWebView setUIDelegate:nil];
}

#pragma mark -需要重写

- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView
{
    
}
#pragma mark -WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if(_isShowTitle)
    {
        self.title = webView.title;
    }
}


// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        [webView reloadFromOrigin];
        return;
    }
    // id _request = [navigation valueForKeyPath:@"_request"];
    [self loadFailPage];
}


- (void)loadURL:(NSURL *)pageURL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pageURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [self.wkWebView loadRequest:request];
}

- (void)loadFailPage{
    [self loadURL:[NSURL fileURLWithPath:kAX404NotFoundHTMLPath]];
}



// 处理拨打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
    
    if ([navigationAction.request.URL.absoluteString isEqualToString:kAX404NotFoundURLKey]) {
        if (_temRequest) {
            [self.wkWebView loadRequest:_temRequest];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == _wkWebView) {
        [_loadProgressView setAlpha:1.0f];
        [_loadProgressView setProgress:_wkWebView.estimatedProgress animated:YES];
        
        if(_wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_loadProgressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [_loadProgressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
