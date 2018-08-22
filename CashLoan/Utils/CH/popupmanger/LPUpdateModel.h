//
//  LPUpdateModel.h
//  CashLoan
//
//  Created by lilianpeng on 2017/9/13.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailData :NSObject
@property (nonatomic , copy) NSString              * versioncode;
@property (nonatomic , copy) NSString              * updatemsg;
@property (nonatomic , copy) NSString              * isforce;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic, copy) NSString               *updateUrl;

@end

@interface LPUpdateModel :NSObject
@property (nonatomic , copy) NSString              * resultMessage;
@property (nonatomic , strong) NSArray     * resultData;
@property (nonatomic , copy) NSString              * resultCode;

@end
