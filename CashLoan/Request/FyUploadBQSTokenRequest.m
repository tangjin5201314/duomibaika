//
//  FyUploadBQSTokenRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUploadBQSTokenRequest.h"

@implementation FyUploadBQSTokenRequest

- (NSDictionary *)params{
    return @{@"tokenKey": self.token};
}

- (NSString *)serviceCode{
    return API_SERVICE_CODE_UPLOADTONGDUNTOKEN;
}

- (BOOL)notifyIfError {
    return NO;
}
@end
