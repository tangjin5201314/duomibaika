//
//  UIViewController+fyBase.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIViewController+fyBase.h"
#import <objc/runtime.h>
//#import "Global.h"
//#import <UMMobClick/MobClick.h>
#import "FyBaseNavigationBar.h"

static const BOOL kBlock;

static char *kColor = "kColor";
static char *kLineColor = "kLineColor";

@implementation UIViewController (fyBase)

+ (void)swizzWithClass:(Class)class originSel:(SEL)originalSelector newSel:(SEL)swizzledSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

+ (void)load{
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"dealloc") newSel:@selector(fy_dealloc)];
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewDidLoad") newSel:@selector(fy_viewDidLoad)];
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewDidDisappear:") newSel:@selector(fy_viewDidDisappear:)];
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewDidAppear:") newSel:@selector(fy_viewDidAppear:)];
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewWillAppear:") newSel:@selector(fy_viewWillAppear:)];
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewWillDisappear:") newSel:@selector(fy_viewWillDisappear:)];
}

-(void)fy_viewDidLoad{
    [self fy_viewDidLoad];
}

- (void)setTipAction:(BOOL (^)(void))tipAction{
    objc_setAssociatedObject(self, &kBlock, tipAction, OBJC_ASSOCIATION_COPY);
}

- (BOOL (^)(void))tipAction{
    return objc_getAssociatedObject(self, &kBlock);
}

-(NSArray<UIBarButtonItem *>*) createBackButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.frame = CGRectMake(0, 0, 50, 32);
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor textColorV2] forState:UIControlStateNormal];
    [backBtn setTitle:@"    " forState:UIControlStateNormal];
    return @[[[UIBarButtonItem alloc] initWithCustomView:backBtn]];
}

- (void)popself{
    if (self.tipAction) {
        if(self.tipAction()){
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }

        }
    }else{
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)fy_dealloc{
    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
    [self fy_dealloc];
}

- (void)fy_viewWillAppear:(BOOL)animated{
//    [MobClick beginLogPageView:NSStringFromClass([self class])];//页面名称，可自定义)

    if ([self.navigationController.navigationBar isKindOfClass:[FyBaseNavigationBar class]]) {
        FyBaseNavigationBar *fyBar = (id)self.navigationController.navigationBar;
        
        [fyBar setBackgroundImage:[UIImage imageWithColor:self.fy_navigationBarColor] forBarMetrics:UIBarMetricsDefault];

        [fyBar setShadowImage:[UIImage imageWithColor:self.fy_navigationBarLineColor]];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        fyBar.backgroundView.backgroundColor = self.fy_navigationBarColor;
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    
    [self fy_viewWillAppear:animated];
//    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
}

- (void)fy_viewDidAppear:(BOOL)animated{
    [self fy_viewDidAppear:animated];

//    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
}

- (void)fy_viewWillDisappear:(BOOL)animated{
    [self fy_viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass([self class])];

//    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
}

- (void)fy_viewDidDisappear:(BOOL)animated{
    [self fy_viewDidDisappear:animated];
//    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
}

- (void)setFy_navigationBarColor:(UIColor *)fy_navigationBarColor{
    fy_navigationBarColor = fy_navigationBarColor  ? : [UIColor whiteColor];
    if (self.isViewLoaded && self.view.window) {
        FyBaseNavigationBar *fyBar = (id)self.navigationController.navigationBar;

        [fyBar setBackgroundImage:[UIImage imageWithColor:fy_navigationBarColor] forBarMetrics:UIBarMetricsDefault];


    }
    objc_setAssociatedObject(self, kColor, fy_navigationBarColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)fy_navigationBarColor{
    return objc_getAssociatedObject(self, kColor) ? : [UIColor whiteColor];
}

- (void)setFy_navigationBarLineColor:(UIColor *)fy_navigationBarLineColor{
    fy_navigationBarLineColor = fy_navigationBarLineColor  ? : [UIColor separatorColor];

    if (self.isViewLoaded && self.view.window) {
        FyBaseNavigationBar *fyBar = (id)self.navigationController.navigationBar;
        [fyBar setShadowImage:[UIImage imageWithColor:fy_navigationBarLineColor]];
    }

    objc_setAssociatedObject(self, kLineColor, fy_navigationBarLineColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)fy_navigationBarLineColor{
    return objc_getAssociatedObject(self, kLineColor) ? : [UIColor clearColor];
}
@end
