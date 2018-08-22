//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) void (^allPasswordPut)(NSString *password);
@property (nonatomic, copy) void (^textChange)();

/**
 *  清除密码
 */
- (void)clearUpPassword;
- (void)makeLineRed:(BOOL)red;

@end
