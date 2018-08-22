//
//  FySupportBanksRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/12/15.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FySupportBankModel : NSObject

@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *imgUrl;

@end

@interface FySupportBankListModel : NSObject

@property (nonatomic, copy) NSArray *list;

@end

@interface FySupportBanksRequest : FyBaseRequest

@end
