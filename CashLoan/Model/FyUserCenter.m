//
//  FyUserCenter.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserCenter.h"
#import "DataBaseManager.h"
//#import "BqsDeviceFingerPrinting.h"
#import "FMDeviceManager.h"
#import "FyUploadBQSTokenRequest.h"
#import "FyGetUserInfoRequest.h"

@interface FyUserCenter()
//@property (nonatomic, copy) NSString *tondunToken;
@end

@implementation FyUserCenter

@synthesize accessToken = _accessToken;

NSString * const FYNOTIFICATION_LOGINSUCCESS = @"FYNOTIFICATION_LOGINSUCCESS";
NSString * const FYNOTIFICATION_LOGOUT = @"FYNOTIFICATION_LOGOUT";
NSString * const FYNOTIFICATION_LOAN = @"FYNOTIFICATION_LOAN";

static FyUserCenter *center = nil;

- (NSString *)userId {
    return [NSString stringWithFormat:@"%ld",self.uId];
}

- (NSString *)setLoginPwd {
    return [NSString stringWithFormat:@"%d",self.loginPwd];
}

- (NSString *)setPayPwd {
    return [NSString stringWithFormat:@"%d",self.payPwd];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"accessToken" : @"resultData.token",
             @"refreshToken" : @"resultData.refreshToken",
             @"uId" : @"resultData.userId",
             @"userName" : @"userInfo.loginName",
             @"loginPwd" : @"userInfo.setLoginPwd",
             @"payPwd" : @"userInfo.setPayPwd"
             };
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (center == nil) {
            center = [[FyUserCenter alloc] init];
//            [center initBqsDFSDK];
        }
    });
    return center;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [super allocWithZone:zone];
    });
    
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [FyUserCenter mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//];
        [[DataBaseManager sharedInstance] loadUser:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:FYNOTIFICATION_LOGINSUCCESS object:nil];
        
    }
    return self;
}

#if !__has_feature(objc_arc)

-(id)mutableCopyWithZone:(NSZone *)zone{
    return center;
}

-(id)copyWithZone:(NSZone *)zone{
    return center;
}

#endif

- (BOOL)isLogin{
    return _accessToken.length > 0;
}

-(BOOL)cleanUp{
    BOOL reslut = [[DataBaseManager sharedInstance] userLogOut:self];
    _accessToken = @"";
    _refreshToken = @"";
    _userId = @"";
    _userName = @"";
    _loginPwd = NO;
    _payPwd = NO;
    return reslut;
}

- (BOOL)save{
    NSLog(@"_setPayPwd == %@ ,payPwd == %d",self.setPayPwd,self.payPwd);
    NSLog(@"_setLoginPwd == %@ ,loginPwd == %d",self.setLoginPwd,self.loginPwd);

    return  [[DataBaseManager sharedInstance] savetUserInfo:self];
}

- (void)loginSuccess {
//    [self submitTokenkeyIfNeed];
}

- (void)submitTokenkeyIfNeed {
    
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    NSString *blackBox = manager->getDeviceInfo();

    if (blackBox.length != 0 && self.isLogin) {
        NSLog(@"同盾设备指纹数据: %@", blackBox);
        [self submitTokenkey:blackBox];
    }
}

/**
 上传这个tokenkey到富银服务器，富银服务器将tokenkey传给白骑士服务器
 */
- (void)submitTokenkey:(NSString *)token {
    //发起Http请求
    //....
    FyUploadBQSTokenRequest *t = [[FyUploadBQSTokenRequest alloc] init];
    t.token = token;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];
}

- (void)loadUserInfoData {
    FyGetUserInfoRequest *task = [[FyGetUserInfoRequest alloc] init];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserInfoV2 *model) {
        weakSelf.userInfoModel = model;
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
    }];
}


@end
