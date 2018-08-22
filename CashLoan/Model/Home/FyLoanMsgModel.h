//
//  FyLoanMsgModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyLoanMsgModel : NSObject

@property (nonatomic, copy) NSString *mID;
@property (nonatomic, copy) NSString *value;

@end

@interface FyLoanMsgListModel : NSObject

@property (nonatomic, copy) NSArray *list;

@end

