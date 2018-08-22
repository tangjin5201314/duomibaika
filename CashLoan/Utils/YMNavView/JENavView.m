//
//  JENavView.m
//  JENavView
//
//  Created by cowinclub on 16/1/12.
//  Copyright © 2016年 Jero. All rights reserved.
//

#import "JENavView.h"
#define NormColor_LineGray        [UIColor fy_colorWithHexString:@"#ededed"] // 灰色

@implementation JENavView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    if (self) {
        
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:self.frame];
        self.bgImg = bgImg;
        [self addSubview:bgImg];
        
        UIButton *btn_left = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 120, 44)];
        [btn_left setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [btn_left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_left setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn_left addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
        [btn_left.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn_left.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn_left setHidden:YES];
        self.btn_left = btn_left;
        [self addSubview:btn_left];
        
        UIButton *btn_right = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 20, 120, 44)];
        [btn_right setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [btn_right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_right setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn_right addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
        [btn_right.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btn_right.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [btn_right setHidden:YES];
        self.btn_right = btn_right;
        [self addSubview:btn_right];
        
        UILabel *lbl_title = [[UILabel alloc ]initWithFrame:CGRectMake(40, 20, self.frame.size.width - 80, 44)];
        [lbl_title setTextAlignment:NSTextAlignmentCenter];
        lbl_title.lineBreakMode = NSLineBreakByTruncatingMiddle;
        lbl_title.numberOfLines = 2;
        lbl_title.adjustsFontSizeToFitWidth = YES;
        lbl_title.font = [UIFont systemFontOfSize:17];
        [lbl_title setTextColor:[UIColor blackColor]];
        self.lbl_title = lbl_title;
        [self addSubview:lbl_title];
        
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
//        line.backgroundColor = NormColor_LineGray;
//        self.line = line;
//        [self addSubview:line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setNavTitle:(NSString *)title{
    self.lbl_title.text = title;
}
/**
 *  设置导航栏左按钮
 */
- (void)setNavLeftItemImage:(UIImage *)image title:(NSString *)title{
    [self.btn_left setHidden:NO];
    [self.btn_left setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btn_left setImage:image forState:UIControlStateNormal];
    [self.btn_left setTitle:title forState:UIControlStateNormal];
    [self.btn_left setContentEdgeInsets:UIEdgeInsetsMake(3, image.size.width + 12, 0, 0)];
}
/**
 *  设置导航栏右按钮
 */
- (void)setNavRightItemImage:(UIImage *)image title:(NSString *)title{
    [self.btn_right setHidden:NO];
    [self.btn_right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    if (image) {
        [self.btn_right setImage:image forState:UIControlStateNormal];
    }
    [self.btn_right setTitle:title forState:UIControlStateNormal];
    [self.btn_right setContentEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 15)];
}
/**
 *  左按钮回调
 */
- (void)leftItemAction{
    if (self.blkTouchLeftItem) {
        self.blkTouchLeftItem();
    }
}
/**
 *  右按钮回调
 */
- (void)rightItemAction{
    if (self.blkTouchRightItem) {
        self.blkTouchRightItem();
    }
}
@end
