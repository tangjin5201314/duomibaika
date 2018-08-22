//
//  AuthDictService.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthDictListModel.h"

/**
 数据字典类型
 
 - AuthDictTypeContacts: 联系人关系
 - AuthDictTypeEducational: 学历
 - AuthDictTypeLiveTime: 居住时长
 - AuthDictTypeBankList: 银行列表
 - AuthDictTypeWorkTime: 工作时长
 */
typedef NS_ENUM(NSInteger,AuthDictType){
    AuthDictTypeContacts = 0,
    AuthDictTypeEducational = 1,
    AuthDictTypeLiveTime = 2,
    AuthDictTypeBankList = 3,
    AuthDictTypeWorkTime = 4,
    AuthDictTypePersonInfo = 5,
    AuthDictTypeWorkInfo = 6,
    AuthDictTypeTrueName = 7,
    AuthDictTypeLoanUsage = 8
};

@interface AuthDictService : NSObject
/**
 请求字典
 
 @param type 数据字典类型
 @param result 回调
 */
+(void)requestDictWithType:(AuthDictType)type resultModel:(void (^)(AuthDictListModel *model,FyResponse *error))result;
@end

