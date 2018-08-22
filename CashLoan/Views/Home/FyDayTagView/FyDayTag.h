//
//  FyDayTag.h
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyDayTag : NSObject

@property (copy, nonatomic, nullable) NSString *text;
@property (strong, nonatomic, nullable) UIColor *textColorDefault;
@property (strong, nonatomic, nullable) UIColor *textColorSelectStart;
@property (strong, nonatomic, nullable) UIColor *textColorSelectEnd;

@property (strong, nonatomic, nullable) UIImage *bgImgDefault;
@property (strong, nonatomic, nullable) UIImage *bgImgSelected;

@property (assign, nonatomic) UIEdgeInsets padding;
@property (strong, nonatomic, nullable) UIFont *font;
///default:YES
@property (assign, nonatomic) BOOL enable;

- (nonnull instancetype)initWithText: (nonnull NSString *)text;
+ (nonnull instancetype)tagWithText: (nonnull NSString *)text;


@end
