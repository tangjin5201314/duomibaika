//
//  StaticTableViewController.h
//  StaticTableViewController 2.0
//
//  Created by Peter Paulis on 31.1.2013.
//  Copyright (c) 2013 Peter Paulis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticDataTableViewController : UITableViewController
//bool隐藏分组
@property (nonatomic, assign) BOOL hideSectionsWithHiddenRows;
//bool动画分组头
@property (nonatomic, assign) BOOL animateSectionHeaders;
//插入动画
@property (nonatomic, assign) UITableViewRowAnimation insertTableViewRowAnimation;
//删除动画
@property (nonatomic, assign) UITableViewRowAnimation deleteTableViewRowAnimation;
//刷新动画
@property (nonatomic, assign) UITableViewRowAnimation reloadTableViewRowAnimation;

//bool cell是隐藏的
- (BOOL)cellIsHidden:(UITableViewCell *)cell;
//刷新cell
- (void)updateCell:(UITableViewCell *)cell;
//刷新一组cells
- (void)updateCells:(NSArray *)cells;
//cell隐藏
- (void)cell:(UITableViewCell *)cell setHidden:(BOOL)hidden;
//一组cell隐藏
- (void)cells:(NSArray *)cells setHidden:(BOOL)hidden;
//cell设置高度
- (void)cell:(UITableViewCell *)cell setHeight:(CGFloat)height;
//设置一组cell的高度
- (void)cells:(NSArray *)cells setHeight:(CGFloat)height;

// never call [self.tableView reloadData] directly
// doing so will lead to data inconsistenci
// always use this method for reload
//reload data 永远不要使用[self.tableView reloadData];
- (void)reloadDataAnimated:(BOOL)animated;

@end
