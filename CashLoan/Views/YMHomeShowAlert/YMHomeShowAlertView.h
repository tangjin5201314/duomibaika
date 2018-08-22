//
//  YMHomeShowAlertView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FyFindIndexModelV2.h"

@interface YMHomeShowAlertView : UIView
@property (strong, nonatomic) UIView *blackView;

@property (copy, nonatomic) void(^registerBlock)();

@property (copy, nonatomic) void(^loginBlock)();

@property (copy, nonatomic) void(^closeBlock)();

- (void)closeView;

+ (instancetype)showNoviceAlertViewWithModel:(FyFindIndexModelV2 *)model
                                        RegisterBtnBlock:(void (^)())registerBtnBlock
                                         loginBlock:(void (^)(UIButton *))loginBlock
                                         closeBlock:(void (^)())closeBlock;
@end
