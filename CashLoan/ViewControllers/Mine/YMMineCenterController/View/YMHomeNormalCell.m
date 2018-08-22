//
//  YMHomeNormalCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeNormalCell.h"

@implementation YMHomeNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayContent:(NSDictionary *)dic {
    
    self.titleLab.text = dic[@"title"];
    self.icon.image = [UIImage imageNamed:dic[@"img"]];
}

@end
