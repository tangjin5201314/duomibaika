//
//  FyUserCenterModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Auth :NSObject
@property (nonatomic , assign) NSInteger             result; //已认证项个数
@property (nonatomic , copy) NSString              * total;
@property (nonatomic , assign) BOOL               qualified; //是否认证完成

@end

@interface Data :NSObject
@property (nonatomic , copy) NSString              * creditTotal;
@property (nonatomic , copy) NSString              * invitationCode;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * profitRate;
@property (nonatomic , copy) NSString              * creditUsed;
@property (nonatomic , copy) NSString              * bankCardState;
@property (nonatomic , copy) NSString              * creditUnused;
@property (nonatomic , copy) NSString              * idState;
@property (nonatomic , strong) Auth              * auth;
@property (nonatomic , copy) NSString              * ampm;
@property (nonatomic , copy) NSString              * customServiceID;

@end


@interface FyUserCenterModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) Data              * data;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * AMorPM;

@end
