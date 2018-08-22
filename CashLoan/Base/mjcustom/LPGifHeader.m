//
//  LPGifHeader.m
//  CashLoan
//
//  Created by lilianpeng on 2017/7/26.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "LPGifHeader.h"
#import <YYCategories/YYCategories.h>
@implementation LPGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 36; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"LPLoadGifWhiteBG%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i< 36; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"LPLoadGifWhiteBG%zd", i]];
        [refreshingImages addObject:image];
    }
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];

    
    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.textColor = [UIColor subTextColor];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop + self.fy_start_y;
    
}


@end
