//
//  FYCardBin.m
//  CashLoan
//
//  Created by 陈浩 on 2017/9/25.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "FYCardBin.h"

#import <MJExtension/MJExtension.h>
#import "FyCardBinRequest.h"
#import "NSString+fyAdd.h"

@implementation FYCardBinModel
@end

@interface FYCardBin (){
    NSURLSessionDataTask *task;
}



@end

@implementation FYCardBin

- (void)setCardNo:(NSString *)cardNo{
     cardNo = [cardNo numberString];

    if (![cardNo isEqualToString:_cardNo]) {
        self.carBinModel = nil;
        _cardNo = cardNo;
        [self loadCardName];
    }
}

- (instancetype)initWithSuccessBlock:(void (^)(FYCardBinModel *cardModel))success{
    self = [super init];
    if (self) {
        self.loadCardNameBlock = success;
    }
    return self;
}

- (void)cancel{
    [task cancel];
}

- (void)loadCardName{
    [self loadCardNameSuccessBlock:nil];
}

- (void)loadCardNameIfNeedSuccessBlock:(void (^)(FYCardBinModel *cardModel))success{
    if (self.carBinModel) {
        if (success) {
            success(self.carBinModel);
        }
    }else{
        [self loadCardNameSuccessBlock:success];
    }
}

- (void)loadCardNameSuccessBlock:(void (^)(FYCardBinModel *cardModel))success{
    [self cancel];
    if (self.cardNo.length == 0) {
        if (self.loadCardNameBlock) {
            self.loadCardNameBlock(nil);
        }
        if (success) {
            success(nil);
        }

        return;
    }
    __weak typeof(self) wSelf = self;
    
    FyCardBinRequest *t = [[FyCardBinRequest alloc] init];
    t.card = self.cardNo;
    
    task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        wSelf.carBinModel = model;
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            if (wSelf.loadCardNameBlock) {
                wSelf.loadCardNameBlock(model);
            }
            if (success) {
                success(model);
            }
        }else{
            if (wSelf.loadCardNameBlock) {
                wSelf.loadCardNameBlock(nil);
            }
            if (success) {
                success(nil);
            }
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (wSelf.loadCardNameBlock) {
            wSelf.loadCardNameBlock(nil);
        }
        if (success) {
            success(nil);
        }

    }];
    
}

@end
