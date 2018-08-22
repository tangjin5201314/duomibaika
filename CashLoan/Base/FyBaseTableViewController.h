//
//  FyBaseTableViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+fyRefresh.h"

@interface FyBaseTableViewController : FyBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIdex;
@property (nonatomic, assign) NSInteger pageStep;


- (UIEdgeInsets)fy_tableViewEdgeInsets; //tableView的四个边距
- (UITableViewStyle)fy_tableViewStyle;
- (BOOL)fy_allowPullUp; //允许上提加载
- (BOOL)fy_allowPullDown; //允许下拉刷新
- (NSString *)fy_noMoreTitle;

- (CGFloat) fy_refreshHeader_start_y;
- (BOOL)fy_showEmptyImage; //无数据是提示
- (NSString *)fy_emptyImageName;
- (NSString *)fy_emptyTitle;

- (void)fy_loadServerDataCompleteStatus:(FyDataLoadCompleteStatus) status; //加载数据结束后需要调用此方法
- (void)fy_loadServerData;

- (void)fy_headerBeginRefreshing;
- (void)fy_headerEndRefreshing; //结束下拉刷新状态
- (void)fy_footerBeginRefreshing;
- (void)fy_footerEndRefreshing; //结束上提加载状态
- (void)fy_footerEndRefreshingWithNoMoreData; //结束上提加载状态， 无更多数据

- (void)fy_handlePullDownToLoadNew; //下拉刷新执行的方法
- (void)fy_handlePullUpToLoadMore; //上提加载执行的方法

- (BOOL)fy_hiddenFooterIfNoMoreData;
- (void)addColorBackgroundView;


@end
