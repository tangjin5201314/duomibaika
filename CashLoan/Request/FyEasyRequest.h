//
//  FyEasyRequest.h
//  CashLoan
//
//  Created by lilianpeng on 2017/11/29.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyEasyModel.h"

@interface FyEasyRequest : FyBaseRequest

@property (nonatomic, strong) NSDictionary *loadParams;
@property (nonatomic, copy) NSString *loadMothod;
@property (nonatomic, copy) NSString *loadUrlPath;
@property (nonatomic, strong) Class loadModelClass;
@end
