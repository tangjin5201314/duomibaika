//
//  FyBillDetailPopViewCell.m
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillDetailPopViewCell.h"

@implementation FyPopCellModel
@end

@interface FyBillDetailPopViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation FyBillDetailPopViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor weakTextColorV2];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.mas_equalTo(@25);
        }];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor subTextColorV2];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];

        [self addSubview:_subTitleLabel];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        }];

    }
    return _subTitleLabel;
}

- (void)setModel:(FyPopCellModel *)model{
    if(_model != model){
        _model = model;
        
        self.titleLabel.text = model.title;
        self.subTitleLabel.text = model.subTitle;
        
        [self invalidateIntrinsicContentSize];
    }
}

-(CGSize)intrinsicContentSize {
    CGSize label1 = self.titleLabel.intrinsicContentSize;
    CGSize label2 = self.subTitleLabel.intrinsicContentSize;

    return CGSizeMake(MAX(label1.width, label2.width), label1.height+label2.height + 5);
    
}
@end
