//
//  StaticTableViewController.m
//  StaticTableViewController 2.0
//
//  Created by Peter Paulis on 31.1.2013.
//  Copyright (c) 2013 Peter Paulis. All rights reserved.
//

#import "StaticDataTableViewController.h"
#define kBatchOperationNone     0//一组操作
#define kBatchOperationInsert   1//一组插入操作
#define kBatchOperationDelete   2//一组删除操作
#define kBatchOperationUpdate   3//一组更新操作

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark OriginalRow
#pragma mark -
////////////////////////////////////////////////////////////////////////
//原型row
@interface OriginalRow : NSObject
//隐藏
@property (nonatomic, assign) BOOL hidden;
//
@property (nonatomic, assign) BOOL hiddenReal;

@property (nonatomic, assign) BOOL hiddenPlanned;
//一组操作
@property (nonatomic, assign) int batchOperation;
//cell
@property (nonatomic, weak) UITableViewCell * cell;
//原型indexPath
@property (nonatomic, strong) NSIndexPath * originalIndexPath;
//高度
@property (nonatomic, assign) CGFloat height;
//更新
- (void)update;

@end

@implementation OriginalRow
//初始化
- (id)init {
    self = [super init];
    
    if (self) {
        self.height = CGFLOAT_MAX;
    }
    
    return self;
}

- (BOOL)hidden {
    return (self.hiddenPlanned || self.hiddenPlanned);
}

- (void)setHidden:(BOOL)hidden {
    
    if ((!self.hiddenReal) && (hidden)) {
        self.batchOperation = kBatchOperationDelete;
    } else if ((self.hiddenReal) && (!hidden)) {
        self.batchOperation = kBatchOperationInsert;
    }
    
    self.hiddenPlanned = hidden;
}

- (void)update {
    
    if (!self.hidden) {
        if (self.batchOperation == kBatchOperationNone) {
            self.batchOperation = kBatchOperationUpdate;
        }
    }
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark OriginalSection
#pragma mark -
////////////////////////////////////////////////////////////////////////
//原型分组
@interface OriginalSection : NSObject
//label控件
@property (nonatomic, strong) NSString * label;
//rows 数组
@property (nonatomic, strong) NSMutableArray * rows;

@end

@implementation OriginalSection
//可见rows
- (NSInteger)numberOfVissibleRows {
    NSInteger count = 0;
    for (OriginalRow * or in self.rows) {
        if (!or.hidden) {
            ++count;
        }
    }
    
    return count;
}
//每个可见row的索引 参数是cell
- (NSInteger)vissibleRowIndexWithTableViewCell:(UITableViewCell *)cell {
    
    NSInteger i = 0;
    for (OriginalRow * or in self.rows) {
        
        if (or.cell == cell) {
            return i;
        }
        
        if (!or.hidden) {
            ++i;
        }
    }
    
    return -1;
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark OriginalTable
#pragma mark -
////////////////////////////////////////////////////////////////////////
//原型表格
@interface OriginalTable : NSObject
//分组 数组格式
@property (nonatomic, strong) NSMutableArray * sections;
//tableView
@property (nonatomic, weak) UITableView * tableView;
//插入的indexPaths 数组格式
@property (nonatomic, strong) NSMutableArray * insertIndexPaths;
//删除的indexPath 数组各式
@property (nonatomic, strong) NSMutableArray * deleteIndexPaths;
//更新的indexPaths 数组格式
@property (nonatomic, strong) NSMutableArray * updateIndexPaths;

@end

@implementation OriginalTable
//初始化
- (id)initWithTableView:(UITableView *)tableView {
    
    self = [super init];
    if (self) {
        
        NSInteger numberOfSections = [tableView numberOfSections];
        self.sections = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
        
        NSInteger totalNumberOfRows = 0;
        for (NSInteger i = 0; i < numberOfSections; ++i) {
            OriginalSection * originalSection = [OriginalSection new];
            
            NSInteger numberOfRows = [tableView numberOfRowsInSection:i];
            totalNumberOfRows += numberOfRows;
            originalSection.rows = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
            for (NSInteger ii = 0; ii < numberOfRows; ++ii) {
                OriginalRow * tableViewRow = [OriginalRow new];
                
                NSIndexPath * ip = [NSIndexPath indexPathForRow:ii inSection:i];
                tableViewRow.cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:ip];
                
                NSAssert(tableViewRow.cell != nil, @"cannot be nil");
                
                tableViewRow.originalIndexPath = [NSIndexPath indexPathForRow:ii inSection:i];
                
                originalSection.rows[ii] = tableViewRow;
            }
            
            self.sections[i] = originalSection;
        }
     
        self.insertIndexPaths = [[NSMutableArray alloc] initWithCapacity:totalNumberOfRows];
        self.deleteIndexPaths = [[NSMutableArray alloc] initWithCapacity:totalNumberOfRows];
        self.updateIndexPaths = [[NSMutableArray alloc] initWithCapacity:totalNumberOfRows];
        
        self.tableView = tableView;
        
    }
    
    return self;
}
//原型row 参数indexpath
- (OriginalRow *)originalRowWithIndexPath:(NSIndexPath *)indexPath {
    
    OriginalSection * oSection = self.sections[indexPath.section];
    OriginalRow * oRow = oSection.rows[indexPath.row];
    
    return oRow;
}
//可见原型row 参数indexpath

- (OriginalRow *)vissibleOriginalRowWithIndexPath:(NSIndexPath *)indexPath {
    
    OriginalSection * oSection = self.sections[indexPath.section];
    NSInteger vissibleIndex = -1;
    for (int i = 0; i < [oSection.rows count]; ++i) {
        
        OriginalRow * oRow = [oSection.rows objectAtIndex:i];
        
        if (!oRow.hidden) {
            ++vissibleIndex;
        }
        
        if (indexPath.row == vissibleIndex) {
            return oRow;
        }
        
    }
    
    return nil;
}
//原型row 参数cell
- (OriginalRow *)originalRowWithTableViewCell:(UITableViewCell *)cell {
    
    for (NSInteger i = 0; i < [self.sections count]; ++i) {
    
        OriginalSection * os = self.sections[i];
    
        for (NSInteger ii = 0; ii < [os.rows count]; ++ii) {
            
            if ([os.rows[ii] cell] == cell) {
                return os.rows[ii];
            }
            
        }
        
    }
    
    return nil;
}
//indexPath 插入参数原型row

- (NSIndexPath *)indexPathForInsertingOriginalRow:(OriginalRow *)originalRow {
    
    OriginalSection * oSection = self.sections[originalRow.originalIndexPath.section];
    NSInteger vissibleIndex = -1;
    for (NSInteger i = 0; i < originalRow.originalIndexPath.row; ++i) {
        
        OriginalRow * oRow = [oSection.rows objectAtIndex:i];
        
        if (!oRow.hidden) {
            ++vissibleIndex;
        }
        
    }
    
    return [NSIndexPath indexPathForRow:vissibleIndex + 1 inSection:originalRow.originalIndexPath.section];
    
}
//indexPath 删除参数原型row

- (NSIndexPath *)indexPathForDeletingOriginalRow:(OriginalRow *)originalRow {
    
    OriginalSection * oSection = self.sections[originalRow.originalIndexPath.section];
    NSInteger vissibleIndex = -1;
    for (NSInteger i = 0; i < originalRow.originalIndexPath.row; ++i) {
        
        OriginalRow * oRow = [oSection.rows objectAtIndex:i];
        
        if (!oRow.hiddenReal) {
            ++vissibleIndex;
        }
        
    }
    
    return [NSIndexPath indexPathForRow:vissibleIndex + 1 inSection:originalRow.originalIndexPath.section];
    
}
//准备刷新
- (void)prepareUpdates {
    
    [self.insertIndexPaths removeAllObjects];
    [self.deleteIndexPaths removeAllObjects];
    [self.updateIndexPaths removeAllObjects];
    
    for (OriginalSection * os in self.sections) {
        
        for (OriginalRow * or in os.rows) {
        
            if (or.batchOperation == kBatchOperationDelete) {
                
                NSIndexPath * ip = [self indexPathForDeletingOriginalRow:or];
                [self.deleteIndexPaths addObject:ip];
                
            } else if (or.batchOperation == kBatchOperationInsert) {
            
                NSIndexPath * ip = [self indexPathForInsertingOriginalRow:or];
                [self.insertIndexPaths addObject:ip];
                
            } else if (or.batchOperation == kBatchOperationUpdate) {
                
                NSIndexPath * ip = [self indexPathForInsertingOriginalRow:or];
                [self.updateIndexPaths addObject:ip];
                
            }
            
        }
        
    }
    
    for (OriginalSection * os in self.sections) {
        
        for (OriginalRow * or in os.rows) {
            
            or.hiddenReal = or.hiddenPlanned;
            or.batchOperation = kBatchOperationNone;
            
        }
        
    }
    
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark StaticDataTableViewController
#pragma mark -
////////////////////////////////////////////////////////////////////////
//controller 主体
@interface StaticDataTableViewController ()
//原型table
@property (nonatomic, strong) OriginalTable * originalTable;

@end

@implementation StaticDataTableViewController
//初始化
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
        
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.insertTableViewRowAnimation = UITableViewRowAnimationRight;
    self.deleteTableViewRowAnimation = UITableViewRowAnimationLeft;
    self.reloadTableViewRowAnimation = UITableViewRowAnimationMiddle;
    
    self.originalTable = [[OriginalTable alloc] initWithTableView:self.tableView];
    
}

#pragma mark - Public

- (void)updateCell:(UITableViewCell *)cell {
    
    OriginalRow * row = [self.originalTable originalRowWithTableViewCell:cell];
    [row update];
    
}

- (void)updateCells:(NSArray *)cells {
    for (UITableViewCell * cell in cells) {
        [self updateCell:cell];
    }
}

- (void)cell:(UITableViewCell *)cell setHidden:(BOOL)hidden {
    
    OriginalRow * row = [self.originalTable originalRowWithTableViewCell:cell];
    [row setHidden:hidden];
    
}

- (void)cells:(NSArray *)cells setHidden:(BOOL)hidden {
    for (UITableViewCell * cell in cells) {
        [self cell:cell setHidden:hidden];
    }
}

- (void)cell:(UITableViewCell *)cell setHeight:(CGFloat)height {
    
    OriginalRow * row = [self.originalTable originalRowWithTableViewCell:cell];
    [row setHeight:height];
    
}

- (void)cells:(NSArray *)cells setHeight:(CGFloat)height {
    for (UITableViewCell * cell in cells) {
        [self cell:cell setHeight:height];
    }
}

- (BOOL)cellIsHidden:(UITableViewCell *)cell {
    return [[self.originalTable originalRowWithTableViewCell:cell] hidden];
}

- (void)reloadDataAnimated:(BOOL)animated {

    [self.originalTable prepareUpdates];
    
    if (!animated) {
    
        [self.tableView reloadData];
        
    } else {
        
        if (self.animateSectionHeaders) {
            for (NSIndexPath *indexPath in self.originalTable.deleteIndexPaths) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.layer.zPosition = -2;
                
                [self.tableView headerViewForSection:indexPath.section].layer.zPosition = -1;
            }
        }
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:self.originalTable.updateIndexPaths withRowAnimation:self.reloadTableViewRowAnimation];
        
        [self.tableView insertRowsAtIndexPaths:self.originalTable.insertIndexPaths withRowAnimation:self.insertTableViewRowAnimation];
        
        [self.tableView deleteRowsAtIndexPaths:self.originalTable.deleteIndexPaths withRowAnimation:self.deleteTableViewRowAnimation];
        
        [self.tableView endUpdates];
        
        if (!self.animateSectionHeaders) {
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.originalTable == nil) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return [self.originalTable.sections[section] numberOfVissibleRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.originalTable == nil) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    OriginalRow * or = [self.originalTable vissibleOriginalRowWithIndexPath:indexPath];
    
    NSAssert(or.cell != nil, @"CANNOT BE NULL");
    
    return or.cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.originalTable != nil) {
        OriginalRow * or = [self.originalTable vissibleOriginalRowWithIndexPath:indexPath];
        
        if (or.height != CGFLOAT_MAX) {
            return or.height;
        }
        
        indexPath = or.originalIndexPath;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = [super tableView:tableView heightForHeaderInSection:section];
    
    if (self.originalTable == nil) {
        return height;
    }
    
    if (!self.hideSectionsWithHiddenRows) {
        return height;
    }
    
    OriginalSection * os = self.originalTable.sections[section];
    if ([os numberOfVissibleRows] == 0) {
        return CGFLOAT_MIN;
    } else {
        return height;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    } else {
        return [super tableView:tableView titleForHeaderInSection:section];
    }
}

@end