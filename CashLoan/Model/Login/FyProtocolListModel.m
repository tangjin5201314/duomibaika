//
//  FyProtocolListModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyProtocolListModel.h"

@implementation FyProtocolListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [H5PageModel class]};
}

//
- (H5PageModel *)registerProtocolModel{ //用户注册协议
    return [self protocolModelWithString:@"protocol_vestone_register_login"];
}

- (H5PageModel *)rulesProtocolModel{ //使用规则
    return [self protocolModelWithString:@"protocol_vestone_register_data_collection_service"];
}
//

- (H5PageModel *)protocolModelWithString:(NSString *)procotolString{
    for (H5PageModel *p in self.list) {
        if ([p.code isEqualToString:procotolString]) {
            return p;
        }
    }
    return nil;
}


@end
