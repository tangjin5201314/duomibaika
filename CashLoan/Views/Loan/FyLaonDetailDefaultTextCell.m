//
//  FyLaonDetailDefaultTextCell.m
//  CashLoan
//
//  Created by fyhy on 2017/12/4.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLaonDetailDefaultTextCell.h"

@interface FyLaonDetailDefaultTextCell()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation FyLaonDetailDefaultTextCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configSubViews{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.fyTextLabel];
    [self.bgView addSubview:self.fySubTextLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@-15);
    }];
    
    [self.fyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
    }];
    
    [self.fySubTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (UILabel *)fyTextLabel{
    if (!_fyTextLabel) {
        _fyTextLabel = [[UILabel alloc] init];
        _fyTextLabel.font = [UIFont systemFontOfSize:15];
        _fyTextLabel.textColor = [UIColor textColor];
    }
    return _fyTextLabel;
}

- (UILabel *)fySubTextLabel{
    if (!_fySubTextLabel) {
        _fySubTextLabel = [[UILabel alloc] init];
        _fySubTextLabel.font = [UIFont systemFontOfSize:15];
        _fySubTextLabel.textAlignment = NSTextAlignmentRight;
        _fySubTextLabel.textColor = [UIColor textColor];
    }
    return _fySubTextLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


@end
