//
//  FyProtocolListModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "H5PageModel.h"

@interface FyProtocolListModel : NSObject

@property(nonatomic, copy) NSArray *list;

- (H5PageModel *)registerProtocolModel; //用户注册协议
- (H5PageModel *)rulesProtocolModel; //使用规则

@end
