//
//  FyAnnouncementModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>
//@protocol FyAnnouncementModel;

@interface FyAnnouncementModel : NSObject

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *stopTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger deviceType; //0全部  1 安卓 2ios
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *publisherName;


@end
