//
//  FyApproveViewControllerDelegate.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FyApproveViewControllerDelegate <NSObject>

@property (assign, nonatomic) BOOL autoNext; //自动进入下一步
@property (copy, nonatomic) BOOL (^tipAction)(void);//点击返回提示事件

@end