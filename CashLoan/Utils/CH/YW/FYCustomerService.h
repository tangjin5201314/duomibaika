//
//  FYCustomerService.h
//  YWTEST
//
//  Created by 陈浩 on 2017/9/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NOTICE_NEWMESSAGE @"NOTICE_NEWMESSAGE"


@interface FYCustomerService : NSObject

+ (instancetype)defaultService;

- (void)config;
- (NSInteger)unreadCount;

- (void)loginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)(void))aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock; //登录
- (void)logout; //退出登录

- (BOOL)isLogin;
- (void)loginSuccessBlock:(void(^)(void))aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock;
- (void)openCustomerServicePageFromViewController:(UIViewController *)viewController;

@end
