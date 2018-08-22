//
//  FyUserInfoV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyBankCardModelV2.h"

@interface FyUserInfoV2 : NSObject

@property (nonatomic, strong) FyBankCardModelV2 *bank;

@property (nonatomic , copy) NSString  *custom;
@property (nonatomic , copy) NSString  *infoDesc;
@property (nonatomic , assign) BOOL    bankCardState;
@property (nonatomic , assign) BOOL  idState;
@property (nonatomic , copy) NSString  *infoTitle;
@property (nonatomic , copy) NSString  *infoSlogan;
@property (nonatomic , copy) NSString  *aboutUS;
@property (nonatomic , copy) NSString  *helpCenter;
@end

