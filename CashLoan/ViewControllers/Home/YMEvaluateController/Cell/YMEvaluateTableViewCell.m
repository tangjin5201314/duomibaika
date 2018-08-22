//
//  YMEvaluateTableViewCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMEvaluateTableViewCell.h"
@interface YMEvaluateTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation YMEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)displayWithDic:(NSDictionary *)dic content:(NSString *)content {
    self.icon.image = [UIImage imageNamed:dic[@"icon"]];
    self.title.text = dic[@"title"];
    self.content.text = content;
}

@end
