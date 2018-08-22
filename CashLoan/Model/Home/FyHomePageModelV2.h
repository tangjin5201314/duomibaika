//
//  FyHomePageModelV2.h
//  CashLoan
//
//  Created by fyhy on 2017/11/22.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyBannerModelV2.h"
#import "FyHomeCardModel.h"
#import "FyUserCenterModel.h"
#import "FyApplyLoanModelV2.h"
#import "FyHomeActionBannersModel.h"
#import "FyLoanMsgModel.h"

@interface FyHomePageModelV2 : NSObject

@property (nonatomic, copy) NSArray *carousel;
@property (nonatomic, copy) NSString *maxLoan;
@property (nonatomic, strong) FyHomeCardModel *headerCard;
@property (nonatomic, strong) FyHomeActionBannersModel *mainBanner;
@property (nonatomic, copy) NSArray *bannerList;
@property (nonatomic, assign) BOOL isBorrow; //是否有未完成借款
@property (nonatomic, strong) Auth *auth;//认证map  qualified    是否可借款
@property (nonatomic, strong) FyApplyLoanModelV2 *nextPage;

@end
