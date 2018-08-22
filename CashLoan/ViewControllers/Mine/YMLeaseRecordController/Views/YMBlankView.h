//
//  YMBlankView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/25.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBlankView : UIView
@property (nonatomic, copy) void (^refreshBlock)(void);

@end
