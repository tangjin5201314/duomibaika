//
//  RDPickerView.m
//  Pods
//
//  Created by Mr_zhaohy on 2016/11/24.
//
//

#import "RDPickerView.h"
#import <Masonry/Masonry.h>

#define PickerView_height 170
#define Button_height 40

@interface RDPickerView ()
{
    //点击手势
    UITapGestureRecognizer *_tapGes;
    UIView *_btnView;
    UIButton *_cancelBtn;
    UIButton *_sureBtn;
    UIView *_bgView;
}
@end

@implementation RDPickerView
-(instancetype)initWithView:(UIView *)view{
    self = [super init];
    [self initSubviews];
    //添加手势
    [self addGesture];
    //初始化并隐藏
    self.hidden = YES;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return self;
}
-(void)addGesture{
    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundView)];
    [self addGestureRecognizer:_tapGes];
}
-(void)initSubviews{
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(PickerView_height+Button_height);
        //自身高度+按钮高度
        make.bottom.mas_equalTo(PickerView_height+Button_height);
    }];
    
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    [_bgView addSubview:_pickerView];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(PickerView_height);
        //自身高度+按钮高度
        make.bottom.mas_equalTo(0);
    }];
    
    _btnView = [[UIView alloc]init];
    _btnView.backgroundColor = [UIColor viewBackgroundColor];
    [_btnView removeGestureRecognizer:_tapGes];
    [_bgView addSubview:_btnView];
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_pickerView.mas_top).offset(0);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(Button_height);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor buttonBackgroundColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.and.bottom.equalTo(_btnView);
        make.width.mas_equalTo(50);
    }];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor buttonBackgroundColor] forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_btnView.mas_right).with.offset(-25);
        make.top.and.bottom.equalTo(_btnView);
        make.width.mas_equalTo(50);
    }];
}
-(void)showWithAnimation:(BOOL)animation{
    self.hidden = NO;
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:animation == YES ? 0.37 : 0 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];

    }];
}
-(void)dissmissWithAnimation:(BOOL)animation{
    [self dissmissWithIndex:0 animation:animation];
}
-(void)tapBackgroundView{
    [self dissmissWithIndex:0 animation:YES];
}
-(void)clickBtn:(UIButton *)btn{
    //取消的index为0
    [self dissmissWithIndex:btn == _cancelBtn ? 0 : 1 animation:YES];
}
-(void)dissmissWithIndex:(NSInteger)index animation:(BOOL)animation{
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        //自身高度+按钮高度
        make.bottom.mas_equalTo(PickerView_height+Button_height);
    }];
    
    if(animation)
    {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    
    [UIView animateWithDuration:animation == YES ? 0.37 : 0 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:dissmissWithButtonIndex:)])
    {
        [self.delegate pickerView:self dissmissWithButtonIndex:index];
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
