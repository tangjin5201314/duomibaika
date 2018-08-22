//
//  BankCardModel.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/22.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardModel : NSObject
@property (nonatomic , copy) NSString * cardNo;
@property (nonatomic , copy) NSString * userId;
//@property (nonatomic , copy) NSString * id;
@property (nonatomic , copy) NSString * userName;
@property (nonatomic , copy) NSString * bankName;
@property (nonatomic , copy) NSString * desc;
@property (nonatomic , copy) NSString * imgUrl;
@property (nonatomic , copy) NSString * greyImgUrl;

@property (nonatomic , copy) NSString * agreeNo;
@property (nonatomic , copy) NSString * bindTime;
@property (nonatomic , copy) NSString * userNameDidsplay;
@property (nonatomic , assign) BOOL changeable; //是否可以重新绑卡
@property (nonatomic , assign) BOOL isUnsupport;//是否支持银行卡

@end
