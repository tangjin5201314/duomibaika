//
//  FyHomeActionBannersModel.h
//  CashLoan
//
//  Created by fyhy on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyBannerModelV2.h"

@interface FyHomeActionBannersModel : NSObject

@property (nonatomic, strong) FyBannerModelV2 *leftBanner;
@property (nonatomic, strong) FyBannerModelV2 *centerBanner;
@property (nonatomic, strong) FyBannerModelV2 *rightBanner;

@end
