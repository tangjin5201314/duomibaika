//
//  MGBankCardModel.h
//  MGBankCard
//
//  Created by 张英堂 on 16/2/25.
//  Copyright © 2016年 megvii. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGBankCardResult;

@interface MGBankCardModel : NSObject
@property (nonatomic, strong) UIImage *bankCardBoxImage;//全景图
@property (nonatomic, strong) UIImage *bankCardImage;//卡号截图

@property (nonatomic, copy) NSString *bankCardNumber;

@property (nonatomic, assign) CGFloat bankCardconfidence;

//lilianpengtianjia

@property (nonatomic, copy) NSString *bankNameString;//银行名称
@property (nonatomic, copy) NSString *bankTypeString;//银行卡类型

//
- (instancetype)initWithBankCardResult:(MGBankCardResult *)result;




@end
