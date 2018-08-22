//
//  FyBillDetailPopView.m
//  CashLoan
//
//  Created by Fuyin on 2017/11/30.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillDetailPopView.h"

@interface FyBillDetailPopView ()

@property (nonatomic, strong) UIImageView *popIconView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *tags;

@end

@implementation FyBillDetailPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModels:(NSArray<FyPopCellModel *> *)models{
    if(_models != models){
        _models = models;
        
        [self layoutTags];
    }
}

- (void)layoutTags{
    [self.tags makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tags removeAllObjects];
    
    CGFloat space = 30;
    UIView *preView = nil;
    
    for (NSInteger i = 0; i < self.models.count; i++) {
        FyBillDetailPopViewCell *cell = [[FyBillDetailPopViewCell alloc] init];
        cell.model = self.models[i];
        [self.scrollView addSubview:cell];
        [self.tags addObject:cell];
        
        CGSize size = cell.intrinsicContentSize;
        if (preView) {
            cell.frame = CGRectMake(CGRectGetMaxX(preView.frame)+space, 0, size.width, size.height);
        }else{
            cell.frame = CGRectMake(15, 0, size.width, size.height);
        }
        
        preView = cell;
    }

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSMutableArray *)tags{
    if(!_tags){
        _tags = [@[] mutableCopy];
    }
    return _tags;
}

- (UIImageView *)popIconView{
    if(!_popIconView){
        _popIconView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"zd_xqbg_qipao"];
        _popIconView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 22) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_popIconView];
    }
    return _popIconView;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = 0, h = 0;
    for (UIView *view in self.tags) {
        w += view.intrinsicContentSize.width;
        h = view.intrinsicContentSize.height;
    }
    w += 30 * self.tags.count;
    
    self.scrollView.contentSize = CGSizeMake(w, h);
    
    w = MIN(CGRectGetWidth(self.frame), w);
    self.scrollView.frame = CGRectMake(0, 20, w, CGRectGetHeight(self.frame)-20);
    self.popIconView.frame = CGRectMake(0, 0, w, CGRectGetHeight(self.frame));
    
    [self sendSubviewToBack:self.popIconView];
}

@end
