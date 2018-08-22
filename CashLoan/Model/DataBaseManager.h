//
//  DataBaseManager.h
//  Crowdfunding
//
//  Created by aaaa on 16/6/13.
//  Copyright © 2016年 erongdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyUserCenter.h"
#import "FyAnnouncementModel.h"
#import <FMDB/FMDB.h>

@interface DataBaseManager : NSObject

/**
 *  单例
 *
 *  @return 对象
 */
+ (instancetype) sharedInstance;
/**
 *  创建默认数据库
 */
- (void)createDefaultDataBase;
/**
 *  创建数据库
 *
 *  @param dataBaseName 数据库名字
 *
 *  @return 返回数据库对象
 */
- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName;


- (BOOL)savetUserInfo:(FyUserCenter *)userInfo;

- (void)updateUserInfo:(FyUserCenter *)userInfo gesturePWD:(NSString *)gesturePwd;

- (void)updateUserInfo:(FyUserCenter *)userInfo openTouchID:(BOOL)open;

- (BOOL)checkUserInfo:(FyUserCenter *)userInfo gesturePWD:(NSString *)gesturePwd;

- (BOOL)userIsOpenTouchID:(FyUserCenter *)userInfo;

- (void)loadUser:(FyUserCenter *)userInfo;

- (BOOL)userLogOut:(FyUserCenter *)userInfo;

- (NSString *)getGesturePWD:(FyUserCenter *)userInfo;

- (BOOL)saveActivityInfo:(FyAnnouncementModel *)model;
- (BOOL)isExistActivity:(FyAnnouncementModel *)model;
@end
