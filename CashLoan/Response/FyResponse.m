//
//  FyResponse.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyResponse.h"

@implementation FyResponse

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _errorData = responseData;
    }
    return self;
}
- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSString *)resData pageData:(NSDictionary *)pageDic{
    self = [super init];
    if (self) {
        _errorCode = code;
        _errorMessage = errorMessage;
        _resultData = resData;
        _pageData = pageDic;
    }
    return self;
}

- (id)resData{
    return [self.resultData mj_JSONObject];
}

@end
