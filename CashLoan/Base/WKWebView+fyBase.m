//
//  WKWebView+fyBase.m
//  CashLoan
//
//  Created by fyhy on 2017/11/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "WKWebView+fyBase.h"

@implementation WKWebView (fyBase)

+ (void)swizzWithClass:(Class)class originSel:(SEL)originalSelector newSel:(SEL)swizzledSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load{
    [self swizzWithClass:[self class] originSel:NSSelectorFromString(@"dealloc") newSel:@selector(fy_dealloc)];
}


- (void)fy_dealloc{
    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
    [self fy_dealloc];
}



@end
