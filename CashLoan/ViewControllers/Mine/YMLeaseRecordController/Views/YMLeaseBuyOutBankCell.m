//
//  YMLeaseBuyOutBankCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseBuyOutBankCell.h"
@interface YMLeaseBuyOutBankCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end
@implementation YMLeaseBuyOutBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayWithTitle:(NSString *)title content:(NSString *)content img:(NSString *)url {
    self.title.text = title;
    self.content.text = content;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end
