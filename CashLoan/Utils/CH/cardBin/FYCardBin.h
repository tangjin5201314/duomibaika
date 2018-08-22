//
//  FYCardBin.h
//  CashLoan
//
//  Created by 陈浩 on 2017/9/25.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYCardBinModel : NSObject

@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *greyImgUrl;

@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, assign) BOOL isSupport;

@end


@interface FYCardBin : NSObject

@property (nonatomic, copy) NSString *cardNo;
@property (nonatomic, strong) FYCardBinModel *carBinModel;
@property (nonatomic, copy) void (^loadCardNameBlock)(FYCardBinModel *cardModel);

- (instancetype)initWithSuccessBlock:(void (^)(FYCardBinModel *cardModel))success;


- (void)cancel;
- (void)loadCardName;
- (void)loadCardNameSuccessBlock:(void (^)(FYCardBinModel *cardModel))success;
- (void)loadCardNameIfNeedSuccessBlock:(void (^)(FYCardBinModel *cardModel))success;


@end
