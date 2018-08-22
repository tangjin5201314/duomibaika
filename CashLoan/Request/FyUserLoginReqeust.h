//
//  FyUserLoginReqeust.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyUserLoginReqeust : FyBaseRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *code;

/**
 验证类型
 */
@property (nonatomic, copy) NSString *type;
/**
验证类型
*/
@property (nonatomic, copy) NSString *businessType;
@end
