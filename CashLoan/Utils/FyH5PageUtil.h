//
//  FyH5PageUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyLoanLogModel.h"
#import "H5PageModel.h"

typedef enum : NSUInteger {
    FyH5PageTypeHelp = 0,
    FyH5PageTypeAboutUs,
    FyH5PageTypeLoanProtocol,
    FyH5PageTypeLoanEGProtocol,
    FyH5PageTypeBindCard,
    FyH5PageTypeBankRemark,
    FyH5PageTypeBorrowRaiders,


} FyH5PageType;

@interface FyH5PageUtil : NSObject

+ (void)call;
+ (NSString *)phoneNumber;
+ (NSString *)urlPathWithLink:(NSString *)link;

+ (NSString *)urlPathWithType:(FyH5PageType)type;
+ (NSString *)loanProcotolWithState:(LoanState)state borrowID:(NSString *)borrowID;
+(void)requestDataWithType:(FyH5PageType)type result:(void (^)(H5PageModel *model,FyResponse *response))resultBlock;
+ (NSString *)loanProcotolWithBorrowH5Link:(NSString *)h5Link;

@end
