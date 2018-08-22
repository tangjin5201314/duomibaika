//
//  YMGuideShowAlertView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/3/1.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMGuideShowAlertView : UIView
@property (strong, nonatomic) UIView *blackView;
@property (strong, nonatomic) NSArray *dataArr;
@property (assign, nonatomic) NSInteger index;

@property (copy, nonatomic) void(^registerBlock)();

@property (copy, nonatomic) void(^loginBlock)();

@property (copy, nonatomic) void(^closeBlock)();

+ (instancetype)showGuideAlertViewWithModel:(NSArray *)arr
                                 closeBlock:(void (^)())closeBlock;
@end
