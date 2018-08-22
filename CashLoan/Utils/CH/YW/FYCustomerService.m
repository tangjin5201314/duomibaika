//
//  FYCustomerService.m
//  YWTEST
//
//  Created by 陈浩 on 2017/9/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYCustomerService.h"
//#import <WXOpenIMSDKFMWK/YWFMWK.h>
//#import <WXOUIModule/YWUIFMWK.h>
#import "FYDebug.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FyGetYWAccountRequest.h"

#define YWAppKey @"24631673"
#define kCustomerID @"立马小秘"
#define kCustomerDisplayname @"立马小秘"


typedef enum : NSUInteger {
    CSLoginStatusLogout = 0,
    CSLoginStatusSigning, //正在登录中
    CSLoginStatusSuccess,
    CSLoginStatusFail,
} CSLoginStatus;

static FYCustomerService *service = nil;

@interface FYCustomerService (){
    __weak UIViewController *fromViewController;
    NSURLSessionDataTask * task;
}

//@property (strong, nonatomic, readwrite) YWIMKit *ywIMKit;
//@property (nonatomic, strong) YWConversation *conversation; //客服会话
//@property (nonatomic, strong) YWPerson *person; //客服

@property (nonatomic, assign) BOOL ywSuccess; //云旺初始化成功失败
@property (nonatomic, assign) CSLoginStatus loginStatus; //登录状态

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *password;


@end

@implementation FYCustomerService

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)defaultService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!service) {
            service = [[self alloc] init];
        }

    });
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (NSInteger)unreadCount{
//    return [[self.conversation conversationUnreadMessagesCount] integerValue];
    return 0;
}

- (void)config{
    /*
    if (self.ywSuccess) return;
    /// 设置环境
//    if ([FYDebug isDebug]) {
//        [[YWAPI sharedInstance] setEnvironment:YWEnvironmentSandBox];
//    }
   
    
    NSLog(@"SDKVersion:%@", [YWAPI sharedInstance].YWSDKIdentifier);
    
    NSError *error = nil;
    
    /// 同步初始化IM SDK
    [[YWAPI sharedInstance] syncInitWithOwnAppKey:YWAppKey getError:&error];
    if ([FYDebug isDebug]) {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"sand_push"]; //设置推送证书
    }else{
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"production1"]; //设置推送证书
    }
    
    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited) {
        /// 初始化失败
        NSLog(@"初始化失败");
        
    } else {
        if (error.code == 0) {
            NSLog(@"初始化成功");
            
            /// 首次初始化成功
            /// 获取一个IMKit并持有
            self.ywIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];

            [[self.ywIMKit.IMCore getContactService] setEnableContactOnlineStatus:YES]; //在线状态
            [self addNewMessageBlock];
            [self setAvatar];
            [self customUI];
            
            if ([FyUserCenter sharedInstance].isLogin) {
                [self loginSuccessBlock:nil failedBlock:nil];
            }
            self.ywSuccess = YES;
            
            [[NSNotificationCenter defaultCenter] addObserverForName:@"loginsuccess" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [self loginSuccessBlock:nil failedBlock:nil];
            }];
            

        } else {
            /// 已经初始化
            self.ywSuccess = NO;
        }
    }
    
    */

}

- (void)addNewMessageBlock{
    /*
    [[self.ywIMKit.IMCore getConversationService] addOnNewMessageBlock:^(NSArray *aMessages) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_NEWMESSAGE object:nil];
    } forKey:@"newMessage" ofPriority:YWBlockPriorityDeveloper];
     */
}

- (void)customUI{
    /*
    YWIMKit *imkit = self.ywIMKit;
    NSString *bundleName = @"FY-YWResources.bundle";
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    NSBundle *customizedUIResourcesBundle = [NSBundle bundleWithPath:bundlePath];
    [imkit setCustomizedUIResources:customizedUIResourcesBundle];
     */

}

- (void)setAvatar{
    /*
    [self.ywIMKit setAvatarImageViewCornerRadius:0.f];
    [self.ywIMKit setAvatarImageViewContentMode:UIViewContentModeScaleAspectFill];
    
    [self.ywIMKit setFetchProfileForEServiceBlock:^(YWPerson *aPerson, YWProfileProgressBlock aProgressBlock, YWProfileCompletionBlock aCompletionBlock) {
        YWProfileItem *item = [[YWProfileItem alloc] init];
        item.person = aPerson;
        item.displayName = aPerson.personId;
        item.avatar = [UIImage imageNamed:@"Customer"];
        aCompletionBlock(YES, item);
    }];
     */
}

- (void)loginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)(void))aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock{
    /*
    self.userId = aUserID;
    self.password = aPassword;
    
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    __weak typeof(self) wSelf = self;
    
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.ywIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    
    /// 发起登录
    [[self.ywIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        NSLog(@"userid %@, psd %@", self.userId, self.password);
        NSLog(@"result:%@ error :%@", aResult, aError);
        wSelf.loginStatus = CSLoginStatusSuccess;
        if (aError.code == 0 || [[self.ywIMKit.IMCore getLoginService] isCurrentLogined]) {
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        } else {
            wSelf.loginStatus = CSLoginStatusFail;
            NSLog(@"登录失败 :%@", aError);
            if (aFailedBlock) {
                aFailedBlock(aError);
            }
        }
    }];
*/
}

- (void)logout{
    /*
    self.loginStatus = CSLoginStatusLogout;
    self.password = nil;
    self.userId = nil;
    [[self.ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
    }];
     */
}

- (BOOL)isLogin{
    return self.loginStatus == CSLoginStatusSuccess;
}

- (void)openCustomerServicePageFromViewController:(UIViewController *)viewController{
    /*
    __weak typeof(self) wSelf = self;
    fromViewController = viewController;
    [self loginSuccessBlock:^{
        [fromViewController hideGif];

        YWConversationViewController *conversationController=[wSelf.ywIMKit makeConversationViewControllerWithConversationId:wSelf.conversation.conversationId];
        conversationController.disableTitleOnlineDisplay = YES;
        __weak typeof(conversationController) wVC = conversationController;
        [conversationController setViewDidLoadBlock:^{
            if (@available(iOS 11.0, *)) {
                wVC.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }];
        
        [conversationController setViewWillAppearBlock:^(BOOL aAnimated) {
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
            
        }];
        [conversationController setViewDidDisappearBlock:^(BOOL aAnimated) {
            [IQKeyboardManager sharedManager].enable = YES;
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;

        }];
     
        [conversationController setViewControllerWillDeallocBlock:^{
            NSLog(@"客服界面销毁");
        }];
        
        if (viewController.navigationController) {
            [viewController.navigationController pushViewController:conversationController animated:YES];
        }else{
            [viewController presentViewController:conversationController animated:YES completion:nil];
        }
    } failedBlock:^(NSError *err) {
        [fromViewController hideGif];
        [viewController LPShowAletWithTitle:@"客服小妹开小差了，请稍后再试!" Content:@"" left:@"取消" right:@"确定" rightClick:^{}];
    }];
     */
}

/*
- (YWPerson *)person{
    if (!_person) {
        _person = [[YWPerson alloc]initWithPersonId:kCustomerID EServiceGroupId:nil baseContext:self.ywIMKit.IMCore];
    }
    return _person;
}

- (YWConversation *)conversation{
    if (!_conversation) {
        _conversation = [YWP2PConversation fetchConversationByPerson:self.person creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
    }
    return _conversation;
}

- (void)loginSuccessBlock:(void(^)(void))aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock{
    
    if (!self.ywIMKit) {
        [self config];
    }
    if (!self.ywSuccess) {
        if (aFailedBlock) {
            NSError *err = [NSError errorWithDomain:@"云旺初始化出错！" code:5003 userInfo:nil];
            aFailedBlock(err);
        }
    }
    
    NSString *userID = @"";
    if ([FyUserCenter sharedInstance].isLogin) {
        userID = [FyUserCenter sharedInstance].userId;
    }
    
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    if ([self isLogin]) {
        if (aSuccessBlock) {
            aSuccessBlock();

        }
    }else if(self.userId == nil || self.password == nil){
        [fromViewController showGif];

        [task cancel];
        
        FyGetYWAccountRequest *t = [[FyGetYWAccountRequest alloc] init];
        t.userId = userID;
        
        task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, NSDictionary * model) {
            if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
            {
                NSString *user_id = model[@"userid"];
                NSString *user_pwd = model[@"password"];
                
                [self loginWithUserID:user_id password:user_pwd successBlock:aSuccessBlock failedBlock:aFailedBlock];
            }else
            {
                if (aFailedBlock) {
                    NSError *err = [NSError errorWithDomain:@"请求云旺账户、密码出错！" code:5002 userInfo:nil];
                    aFailedBlock(err);
                }
            }

        } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
            if (aFailedBlock) {
                NSError *err = [NSError errorWithDomain:error.errorMessage code:error.errorCode userInfo:nil];
                aFailedBlock(err);
            }
        }];
        
    }else{
        [fromViewController showGif];

        [self loginWithUserID:self.userId password:self.password successBlock:aSuccessBlock failedBlock:aFailedBlock];
    }

}
*/
/* 上线下线
- (void)help1{
    YWPerson *person=[[YWPerson alloc]initWithPersonId:@"富卡1" EServiceGroupId:nil baseContext:self.ywIMKit.IMCore];
    YWConversation *conversation=[YWP2PConversation fetchConversationByPerson:person creatIfNotExist:YES baseContext:self.ywIMKit.IMCore];
    self.conversation = conversation;
    
    [[self.ywIMKit.IMCore getContactService] addPersonOnlineStatusChanged:@[person] withBlock:^BOOL(YWPerson *person, BOOL onlineStatus) {
        NSLog(@"%@", onlineStatus ? @"上线" : @"下线");
        return YES;
    } forKey:@"key" ofPriority:YWBlockPriorityDeveloper];
    
}
*/

@end
