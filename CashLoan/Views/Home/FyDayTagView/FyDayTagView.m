//
//  FyDayTagView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyDayTagView.h"
#import "FyDayTagButton.h"
#import "FyProductV2.h"

@interface FyDayTagView(){
    CGRect _lastFrame;
}

@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation FyDayTagView

- (NSMutableArray *)tags{
    if (!_tags) {
        _tags = [@[] mutableCopy];
    }
    return _tags;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config{
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setDayStrArray:(NSArray *)dayStrArray{
    if (_dayStrArray != dayStrArray) {
        _dayStrArray = dayStrArray;
        
        [self layoutTags];
    }
}

- (void)layoutTags{
    [self.tags makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];
    
    CGFloat space = self.lineSpacing ? : 5;
    UIView *preView = nil;
    
    for (NSInteger i = 0; i < self.dayStrArray.count; i++) {
        FyPeriodModel * limitModel = self.dayStrArray[i];
        FyDayTag *tag = [self tagWithString:limitModel.name];
        FyDayTagButton *btn = [FyDayTagButton buttonWithTag:tag];
        [self addSubview:btn];
        [self.tags addObject:btn];
        btn.tag = 1000 + i;
        
        if (self.selectedValue && [limitModel.value isEqualToString:self.selectedValue]) {
            [self selectAction:btn];
        }
        
        [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (preView) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preView.mas_right).offset(space);
                make.bottom.equalTo(@(self.padding.bottom));
                make.top.equalTo(@(self.padding.top));
                make.width.greaterThanOrEqualTo(@50);
                if (i == self.dayStrArray.count - 1) {
                    make.right.equalTo(@(self.padding.right));
                }
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(self.padding.left));
                make.bottom.equalTo(@(self.padding.bottom));
                make.top.equalTo(@(self.padding.top));
                make.width.greaterThanOrEqualTo(@50);
                if (i == self.dayStrArray.count - 1) {
                    make.right.equalTo(@(self.padding.right));
                }
            }];
        }
        
        preView = btn;
    }
    
}

- (FyDayTag *)tagWithString:(NSString *)dayString{
    FyDayTag *tag = [FyDayTag tagWithText:dayString];
    tag.bgImgSelected = [UIImage imageNamed:@"jk_btn_biankuang"];
    tag.bgImgDefault = [UIImage imageNamed:@"jk_btn_biankuang_gray"];
    tag.textColorDefault = [UIColor grayColor];
    tag.font = [UIFont systemFontOfSize:15];
    return tag;
}

- (void)selectAction:(FyDayTagButton *)btn{
    if (!btn.selected) {
        btn.selected = YES;
        self.selectedValue = btn.fyTag.text;
        if (self.selectIndexBlock) {
            self.selectIndexBlock(btn.tag-1000);
        }
        for (FyDayTagButton *b in self.tags) {
            if (b != btn) {
                b.selected = NO;
            }
        }
    }
    
}

- (void)scrollToVisible{
    UIButton *selectedBtn = nil;
    for (UIButton *btn in self.tags) {
        if (btn.selected) {
            selectedBtn = btn;
            break;
        }
    }
    
    if (selectedBtn) {
        [self scrollRectToVisible:selectedBtn.frame animated:NO];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectEqualToRect(_lastFrame, self.frame)) {
        _lastFrame = self.frame;
        [self scrollToVisible];
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
