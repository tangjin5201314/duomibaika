//
//  FyNetworkResult.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyNetworkResult : NSObject

/**
 *  返回结果code
 */
@property (nonatomic, assign)NSInteger resultCode;
/**
 *  返回的Message
 */
@property (nonatomic, strong)NSString *resultMessage;

/**
 *  返回数据resData,可选
 */
@property (nonatomic, strong)NSString *resultData;
@property (nonatomic, strong)NSDictionary *page;

@end
