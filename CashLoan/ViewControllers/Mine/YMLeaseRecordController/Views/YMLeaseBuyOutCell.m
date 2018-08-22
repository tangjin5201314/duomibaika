


//
//  YMLeaseBuyOutCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseBuyOutCell.h"
@interface YMLeaseBuyOutCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation YMLeaseBuyOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayWithTitle:(NSString *)title type:(NSString *)tpye content:(NSString *)content {
    self.title.text = title;
    self.type.text = tpye;
    self.content.text = content;
}

@end
