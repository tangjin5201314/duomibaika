//
//  FYPopupManger.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYPopupManger : NSObject

@property (nonatomic, assign) BOOL adReady;
@property (nonatomic, assign) BOOL guideReady;

+ (instancetype)sharedInstance;
- (void)requestAnnouncements;
- (void)requestCheckUpdate;

@end
