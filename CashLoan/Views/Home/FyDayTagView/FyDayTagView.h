//
//  FyDayTagView.h
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyDayTagView : UIScrollView

@property (nonatomic, copy) NSArray *dayStrArray;
@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (nonatomic, copy) NSString *selectedValue;


@property (nonatomic, copy) void (^selectIndexBlock)(NSInteger index);
- (void)scrollToVisible;

@end
