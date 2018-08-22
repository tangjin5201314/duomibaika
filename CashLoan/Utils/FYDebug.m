//
//  FYDebug.m
//  CashLoan
//
//  Created by 陈浩 on 2017/9/21.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "FYDebug.h"
#import "FyNetworkManger.h"

@implementation FYDebug

+ (BOOL)isDebug{
    return  ![FyNetworkManger sharedInstance].useProductionServer;
}

@end
