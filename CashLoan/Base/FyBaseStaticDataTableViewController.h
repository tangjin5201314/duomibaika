//
//  FyBaseStaticDataTableViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "StaticDataTableViewController.h"
#import "UITableView+fyRefresh.h"

@interface FyBaseStaticDataTableViewController : StaticDataTableViewController

- (BOOL)fy_allowPullDown; //允许下拉刷新


- (void)fy_loadServerDataCompleteStatus:(FyDataLoadCompleteStatus) status; //加载数据结束后需要调用此方法
- (void)fy_loadServerData;

- (void)fy_headerBeginRefreshing;
- (void)fy_headerEndRefreshing; //结束下拉刷新状态

- (void)fy_handlePullDownToLoadNew; //下拉刷新执行的方法

- (void)addColorBackgroundView;

@end
