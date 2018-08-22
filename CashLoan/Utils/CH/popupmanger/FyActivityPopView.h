//
//  FyActivityPopView.h
//  CashLoan
//
//  Created by fyhy on 2017/12/14.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyActivityPopView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, copy) void (^readDetailBlock)(void);
@property (nonatomic, copy) void (^closeBlock)(void);


- (void)show;


@end
