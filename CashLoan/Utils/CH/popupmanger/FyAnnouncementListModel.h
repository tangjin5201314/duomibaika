//
//  FyAnnouncementListModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyAnnouncementModel.h"

@protocol FyAnnouncementModel;


@interface FyAnnouncementListModel : NSObject

@property (nonatomic, copy) NSArray *resultData;

@end
