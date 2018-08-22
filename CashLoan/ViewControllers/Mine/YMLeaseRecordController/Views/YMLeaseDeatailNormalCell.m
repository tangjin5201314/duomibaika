//
//  YMLeaseDeatailNormalCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseDeatailNormalCell.h"
@interface YMLeaseDeatailNormalCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation YMLeaseDeatailNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayWithTitle:(NSString *)title content:(NSString *)content{
    self.title.text = CHECKNULL(title);
    self.content.text = CHECKNULL(content);
}

- (void)displayWithTitle:(NSString *)title {
    self.title.text = title;
    self.content.text = @"";
}

@end
