//
//  FyDayTagButton.m
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyDayTagButton.h"
#import "THLabel.h"

@interface FyDayTagButton()

@property (nonatomic, strong) THLabel *grandientLabel;

@end

@implementation FyDayTagButton

+ (instancetype)buttonWithTag: (FyDayTag *)tag {
    FyDayTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
    btn.fyTag = tag;
    
    [btn setTitle: tag.text forState:UIControlStateNormal];
    btn.grandientLabel.text = tag.text;
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    if (tag.textColorDefault)
        btn.grandientLabel.textColor = tag.textColorDefault;
    
    if (tag.font)
        btn.grandientLabel.font = tag.font;
    
    if (tag.bgImgSelected)
        [btn setBackgroundImage:tag.bgImgSelected forState:UIControlStateSelected];

    if (tag.bgImgDefault)
        [btn setBackgroundImage:tag.bgImgDefault forState:UIControlStateNormal];
    
    btn.contentEdgeInsets = tag.padding;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    btn.userInteractionEnabled = tag.enable;
        
    return btn;
}

- (THLabel *)grandientLabel{
    if (!_grandientLabel) {
        _grandientLabel = [[THLabel alloc] init];
        _grandientLabel.font = [UIFont systemFontOfSize:15];
        _grandientLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_grandientLabel];
        
        [_grandientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _grandientLabel;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.grandientLabel.gradientStartColor = selected ? [UIColor textGradientStartColor] : nil;
    self.grandientLabel.gradientEndColor = selected ? [UIColor textGradientEndColor] : nil;
}

@end
