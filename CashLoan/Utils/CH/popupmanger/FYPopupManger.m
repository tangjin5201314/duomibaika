//
//  FYPopupManger.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "FYPopupManger.h"
#import "FyAnnouncementListModel.h"
#import "FyPopupView.h"
#import "UIView+fyNib.h"
#import "DataBaseManager.h"
#import "UIViewController+topPrensentViewController.h"
#import "FyAnnouncementDetailViewController.h"
#import <YYCategories/YYCategories.h>
#import "FyAnnouncementRequest.h"
#import "FyAnnouncementListModel.h"
#import "LPUpdateModel.h"
#import "FyCheckUpdateRequest.h"
#import "FyUpdateView.h"

@interface FYPopupManger(){
    NSURLSessionDataTask *gg_task; //公告
    NSURLSessionDataTask *gx_task; //更新
    NSURLSessionDataTask *hd_task; //活动
}

@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, assign) BOOL isShowing;

@end

@implementation FYPopupManger

+ (instancetype)sharedInstance{
    static FYPopupManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [@[] mutableCopy];
    }
    return self;
}

- (void)setAdReady:(BOOL)adReady{
    if (_adReady != adReady) {
        _adReady = adReady;
        [self showIfNeeded];
    }
}

- (void)setGuideReady:(BOOL)guideReady{
    if (_guideReady != guideReady) {
        _guideReady = guideReady;
        [self showIfNeeded];
    }
}

- (void)requestAnnouncements{
    [gg_task cancel];
    
    FyAnnouncementRequest *task = [[FyAnnouncementRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        FyAnnouncementListModel *list = [FyAnnouncementListModel mj_objectWithKeyValues:error.responseObject];
        if (list.resultData.count) {
            for (NSInteger i = list.resultData.count-1; i >= 0; i--) {
                [self.queue addObject:list.resultData[i]];
            }
            [self showIfNeeded];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
    }];
    
}

- (void)requestCheckUpdate{
    FyCheckUpdateRequest *task = [[FyCheckUpdateRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id m) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            LPUpdateModel *model = [LPUpdateModel mj_objectWithKeyValues:error.responseObject];
            if (model) {
                [self.queue addObject:model];
                [self showIfNeeded];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firstAct"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
    }];
    
}

- (void)showIfNeeded{
    if (self.adReady && self.guideReady && !self.isShowing && self.queue.count) {
        [self showModelInfNeeded:self.queue[0]];
    }
}

- (void) showModelInfNeeded:(id)model{
    if ([model isKindOfClass:[FyAnnouncementModel class]]) {
        [self showAnnouncementIfNeeded:model];
    }else if([model isKindOfClass:[LPUpdateModel class]]){
        [self showUpdateIfNeeded:model];
    }
}

- (void)showUpdateIfNeeded:(LPUpdateModel *)model{
    if (self.isShowing) return;
    DetailData *subModel = [self updateInfoWithModel:model];
    
    if (subModel) {
        self.isShowing = YES;
        FyUpdateView *view = [FyUpdateView loadNib];
        view.subTitleLabel.text = subModel.updatemsg;
        view.updateBlock =  ^{
//            NSString *iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1267239603"];
            NSString *iTunesLink = subModel.updateUrl;

            NSURL *url = [NSURL URLWithString:iTunesLink];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        };

        [view show];

    }else{
        [self.queue removeObject:model];
        [self showIfNeeded];
    }
}

- (DetailData *)updateInfoWithModel:(LPUpdateModel *)model{
    NSString *appVersion = [[UIApplication sharedApplication] appVersion];
    for (DetailData *subModel in model.resultData) {
        if ([subModel.type isEqualToString:@"iOS"] && ![subModel.versioncode isEqualToString:appVersion] && [subModel.isforce isEqualToString:@"1"]) {
            return subModel;
        }
        
    }
    return nil;
}

- (void)showAnnouncementIfNeeded:(FyAnnouncementModel *)model{
    if (self.isShowing) return;
    if (![[DataBaseManager sharedInstance] isExistActivity:model]) {
        self.isShowing = YES;
        FyPopupView *view = [FyPopupView loadNib];
        view.titleLabel.text = model.title;
        view.subTitleLabel.text = model.content;
        view.closeBlock = ^{
            [[DataBaseManager sharedInstance] saveActivityInfo:model];
            [self.queue removeObject:model];
            self.isShowing = NO;
            [self showIfNeeded];
        };
        view.readDetailBlock = ^{
            [self.queue removeObject:model];
            [[DataBaseManager sharedInstance] saveActivityInfo:model];
            [self showDetailWithModel:model];
        };
        [view show];
    }else{
        [self.queue removeObject:model];
        [self showIfNeeded];
    }
}

- (void)showDetailWithModel:(FyAnnouncementModel *)model{
    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    
    FyAnnouncementDetailViewController *detailVC = [[FyAnnouncementDetailViewController alloc] init];
    detailVC.model = model;
    detailVC.closeBlock = ^{
        self.isShowing = NO;
        [self showIfNeeded];
    };
    FyBaseNavigationController *nav = [[FyBaseNavigationController alloc] initWithRootViewController:detailVC];
    
    [[rootVC fy_topPrensentViewController] presentViewController:nav animated:YES completion:nil];
}



@end
