//
//  DataBaseManager.m
//  Crowdfunding
//
//  Created by aaaa on 16/6/13.
//  Copyright © 2016年 erongdu. All rights reserved.
//

#import "DataBaseManager.h"

#define DefaultBaseName @"appData.sqlite"
//银行卡省市区
#define CreateAreaTable @"CREATE TABLE IF NOT EXISTS REGION(id INTEGER PRIMARY KEY AUTOINCREMENT, PID INTEGER, NID INTEGER, NAME TEXT)"
#define GetRegionList   @"SELECT * FROM REGION"
#define SetRegion       @"INSERT INTO REGION(PID, NID, NAME) VALUES(%ld, %ld, '%@')"
#define DeleteRegionList @"DELETE FROM REGION"
#define UpdateRegion    @"UPDATE sqlite_sequence SET seq=0 WHERE name='REGION'"
#define GetRegionProvince @"SELECT T.* FROM REGION T WHERE T.PID = 0 ORDER BY T.PID ASC"
#define GetRegionCity @"SELECT T.* FROM REGION T, REGION B WHERE T.PID = B.NID AND B.PID = 0 ORDER BY T.PID ASC"
#define GetRegionArea @"SELECT T.* FROM REGION T, REGION B WHERE T.PID = B.NID AND B.PID != 0 ORDER BY T.PID ASC"

//地址省市区
#define CreateAddressAreaTable @"CREATE TABLE IF NOT EXISTS ADDRESSREGION(id INTEGER PRIMARY KEY AUTOINCREMENT, PID INTEGER, NID INTEGER, NAME TEXT)"
#define GetAddressRegionList   @"SELECT * FROM ADDRESSREGION"
#define SetAddressRegion       @"INSERT INTO ADDRESSREGION(PID, NID, NAME) VALUES(%ld, %ld, '%@')"
#define DeleteAddressRegionList @"DELETE FROM ADDRESSREGION"
#define UpdateAddressRegion    @"UPDATE sqlite_sequence SET seq=0 WHERE name='ADDRESSREGION'"
#define GetAddressRegionProvince @"SELECT T.* FROM ADDRESSREGION T WHERE T.PID = 0 ORDER BY T.PID ASC"
#define GetAddressRegionCity @"SELECT T.* FROM ADDRESSREGION T, ADDRESSREGION B WHERE T.PID = B.NID AND B.PID = 0 ORDER BY T.PID ASC"
#define GetAddressRegionArea @"SELECT T.* FROM ADDRESSREGION T, ADDRESSREGION B WHERE T.PID = B.NID AND B.PID != 0 ORDER BY T.PID ASC"

//搜索记录表
#define CreateSearchHistory @"CREATE TABLE IF NOT EXISTS SEARCHHISTORY(id INTEGER PRIMARY KEY AUTOINCREMENT, KEYWORD TEXT UNIQUE, TYPE INTEGER NOT NULL DEFAULT 0, ADDTIME TIMESTAMP NOT NULL DEFAULT (DATETIME('NOW','LOCALTIME')))"
#define SetSearchHistory @"INSERT OR REPLACE INTO SEARCHHISTORY (KEYWORD,TYPE) VALUES('%@',%@)"
#define GetSearchHistory @"SELECT * FROM SEARCHHISTORY WHERE TYPE = %@ ORDER BY ADDTIME DESC"
#define DeleteSearchHistory @"DELETE FROM SEARCHHISTORY WHERE TYPE = %@"
#define UpdateSearchHistory @"UPDATE sqlite_sequence SET seq=0 WHERE name='SEARCHHISTORY'"

//筛选存储
#define CreateSearchCondition @"CREATE TABLE IF NOT EXISTS SEARCHCONDITION(id INTEGER PRIMARY KEY AUTOINCREMENT, KEY TEXT, VALUE TEXT NOT NULL, TYPE INTEGER NOT NULL)"
#define SetSearchCondition @"INSERT OR REPLACE INTO SEARCHCONDITION(KEY, VALUE, TYPE) VALUES('%@', '%@',%@)"
#define GetSearchCondition @"SELECT * FROM SEARCHCONDITION ORDER BY TYPE"
#define DeleteSearchCondition @"DELETE FROM SEARCHCONDITION"
#define UpdateSearchCondition @"UPDATE sqlite_sequence SET seq=0 WHERE name='SEARCHCONDITION'"

//创建公告、活动表 type 0表示公告 1表示活动
#define CreateActivity    @"CREATE TABLE IF NOT EXISTS ACTIVITY(id INTEGER PRIMARY KEY AUTOINCREMENT,AID TEXT, TITLE TEXT, CONTENT TEXT, URL TEXT,DEVICETYPE INTEGER, STATUS INTEGER, TYPE INTEGER)"
//是否存在公告、活动
#define ExistACTIVITY @"SELECT * FROM ACTIVITY WHERE AID = '%@' AND TYPE = %ld"

#define SaveACTIVITY @"INSERT INTO ACTIVITY(AID, TITLE, CONTENT,URL,DEVICETYPE,STATUS,TYPE) VALUES('%@', '%@', '%@', '%@',%ld, %ld, %ld)"


#define CreateUser    @"CREATE TABLE IF NOT EXISTS USER(id INTEGER PRIMARY KEY AUTOINCREMENT, PAYPWD TEXT, LOGINPWD TEXT,  REFRESHTOKEN TEXT, ACCESSTOKEN TEXT, USERID TEXT, USERNAME TEXT, GESTUREPWD TEXT, TOUCHID INTEGER DEFAULT 0)"
//当登录时，存储信息
#define SaveUser @"INSERT INTO USER(PAYPWD, LOGINPWD,REFRESHTOKEN,ACCESSTOKEN,USERID,USERNAME) VALUES('%@', '%@', '%@', '%@','%@', '%@')"
//更新
#define UpdateUser @"UPDATE USER SET PAYPWD = '%@', LOGINPWD = '%@', REFRESHTOKEN = '%@', ACCESSTOKEN = '%@',USERNAME = '%@' WHERE USERID = '%@'"
//是否存在该用户
#define ExistUser @"SELECT * FROM USER WHERE USERID = '%@'"
//更新手势密码
#define UpdateGuesturePWD  @"UPDATE USER SET GESTUREPWD = '%@' WHERE USERID = '%@'"
//判断手势密码是否正确
#define GetGuesturePWD @"SELECT GESTUREPWD FROM USER WHERE USERID = '%@'"
//更新指纹
#define UpdateTouchID  @"UPDATE USER SET TOUCHID = %@ WHERE USERID = '%@'"
//加载用户 当ACCESSTOKEN 不为空的时候
#define LoadUser @"SELECT PAYPWD, LOGINPWD,REFRESHTOKEN,ACCESSTOKEN,USERID,USERNAME FROM USER WHERE ACCESSTOKEN NOT NULL"
//判断当前用户是否开启指纹识别
#define IsOpenTouchID @"SELECT TOUCHID FROM USER WHERE USERID = '%@'"
//用户退出
#define UserLogOut @"UPDATE USER SET ACCESSTOKEN = NULL, REFRESHTOKEN = NULL WHERE USERID = '%@'"

////创建文件存放目录
//#define CreateFileDownload @"FILEDOWNLOAD "

@interface DataBaseManager ()

/**
 *  默认数据库
 */
@property (nonatomic, strong) FMDatabase *defaultDataBase;
@end
@implementation DataBaseManager

static  DataBaseManager *sharedInstance = nil;

/*
 获取全局的单例
 */
+ (instancetype) sharedInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[DataBaseManager alloc] init];
        [sharedInstance createDefaultDataBase];
    });
    return sharedInstance;
}
//打开的前提下
- (void)createInitTableByDatabase
{
    if ([_defaultDataBase open]) {
        //创建用户表
        if (![_defaultDataBase executeUpdate:CreateUser])
        {
            NSLog(@"创建用户表失败");
        }
        
        if (![_defaultDataBase executeUpdate:CreateActivity])
        {
            NSLog(@"创建公告、活动表失败");
        }

        //关闭
        [_defaultDataBase close];
    }
}
- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName
{
    //APP所在路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:dataBaseName];
    
    //没有则创建
    FMDatabase *dataBase=[FMDatabase databaseWithPath:dbFilePath];
    
    return dataBase;
}


- (void)createDefaultDataBase
{
    _defaultDataBase = [self createDataBaseName:DefaultBaseName];
    [self createInitTableByDatabase];
}

#pragma mark -存储活动、公告信息
- (BOOL)saveActivityInfo:(FyAnnouncementModel *)model
{
    BOOL status = NO;
    if([_defaultDataBase open])
    {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:ExistACTIVITY, model.aid, (long)0]];
        if (!result.next)
        {
            NSString *title = model.title ? : @"";
            NSString *content = model.content ? : @"";
            NSString *urlString = model.url ? : @"";

            
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:SaveACTIVITY,model.aid,title,content,urlString,(long)model.deviceType,model.status,(NSInteger)0]];
        }
        [_defaultDataBase close];
    }
    return status;
}

- (BOOL)isExistActivity:(FyAnnouncementModel *)model{
    BOOL status = NO;
    if([_defaultDataBase open])
    {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:ExistACTIVITY, model.aid, (long)0]];
        if (result.next)
        {
            status = YES;
        }
        [_defaultDataBase close];
    }
    return status;

}


#pragma mark -存储或更新用户信息
- (BOOL)savetUserInfo:(FyUserCenter *)userInfo {
//    //当登录时，存储信息
//#define SaveUser @"INSERT INTO USER(PAYPWD, LOGINPWD,REFRESHTOKEN,ACCESSTOKEN,USERID,USERNAME) VALUES('%@', '%@', '%@', '%@','%@', '%@')"
//    //更新
//#define UpdateUser @"UPDATE USER SET PAYPWD = '%@', LOGINPWD = '%@', REFRESHTOKEN = '%@', ACCESSTOKEN = '%@',USERNAME = '%@' WHERE USERID = '%@'"
//#define LoadUser @"SELECT PAYPWD, LOGINPWD,REFRESHTOKEN,ACCESSTOKEN,USERID,USERNAME FROM USER WHERE ACCESSTOKEN NOT NULL"

    BOOL status = NO;
    if([_defaultDataBase open])
    {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:ExistUser, userInfo.userId]];
        if (result.next) {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateUser,[NSString stringWithFormat:@"%d", userInfo.payPwd],[NSString stringWithFormat:@"%d", userInfo.loginPwd],userInfo.refreshToken,userInfo.accessToken,userInfo.userName,userInfo.userId]];
        }
        else
        {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:SaveUser,[NSString stringWithFormat:@"%d", userInfo.payPwd],[NSString stringWithFormat:@"%d", userInfo.loginPwd],userInfo.refreshToken,userInfo.accessToken,userInfo.userId,userInfo.userName]];
        }
        [_defaultDataBase close];
    }
    return status;
}

- (void)updateUserInfo:(FyUserCenter *)userInfo gesturePWD:(NSString *)gesturePwd {
    if ([_defaultDataBase open]) {
        if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateGuesturePWD, gesturePwd, userInfo.userId]]) {
        }
        [_defaultDataBase close];
    }
}

- (void)updateUserInfo:(FyUserCenter *)userInfo openTouchID:(BOOL)open {
    if ([_defaultDataBase open]) {
        if (![_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateTouchID, @(open), userInfo.userId]]) {
        }
        [_defaultDataBase close];
    }
}

- (NSString *)getGesturePWD:(FyUserCenter *)userInfo {
    NSString *temp = @"";
    if ([_defaultDataBase open]) {
        FMResultSet *result=[_defaultDataBase executeQuery:[NSString stringWithFormat:GetGuesturePWD, userInfo.userId]];
        if (result.next) {
            temp = [result stringForColumn:@"GESTUREPWD"];
        }
        [_defaultDataBase close];
    }
    return temp;
}

- (BOOL)checkUserInfo:(FyUserCenter *)userInfo gesturePWD:(NSString *)gesturePwd {
    return [gesturePwd isEqualToString:[self getGesturePWD:userInfo]];
}

- (BOOL)userIsOpenTouchID:(FyUserCenter *)userInfo {
    if ([_defaultDataBase open]) {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:IsOpenTouchID, userInfo.userId]];
        if (result.next) {
            return [result boolForColumn:@"TOUCHID"];
        }
    }
    return NO;
}

- (void)loadUser:(FyUserCenter *)userInfo {
    if ([_defaultDataBase open]) {
        FMResultSet *result=[_defaultDataBase executeQuery:LoadUser];
        if(result.next)
        {
            //#define LoadUser @"SELECT PAYPWD, LOGINPWD,REFRESHTOKEN,ACCESSTOKEN,USERID,USERNAME FROM USER WHERE ACCESSTOKEN NOT NULL"


            userInfo.payPwd = [[result stringForColumn:@"PAYPWD"] boolValue];
            userInfo.loginPwd = [[result stringForColumn:@"LOGINPWD"] boolValue];
            userInfo.userName = [result stringForColumn:@"USERNAME"];
            userInfo.accessToken = [result stringForColumn:@"ACCESSTOKEN"];
            userInfo.uId = [[result stringForColumn:@"USERID"] integerValue];
            userInfo.refreshToken = [result stringForColumn:@"REFRESHTOKEN"];
        }
    }
}

- (BOOL)userLogOut:(FyUserCenter *)userInfo
{
    BOOL status = NO;
    if([_defaultDataBase open])
    {
        status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UserLogOut, userInfo.userId]];
    }
    return status;
}


@end
