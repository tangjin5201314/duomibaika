//
//  FyHomeLoanHeaderView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeLoanHeaderView.h"
#import "NSString+FormatNumber.h"

@interface FyHomeLoanHeaderView()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *brandLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *memory;

@end

@implementation FyHomeLoanHeaderView
//            _loanHeaderView = [FyHomeLoanHeaderView loadNib];

- (void)setCardModel:(FyHomeCardModel *)cardModel{
    if (_cardModel != cardModel) {
        _cardModel = cardModel;
        self.brandLab.text = cardModel.brand;
        self.typeLab.text = cardModel.type;
        self.memory.text = cardModel.memory;
        self.valueLabel.text = [NSString stringNumberFormatterWithDouble:2000];
    }
}

- (void)setMaxLoan:(NSString *)maxLoan{
    if (_maxLoan != maxLoan) {
        _maxLoan = maxLoan;
        
        self.valueLabel.text = [NSString stringNumberFormatterWithDouble:2000];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.backgroundColor = [UIColor fyThemeColor];
    self.noticeBar.scrollSpace = 5;
    self.noticeBar.font = [UIFont systemFontOfSize:14];
    self.noticeBar.backgroundColor = [UIColor clearColor];
    self.noticeBar.scrollType = TXScrollLabelViewTypeFlipNoRepeat;
    self.noticeBar.textAlignment = NSTextAlignmentLeft;
    self.noticeBar.scrollVelocity = 3;

}

- (IBAction)apply:(id)sender{
    if (self.applyBlock) {
        self.applyBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
