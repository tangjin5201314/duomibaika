//
//  FyUploadTureNameRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUploadTureNameRequest.h"

@implementation FyUploadTureNameRequest

- (NSString *)serviceCode{
    return API_SERVICE_REALNAME_FACELIVING;
}

- (NSArray<FyFileModel *> *)files{
    NSMutableArray *temp= [@[] mutableCopy];
    if (self.IDBFile) {
        [temp addObject:self.IDBFile];
    }
    if (self.faceFile) {
        [temp addObject:self.faceFile];
    }
    if (self.envFile) {
        [temp addObject:self.envFile];
    }
    return temp.count > 0 ? temp : nil;
}

- (NSDictionary *)params{ //请求参数
    return @{
             @"education":self.education,
             @"idNo":self.idNo,
             @"idAddr":self.idAddr,
             @"realName":self.realName,
             @"delta":self.delta,
//             @"ocrImg":@"",
             @"marryState":self.marryState,
             @"occupation":self.occupation,
             @"salary": CHECKNULL(self.salary)
//             @"IDPhoto":self.iDPhoto,
//             @"TemporaryIDPhoto":self.temporaryIDPhoto,
//             @"Edited":self.edited,
//             @"Photocopy":self.photocopy,
//             @"Screen":self.screen
             };
}


@end
