//
//  FyUploadTureNameRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyUploadTureNameRequest : FyBaseRequest

@property (nonatomic, strong) FyFileModel *IDBFile;
@property (nonatomic, strong) FyFileModel *faceFile;
@property (nonatomic, strong) FyFileModel *envFile;

@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *idNo;
@property (nonatomic, copy) NSString *idAddr;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *delta;

//@property (nonatomic, copy) NSString *ocrImg;
@property (nonatomic, copy) NSString *marryState;
@property (nonatomic, copy) NSString *occupation;
@property (nonatomic, copy) NSString *salary;

//@property (nonatomic, copy) NSString *iDPhoto;
//@property (nonatomic, copy) NSString *temporaryIDPhoto;
//@property (nonatomic, copy) NSString *edited;
//@property (nonatomic, copy) NSString *photocopy;
//@property (nonatomic, copy) NSString *screen;


@end
