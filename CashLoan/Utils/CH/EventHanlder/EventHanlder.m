//
//  EventHanlder.m
//  SATEST
//
//  Created by 陈浩 on 2017/9/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "EventHanlder.h"
#import "SensorsAnalyticsSDK.h"
#import "FYDebug.h"

NSString * const FYEventSendRegisterCode = @"ClickGetCode";
NSString *const FYEventCommitRegister = @"SubmitLogin"; //提交注册
NSString *const FYEventFaceRecognition = @"Liveness"; //人脸识别
NSString *const FYEventIDOCR = @"IdCardOCR"; //身份证识别
NSString *const FYEventApplyLoan = @"ClickLoan"; //申请借款
NSString *const FYEventLoanVerify = @"ConfirmLoan"; //借款确认
NSString *const FYEventCommitTradersPwd = @"SubmitLoan"; //提交交易密码


@implementation NSString (toFloat)

- (CGFloat)toFloat{
    NSString *stringToIntString;
    NSString * resultString = self;
    if (![resultString containsString:@"."]) {
        stringToIntString = resultString;
        NSInteger i = 2;
        while (i > 0){
            stringToIntString = [stringToIntString stringByAppendingString:@"0"];
            i--;
        } ;
    }else{
        NSArray *arr = [resultString componentsSeparatedByString:@"."];
        NSString *fString = arr[1];
        NSString *fString1 = arr[0];
        
        if (fString.length < 2) {
            NSInteger i = 2 - fString.length;
            
            do {
                fString = [fString stringByAppendingString:@"0"];
                i--;
            } while (i > 0);
            
        }else if (fString.length > 2){
            fString = [fString substringToIndex:2];
        }
        
        stringToIntString = [fString1 stringByAppendingString:fString];
    }
    
    NSInteger numerator = [stringToIntString integerValue];
    
    CGFloat num = numerator/100.0;
    return num;
}

@end

@implementation EventHanlder


+ (void)trackSendRegisterCodeEvent{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventSendRegisterCode withProperties:nil];
}

+ (void)trackCommitRegisterEventWithSuccess:(BOOL)success{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventCommitRegister withProperties:@{@"isSuccess": @(success)}];
}

+ (void)trackFaceRecognitionEventWithSuccess:(BOOL)success{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventFaceRecognition withProperties:@{@"isSuccess": @(success)}];
}

+ (void)trackIDOcrEventWithSuccess:(BOOL)success{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventIDOCR withProperties:@{@"isSuccess": @(success)}];
}

+ (void)trackApplyLoanEventWithProductName:(NSString *)productName amount:(CGFloat)amount dayLimit:(NSInteger)dayLimit{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventApplyLoan withProperties:@{@"productName": @"富卡", @"loanAmount":@(amount), @"dayLimit":@(dayLimit)}];

}

+ (void)trackLoanVerifyEventWithProductName:(NSString *)productName amount:(CGFloat)amount dayLimit:(NSInteger)dayLimit fee:(CGFloat)fee auditFee:(CGFloat)auditFee accountManamageFee:(CGFloat)accountManamageFee realAmount:(CGFloat)realAmount{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventLoanVerify withProperties:@{@"productName": @"富卡", @"loanAmount":@(amount), @"dayLimit":@(dayLimit), @"loanInterest":@(fee), @"serviceFee":@(auditFee), @"accountFee":@(accountManamageFee), @"arriveAmount":@(realAmount)}];

}

+ (void)trackCommitTradersPwdEventWithSuccess:(BOOL)success{
    [[SensorsAnalyticsSDK sharedInstance] track:FYEventCommitTradersPwd withProperties:@{@"isSuccess": @(success)}];
}

+ (void)configSensorsAnalytics{
    // 初始化 SDK
    if ([FYDebug isDebug]) {
        [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL_TEST
                                         andConfigureURL:SA_CONFIGURE_URL_TEST
                                            andDebugMode:SA_DEBUG_MODE_TEST];

    }else{
        [SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
                                         andConfigureURL:SA_CONFIGURE_URL
                                            andDebugMode:SA_DEBUG_MODE];

    }
    
    
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen];
    [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"PlatformType" : @"iOS"}];
    
    
    if ([FyUserCenter sharedInstance].isLogin) {
        [self login:[FyUserCenter sharedInstance].userId];
    }
}

+ (void)login:(NSString *)loginId{
    if (loginId.length > 0) {
        [[SensorsAnalyticsSDK sharedInstance] login:loginId];
    }else{
        [[SensorsAnalyticsSDK sharedInstance] logout];
    }
}

@end
