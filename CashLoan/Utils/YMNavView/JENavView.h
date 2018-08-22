//
//  JENavView.h
//  JENavView
//
//  Created by cowinclub on 16/1/12.
//  Copyright © 2016年 Jero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JENavView : UIView

@property (strong, nonatomic) UIImageView *bgImg;
@property (strong, nonatomic) UILabel *lbl_title;
@property (strong, nonatomic) UIButton *btn_left;
@property (strong, nonatomic) UIButton *btn_right;
@property (strong, nonatomic) UILabel *line;

@property (copy, nonatomic) void(^blkTouchLeftItem)();
@property (copy, nonatomic) void(^blkTouchRightItem)();

- (void)setNavTitle:(NSString *)title;
- (void)setNavLeftItemImage:(UIImage *)image title:(NSString *)title;
- (void)setNavRightItemImage:(UIImage *)image title:(NSString *)title;

@end