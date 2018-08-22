//
//  LEEAlertManager.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEEAlertManager : NSObject
@property (nonatomic, assign) BOOL isPactShow;
@property (nonatomic, copy)  void (^clickBlock)(void);
@property (nonatomic, copy)  void (^successBlock)(void);

//@property (nonatomic, assign) BOOL iSuccessApprove;

+ (instancetype)sharedManager;

- (void)showTostWithTitle:(NSString *)tittle;
@end
