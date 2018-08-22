//
//  UMHomeShowAlertManager.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/25.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyFindIndexModelV2.h"

@interface YMHomeShowAlertManager : NSObject

/**
 显示租赁提示框

 @param dataArr 数组
 */
+ (void)showLeaseTipView:(NSArray *)dataArr leaseBlock:(void (^)(NSInteger))leaseBlock;


/**
 显示待交租提示框
 @param model <#model description#>
 @param leaseBlock <#leaseBlock description#>
 */
+ (void)showUnfinishedOrderTipView:(FyFindIndexModelV2 *)model leaseBlock:(void (^)(void))leaseBlock;


/**
 显示指导页

 @param closeBlock <#closeBlock description#>
 */
+ (void)showGuideViewWithcloseBlock:(void (^)(void))closeBlock;
@end
