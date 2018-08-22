//
//  FyUserCenter.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyUserInfoV2.h"

UIKIT_EXTERN NSString * const FYNOTIFICATION_LOGINSUCCESS;
UIKIT_EXTERN NSString * const FYNOTIFICATION_LOGOUT;
UIKIT_EXTERN NSString * const FYNOTIFICATION_LOAN;

@interface FyUserCenter : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign, readonly) BOOL isLogin;


/********************************登录信息********************/

//@property (nonatomic) int code;
//@property (nonatomic , copy) NSString  * msg;
/**
 *  用户名
 */
@property(nonatomic, copy)NSString *userName;

/**
 *  登录认证信息
 */
@property(nonatomic,copy)NSString *accessToken;

/**
 *  刷新token
 */
@property(nonatomic, copy)NSString *refreshToken;

/**
 *  用户id
 */
@property(nonatomic, copy)NSString *userId;

/**
 *  用户id
 */
@property(nonatomic, assign)NSInteger uId;

/**
 *  setLoginPwd 0是未设置 1是设置
 */
@property(nonatomic, assign)BOOL loginPwd;
/**
 *  setPayPwd 0是未设置 1是设置
 */
@property(nonatomic, assign)BOOL payPwd;

/**
 用户信息model
 */
@property (nonatomic, strong) FyUserInfoV2 *userInfoModel;

/**
 退出登录
 
 @return 成功YES 失败NO
 */
-(BOOL)cleanUp;
- (BOOL)save;
- (void)submitTokenkeyIfNeed;

- (void)loadUserInfoData;

@end
