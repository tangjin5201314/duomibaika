//
//  UIViewController+fyHUD.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


typedef void(^rightBlock)(void);
typedef void(^leftBlock)(void);
typedef void(^okBlock)(void);
typedef void(^toPushPactBlock)(void);

@interface UIViewController (fyHUD)

@property (nonatomic, strong) MBProgressHUD *HUD;

- (void)fy_toastMessages:(NSString *)message hidenDelay:(CGFloat)delay;
- (void)fy_toastMessages:(NSString *)message;

- (void)showGifMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName;
- (void)showGif;
- (void)hideGif;

- (void)LPShowAletWithContent:(NSString *)content;
- (void)LPShowAletWithContent:(NSString *)content okClick:(okBlock)okblock;
- (void)LPShowAletWithContent:(NSString *)content dismissText:(NSString *)text;
- (void)LPShowAletWithContent:(NSString *)content dismissText:(NSString *)text okClick:(okBlock)okBlock;


- (void)LPShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText rightClick:(rightBlock)block;
- (void)LPShowAletWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText rightClick:(rightBlock)block;

- (void)LPShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction ;
- (void)LPShowAletWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction ;
- (void)fyShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction ;

//显示租赁合同
- (void)YMLeasePactAlertWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction;
@end
