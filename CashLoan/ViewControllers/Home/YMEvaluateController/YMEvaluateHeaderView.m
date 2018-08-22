//
//  YMEvaluateHeaderView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMEvaluateHeaderView.h"

@interface YMEvaluateHeaderView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIButton *resetBtn;

@end


@implementation YMEvaluateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return  self;
}

- (void)setupUI {

    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.userInteractionEnabled = YES;
    self.bgImageView.image = [UIImage imageNamed:@"ym_zzpj"];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-2);
        make.width.mas_equalTo(SCREEN_WIDTH + 5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.textColor = [UIColor whiteColor];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resetBtn setTitle:@"重新评估" forState:UIControlStateNormal];
    [self.resetBtn addTarget:self action:@selector(resetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.resetBtn.layer.cornerRadius = 5;
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLab.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
}

- (void)displayWithTitle:(NSString *)title price:(CGFloat)price {
    self.titleLab.text = [NSString stringWithFormat:@"您的手机%@估价",title];
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",price];
}
- (void)resetBtnAction {
    if (self.applyBlock) {
        self.applyBlock();
    }
}
@end
