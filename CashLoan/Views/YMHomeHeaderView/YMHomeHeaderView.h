//
//  YMHomeHeaderView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyHomeCardModel.h"

@interface YMHomeHeaderView : UIView
@property (nonatomic, copy) void (^applyBlock)(void);

- (void)setScrollLabTexts:(NSArray *)texts;
- (void)hiddenNoticeView:(BOOL)ret;
- (void)displayWithModel:(FyHomeCardModel *)model;
- (void)displayWithPrice:(CGFloat )price imgUrl:(NSString *)url;

@end
