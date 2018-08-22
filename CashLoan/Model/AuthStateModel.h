//
//  AuthStateModel.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 认证状态
 
 - AuthStateTypeNone: 未认证
 - AuthStateTypeWait: 认证中
 - AuthStateTypePass: 已认证
 - AuthStateTypeFail: 认证失败
 
 */
typedef NS_ENUM(NSInteger,AuthStateType){
    AuthStateTypeUnknown = 0,
    AuthStateTypeNone = 10,
    AuthStateTypeWait = 20,
    AuthStateTypePass = 30,
    AuthStateTypeTimeout = 40,
    AuthStateTypeFail = 50
};


@interface AuthStateModel : NSObject
/**
 银行卡认证状态
 */
@property(nonatomic,assign)AuthStateType bankCardState;
/**
 联系人认证状态
 */
@property(nonatomic,assign)AuthStateType contactState;
/**
 身份认证
 */
@property(nonatomic,assign)AuthStateType idState;
/**
 手机运营商
 */
@property(nonatomic,assign)AuthStateType phoneState;
/**
 芝麻信用
 */
@property(nonatomic,assign)AuthStateType zhimaState;
/**
 淘宝认证
 */
@property(nonatomic,assign)AuthStateType taobaoState;
/**
 账单邮箱认证
 */
@property(nonatomic,assign)AuthStateType creditCardState;

@property(nonatomic,copy)NSString *authID;
@property(nonatomic,copy)NSString *userId;
@end
