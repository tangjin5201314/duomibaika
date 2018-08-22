//
//  FyGradientTextBtn.m
//  CashLoan
//
//  Created by fyhy on 2017/12/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyGradientTextBtn.h"
#import "THLabel.h"

@interface FyGradientTextBtn()

@property (nonatomic, strong) THLabel *grandientLabel;

@end

@implementation FyGradientTextBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (THLabel *)grandientLabel{
    if (!_grandientLabel) {
        _grandientLabel = [[THLabel alloc] init];
        _grandientLabel.font = [UIFont systemFontOfSize:15];
        _grandientLabel.textAlignment = NSTextAlignmentCenter;
        _grandientLabel.gradientEndColor = [UIColor textGradientEndColor];
        _grandientLabel.gradientStartColor = [UIColor textGradientStartColor];

        [self addSubview:_grandientLabel];
        
        [_grandientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _grandientLabel;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (state == UIControlStateNormal) {
        self.grandientLabel.text = title;
        [super setTitle:@"" forState:state];

    }else{
        [super setTitle:title forState:state];
    }
}

- (void)setEnabled:(BOOL)enabled{
    self.grandientLabel.hidden = !enabled;
    [super setEnabled:enabled];
}

- (void)setHighlighted:(BOOL)highlighted{
    self.grandientLabel.alpha = highlighted ? 0.3 : 1;
    [super setHighlighted:highlighted];
}

@end
