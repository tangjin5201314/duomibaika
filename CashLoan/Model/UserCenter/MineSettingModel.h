//
//  MineSettingModel.h
//  CashLoan
//
//  Created by 李帅良 on 2017/2/25.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineSettingModel : NSObject

/**
 是否可修改
 */
@property(nonatomic,assign) BOOL changeable;
/**
 是否可以忘记密码操作
 */
@property(nonatomic,assign) BOOL forgetable;
/**
 是否可设置
 */
@property(nonatomic,assign) BOOL setable;
@end
