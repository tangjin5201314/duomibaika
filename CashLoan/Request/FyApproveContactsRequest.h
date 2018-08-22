//
//  FyApproveContactsRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyApproveContactsRequest : FyBaseRequest

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *liveAddr;
@property (nonatomic, copy) NSString *detailAddr;
@property (nonatomic, copy) NSString *liveCoordinate;


@end
