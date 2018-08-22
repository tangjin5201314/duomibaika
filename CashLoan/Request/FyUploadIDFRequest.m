//
//  FyUploadIDFRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUploadIDFRequest.h"
#import "IDCardModel.h"

@implementation FyUploadIDFRequest

- (NSString *)serviceCode{
    return API_SERVICE_REALNAME_OCR;
}

- (NSArray<FyFileModel *> *)files{
    if (self.idF) {
        return @[self.idF];
    }
    return nil;
}

- (Class)objectClass{
    return [FrontModel class];
}


@end
