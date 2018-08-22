//
//  RDWebViewController.h
//  Pods
//
//  Created by cxk@erongdu.com on 2017/1/11.
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

UIKIT_EXTERN NSString * const kAX404NotFoundURLKey;

typedef NS_ENUM(NSInteger, RDWebViewSendMethod)
{
    RDWebViewSendMethodPOST = 0,
    RDWebViewSendMethodGET = 1,
};

@interface RDWebViewController : FyBaseViewController<WKNavigationDelegate, WKUIDelegate>

/**
 *  url链接
 */
@property (nonatomic, retain) NSString* url;
/**
 *  参数
 */
@property (nonatomic, strong) NSDictionary *param;

/**
 web
 */
@property (nonatomic, strong) WKWebView * wkWebView;

/**
 头参数
 */
@property (nonatomic, strong) NSDictionary *headerParam;

/**
 请求方式
 */
@property (nonatomic, assign) RDWebViewSendMethod method;

/**
 是否显示网页标题
 */
@property (nonatomic, assign) BOOL isShowTitle;

/**
 刷新网页
 */
-(void)needRefreshWebView;

#pragma mark -子类需要重写的方法

- (void)changeShowView:(WKWebView *)webview progressView:(UIProgressView *)progressView;
- (void)loadH5Page;
@end
