//
//  FyEasyRequest.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/29.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyEasyRequest.h"

@implementation FyEasyRequest

- (NSString *)mothod{
    return self.loadMothod ? self.loadMothod : @"POST";
    
}
- (NSDictionary *)params{
    
    return self.loadParams ? _loadParams : nil;
}
//- (NSDictionary *)headerParams{
//    return nil;
//}
- (NSString *)serviceCode{
    return  self.loadUrlPath ? self.loadUrlPath : nil;
}
- (Class)objectClass{
    return self.loadModelClass ? self.loadModelClass : nil;
}

- (BOOL)notifyIfError {
    return NO;
}
//- (NSArray<FyFileModel *> *)files{
//    return nil;
//}


@end
