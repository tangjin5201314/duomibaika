//
//  UITableView+fyRefresh.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UITableView+fyRefresh.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>
#import "GzwTableViewLoading.h"

static char kPageIndex;

@implementation UITableView (fyRefresh)

- (void)setupMessage:(NSString *)message imageName:(NSString *)imageName{
    self.loadedImageName = imageName;
    self.gzw_contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineSpacing = 15;
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                  NSForegroundColorAttributeName: [UIColor weakTextColor],
                                  NSParagraphStyleAttributeName: paragraph};
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:message attributes:attributes1];
    
    NSMutableAttributedString *descriptionAttributedText = [[NSMutableAttributedString alloc] init];
    [descriptionAttributedText appendAttributedString:str1];
    self.descriptionAttributedText = descriptionAttributedText;
    
}

- (void)addMJ_HeaderWithTarget:(id)target selector:(SEL)selector{
    __weak typeof(target) wTarget = target;
    __weak typeof(self) wSelf = self;
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([wTarget respondsToSelector:selector]) {
            wSelf.pageIndex = 1;
            wSelf.loading = YES;
            
            [wTarget performSelector:selector withObject:nil afterDelay:0];
        }
    }];
    
}

- (void)addMJ_FooterWithTarget:(id)target selector:(SEL)selector{
    __weak typeof(target) wTarget = target;
    __weak typeof(self) wSelf = self;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([wTarget respondsToSelector:selector]) {
            wSelf.pageIndex++;
            wSelf.loading = YES;
            
            [wTarget performSelector:selector withObject:nil afterDelay:0];
        }
    }];
}

- (void)setPageIndex:(NSInteger)pageIndex{
    objc_setAssociatedObject(self, &kPageIndex, @(pageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageIndex{
    return [objc_getAssociatedObject(self, &kPageIndex) integerValue];
}

-(void)loadServerDataComplete:(FyDataLoadCompleteStatus) status{
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        if (status == kDataLoadCompleteStatusNoMoreData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.mj_footer endRefreshing];
        }
    }else{
        if (status == kDataLoadCompleteStatusNoMoreData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self reloadData];
    
    if (status == kDataLoadCompleteStatusFailed) {
        [self loadServerDataNetworkFaild];
    }
    
    if (status == kDataLoadCompleteStatusCancelled) {
        [self loadServerDataNetworkCancelled];
    }
    
    self.loading = NO;
}

- (void)loadServerDataNetworkFaild{
    self.pageIndex -= 1;
}

- (void)loadServerDataNetworkCancelled{
    self.pageIndex -= 1;
}


@end
