//
//  FyLoanDetailTextTreeCell.m
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanDetailTextTreeCell.h"

@interface FyLoanDetailTextTreeCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *arrowBtn;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, strong) UIButton *helpBtn;

@end


@implementation FyLoanDetailTextTreeCell

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
    [self.bgView addSubview:self.topBtn];

    [self.bgView addSubview:self.fyTextLabel];
    [self.bgView addSubview:self.fySubTextLabel];
    [self.bgView addSubview:self.arrowBtn];
    [self.bgView addSubview:self.helpBtn];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
    }];
    
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
    }];

    
    [self.fyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@15);
    }];
    
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fyTextLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(@0);
        make.width.height.mas_equalTo(@22);
    }];
    

    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@-15);
        make.centerY.mas_equalTo(@0);
        make.width.height.mas_equalTo(@22);
    }];
    
    [self.fySubTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left).mas_offset(5);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
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

- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(handleOpenAciton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}

- (UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowBtn.userInteractionEnabled = NO;
        _arrowBtn.hidden = YES;
        _arrowBtn.contentMode = UIViewContentModeRight;
        [_arrowBtn setImage:[UIImage imageNamed:@"btn_open"] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateSelected];
    }
    return _arrowBtn;
}

- (UIButton *)helpBtn{
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _helpBtn.hidden = YES;
        [_helpBtn setImage:[UIImage imageNamed:@"jk_btn_details"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(handleHelpAciton) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _helpBtn;

}

- (void)handleOpenAciton{
    self.open = !self.arrowBtn.selected;
}

- (void)handleHelpAciton{
    if (self.helpBlock) {
        self.helpBlock();
    }
}

- (void)setOpen:(BOOL)open{
    _open = open;
    self.arrowBtn.selected = open;
    if (self.openBlock) {
        self.openBlock(self.open);
    }
}

- (void)setHelpBlock:(HelpBlock)helpBlock{
    if (_helpBlock != helpBlock) {
        _helpBlock = helpBlock;
        
        self.helpBtn.hidden = _helpBlock == nil;
    }
}

- (void)setOpenBlock:(OpenBlock)openBlock{
    if (_openBlock != openBlock) {
        _openBlock = openBlock;
        
        self.arrowBtn.hidden = _openBlock == nil;
    }
}

@end
