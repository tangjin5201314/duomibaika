//
//  RoundButton.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundButton : UIButton

@property (nonatomic, assign) UIRectCorner corners;
@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, strong) UIColor * backgroundColor;


@end
