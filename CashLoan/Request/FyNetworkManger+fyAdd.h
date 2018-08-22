//
//  FyNetworkManger+fyAdd.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyNetworkManger.h"
#import "FyBaseRequest.h"

@interface TmpBodyHeaderObject : NSObject

@property (nonatomic, copy) NSDictionary *bodyParams;
@property (nonatomic, copy) NSDictionary *headerParams;

@end

@interface FyNetworkManger (fyAdd)

- (TmpBodyHeaderObject *)bodyHeardObjectWithRequsetModel:(FyBaseRequest *)requestModel; //获取处理后的头信息、请求体参数

@end
