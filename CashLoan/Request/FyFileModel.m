//
//  FyFileModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFileModel.h"

@implementation FyFileModel

- (instancetype)initWithFileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    self = [super init];
    if(self){
        self.fileData = fileData;
        self.name = name;
        self.filename = fileName;
        self.mimeType = mimeType;
    }
    return self;
}


@end
