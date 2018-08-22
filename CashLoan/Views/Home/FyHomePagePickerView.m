//
//  FyHomePagePickerView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomePagePickerView.h"
#import <Masonry/Masonry.h>
#import "FyHomePagePickerViewCell.h"
#import "UIColor+fyTheme.h"

#define bgTagBegain 100
#define tableviewTagBegin 10000
#define labelTagBegin 100000
#define KfontName @"DINPro-Regular"

@interface FyHomePagePickerView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *selectValues;
@end

@implementation FyHomePagePickerView

static NSString *const reuseIdentifier = @"cell";
static NSString *const reuseIdentifier_textleft = @"reuseIdentifier_textleft";


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    [self removeAllObservers];
}

- (NSMutableDictionary *)selectValues{
    if (!_selectValues) {
        _selectValues = [@{} mutableCopy];
    }
    return _selectValues;
}

- (void)setDataSource:(id<FYHomePagePickerDataSource>)dataSource{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self.selectValues removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self reLayoutSubViews];
        });
    }
}

- (void)reLayoutSubViews{
    NSAssert(_dataSource, @"dataSource can not be nil");
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self layoutBgViews];
    [self layoutBGViewSubviews];
}

- (void)layoutBgViews{
    NSInteger componentCount = [_dataSource fyNumberOfComponent];
    
    UIView *preView = nil;

    for (NSInteger i = 0; i < componentCount; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        bgView.tag = bgTagBegain + i;
        
        CGFloat widthRatio = 1.0/componentCount;
        if ([_dataSource respondsToSelector:@selector(widthForComponent:)]) {
            widthRatio = [_dataSource widthForComponent:i];
        }
        
        [self addSubview:bgView];
        if (preView) {
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preView.mas_right);
                make.bottom.equalTo(self.mas_bottom);
                make.top.equalTo(self.mas_top);
                make.width.equalTo(self.mas_width).multipliedBy(widthRatio);
            }];
        }else{
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.bottom.equalTo(self.mas_bottom);
                make.top.equalTo(self.mas_top);
                make.width.equalTo(self.mas_width).multipliedBy(widthRatio);
            }];
        }
        preView = bgView;

    }
}

- (void)layoutBGViewSubviews{
    NSInteger componentCount = [_dataSource fyNumberOfComponent];
    
    for (NSInteger i = 0; i < componentCount; i++) {
        [self layoutSubviewsForBGView:[self viewWithTag:bgTagBegain + i]];
    }
}

- (void)layoutSubviewsForBGView:(UIView *)bgView{
    NSInteger component = bgView.tag - bgTagBegain; //当前是第几个component
    UIView *preView = nil;

    //添加tableview
    for (int i = 0; i < 7; i ++) {
        CGFloat h = 60;
        if (abs(i - 3) == 1) {
            h = 55;
        }else if (abs(i - 3) == 2){
            h = 45;
        }else if (abs(i - 3) == 3){
            h = 35;
        }
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.pagingEnabled = YES;
        tableView.tag = i + tableviewTagBegin;
        [bgView addSubview:tableView];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.tintColor = [UIColor clearColor];

            tableView.contentInset = UIEdgeInsetsZero;

//        });

        [tableView registerNib:[UINib nibWithNibName:@"FyHomePagePickerViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"FyHomePagePickerViewCell_left" bundle:nil] forCellReuseIdentifier:reuseIdentifier_textleft];

        tableView.userInteractionEnabled = abs(i - 3) == 0; //只有中间的接受用户事件
        
        if (abs(i - 3) == 0) {
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        }
        
        if (preView) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left);
                make.right.equalTo(bgView.mas_right);
                make.top.equalTo(preView.mas_bottom);
                make.height.equalTo(self.mas_height).multipliedBy(h/330);
            }];
        }else{
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bgView.mas_left);
                make.right.equalTo(bgView.mas_right);
                make.top.equalTo(bgView.mas_top);
                make.height.equalTo(self.mas_height).multipliedBy(h/330);
            }];
        }
        preView = tableView;

    }
    
    //label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:titleLabel];
    
    if ([_dataSource respondsToSelector:@selector(textAlignmentInComponent:)] && [_dataSource textAlignmentInComponent:component] == NSTextAlignmentLeft) {
        
        UILabel *tempLabel = [[UILabel alloc] init];
        tempLabel.font = [UIFont fontWithName:KfontName size:50];
        tempLabel.textColor = [UIColor clearColor];
        [bgView addSubview:tempLabel];
        tempLabel.text = [_dataSource withFitTitleInComponent:component];
        
        [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.left);
            make.top.mas_equalTo(bgView.top);
            make.bottom.mas_equalTo(bgView.bottom);
            make.right.mas_equalTo(titleLabel.mas_left);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_greaterThanOrEqualTo(bgView.right);
            make.top.mas_equalTo(bgView.top);
            make.bottom.mas_equalTo(bgView.bottom);
            make.width.mas_greaterThanOrEqualTo(15);
        }];
        


    }else{
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];

    }
    titleLabel.text = [_dataSource titleInComponent:component];

    
}

- (void)removeAllObservers{
    NSInteger componentCount = [_dataSource fyNumberOfComponent];
    for (NSInteger i = 0; i < componentCount; i++) {
        UIView *bgView = (id)[self viewWithTag:bgTagBegain + i];
        UITableView *tableView = (id)[bgView viewWithTag:tableviewTagBegin + 3];
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger component = tableView.superview.tag - bgTagBegain; //当前是第几个component
    return [_dataSource fyPickerView:self numberOfRowInComponent:component];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger component = tableView.superview.tag - bgTagBegain; //当前是第几个component
    
    NSString *reuseIndent = reuseIdentifier;
    if ([_dataSource respondsToSelector:@selector(textAlignmentInComponent:)] && [_dataSource textAlignmentInComponent:component] == NSTextAlignmentLeft) {
        reuseIndent = reuseIdentifier_textleft;
    }
    
    FyHomePagePickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndent forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    cell.subTitleLabel.text = [_dataSource titleInComponent:component];
    cell.widthLabel.text = [_dataSource withFitTitleInComponent:component];
    
    cell.titleLabel.text = [_dataSource fyPickerView:self titleForRow:indexPath.row forComponent:component];

    NSInteger index = tableView.tag - tableviewTagBegin;
    NSInteger tmpIndex = abs((int)index - 3);
    
    UIColor *textColor = [UIColor whiteFontColor];
    UIFont *textFont = [UIFont fontWithName:KfontName size:50];
    CGFloat alpha = 1;

    if (tmpIndex == 1) {
        alpha = 0.9;
    }else if (tmpIndex == 2) {
        alpha = 0.7;
    }else if (tmpIndex == 3){
        alpha = 0.3;
    }
    
    if (tmpIndex > 0) {
        textColor = [UIColor yellowColor];
        textFont = [UIFont fontWithName:KfontName size:24];
    }
    
    cell.titleLabel.textColor = textColor;
    cell.titleLabel.font = textFont;
    cell.titleLabel.alpha = alpha;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(tableView.frame);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *v = [super hitTest:point withEvent:event];
    
    NSInteger componentCount = [_dataSource fyNumberOfComponent];

    if (v.tag >= bgTagBegain && v.tag < bgTagBegain + componentCount) {
        return [v viewWithTag:tableviewTagBegin + 3];
    }
    
    return v;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UITableView *tableView = object;
    NSInteger component = tableView.superview.tag - bgTagBegain; //当前是第几个component

    CGFloat offSetY = tableView.contentOffset.y;
    CGFloat scaleOffset = offSetY/CGRectGetHeight(tableView.frame);
    
    [self updateContentOffsetWithScale:scaleOffset component:component];
}

- (void)updateContentOffsetWithScale:(CGFloat)scale component:(NSInteger)component{
    
    UIView *bgView = [self viewWithTag:bgTagBegain + component];
    
    for (NSInteger i = 0; i < 7; i ++) {
        UITableView *tableView = [bgView viewWithTag:tableviewTagBegin + i];
        if (tableView.tag != tableviewTagBegin + 3) {
            NSInteger index = i - 3;
            CGFloat h = CGRectGetHeight(tableView.frame);
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView.contentOffset = CGPointMake(0, h * scale + index * h);
            });
        }

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag != tableviewTagBegin + 3) return;
    CGFloat offSetY = scrollView.contentOffset.y;
    NSInteger index = offSetY/CGRectGetHeight(scrollView.frame)+0.5;
    
    if (_delegate && [_delegate respondsToSelector:@selector(fyPickerView:didSelectRow:forComponent:)]) {
        [_delegate fyPickerView:self didSelectRow:index forComponent:scrollView.superview.tag - bgTagBegain];
    }
}


- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animate{
    UIView *bgView = [self viewWithTag:bgTagBegain + component];
    UITableView *tableView = [bgView viewWithTag:tableviewTagBegin + 3];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView setContentOffset:CGPointMake(0, row * CGRectGetHeight(tableView.frame)) animated:animate];
    });
    
    if (_delegate && [_delegate respondsToSelector:@selector(fyPickerView:didSelectRow:forComponent:)]) {
        [_delegate fyPickerView:self didSelectRow:row forComponent:component];
    }

}

- (void)selectValue:(NSString *)value inComponent:(NSInteger)component animated:(BOOL)animate{
    NSInteger index = [self indexForValue:value inComponent:component];
    
    [self selectRow:index inComponent:component animated:animate];
}

- (NSInteger)indexForValue:(NSString *)value inComponent:(NSInteger)component{
    NSInteger rowCount = [_dataSource fyPickerView:self numberOfRowInComponent:component];
    
    [self.selectValues setObject:value ? : @"" forKey:[NSString stringWithFormat:@"%ld", (long)component]];
    
    for (NSInteger i = 0; i < rowCount; i ++) {
        NSString *str = [_dataSource fyPickerView:self titleForRow:i forComponent:component];
        if ([str isEqualToString:value]) {
            return i;
        }
    }
    return 0;
}

- (void)reloadData{
    NSInteger componentCount = [_dataSource fyNumberOfComponent];
    
    for (NSInteger i = 0; i < componentCount; i++) {
        UIView *bgView = [self viewWithTag:bgTagBegain + i];
        
        for (UITableView *tableView in bgView.subviews) {
            if ([tableView isKindOfClass:[UITableView class]]) {
                [tableView reloadData];
            }
        }
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger componentCount = [_dataSource fyNumberOfComponent];

    for (NSInteger i = 0; i < componentCount; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        NSString *value = [self.selectValues objectForKey:[NSString stringWithFormat:@"%ld", (long)i]];
            
        [self selectValue:value inComponent:i animated:YES];
        
        
//        NSInteger index = [self indexForValue:value inComponent:i];
//        [self updateContentOffsetWithScale:index component:i];
//        [UIView setAnimationsEnabled:YES];

        });
    }
}


@end
