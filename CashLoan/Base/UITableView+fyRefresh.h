//
//  UITableView+fyRefresh.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FyDataLoadCompleteStatus)
{
    kDataLoadCompleteStatusFailed = -1,
    kDataLoadCompleteStatusNoMoreData = 0,
    kDataLoadCompleteStatusDefault,
    kDataLoadCompleteStatusCancelled,
};

@interface UITableView (fyRefresh)

@property (nonatomic, assign) NSInteger pageIndex;

- (void)setupMessage:(NSString *)message imageName:(NSString *)imageName;
- (void)addMJ_HeaderWithTarget:(id)target selector:(SEL)selector;
- (void)addMJ_FooterWithTarget:(id)target selector:(SEL)selector;

-(void)loadServerDataComplete:(FyDataLoadCompleteStatus) status;


@end
