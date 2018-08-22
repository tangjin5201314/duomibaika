//
//  FyBuyoutTipView.m
//  CashLoan
//
//  Created by lilianpeng on 2018/3/31.
//  Copyright © 2018年 多米. All rights reserved.
//

#import "FyBuyoutTipView.h"
#import "UILabel+Utils.h"
#import "UIView+Toast.h"

@interface FyBuyoutTipView ()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayCopyBtn;
@property (nonatomic, weak) UIView *markView;

@end

@implementation FyBuyoutTipView


- (IBAction)closeBtnClick:(id)sender {

    [self hidenCompletion:nil];
}

- (IBAction)wechatBtnClick:(id)sender {
    if (self.wechatBlock) {
        self.wechatBlock();
    }
//    [self hidenCompletion:nil];
}

- (IBAction)alipayBtnClick:(id)sender {
    if (self.alipayBlock) {
        self.alipayBlock();
    }
//    [self hidenCompletion:nil];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_contentLabel setText:@"因为您的银行卡支付渠道维护，为了避免逾期买断，烦请转账到以下支付宝账号或微信账号并附加注册手机号及订单号。" lineSpacing:10.0f];
}
- (UIView *)loadMarkView{
    UIView *markView = [[UIView alloc] init];
    markView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    markView.alpha = 0;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(maskViewClicked)];
//    [markView addGestureRecognizer:tap];
    return markView;
}
//- (void)maskViewClicked {
//    [self hidenCompletion:nil];
//}

- (void)show{
    UIView *view = [self loadMarkView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    self.markView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(window.mas_centerX);
        make.centerY.mas_equalTo(window.mas_centerY).offset(-32);
        make.width.mas_equalTo(@(kScreenWidth - 40));
        make.height.mas_equalTo(@300);
    }];
    
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
    
    
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    CGRect toFrame = self.frame;
    CGRect fromFrame = toFrame;
    fromFrame.origin.y += CGRectGetHeight(window.frame);
    snapshotView.frame = fromFrame;
    
    [view addSubview:snapshotView];
    self.hidden = YES;
    self.markView.alpha = 0;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        snapshotView.frame = toFrame;
        self.markView.alpha = 1;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        self.hidden = NO;
    }];
}

- (void)hidenCompletion:(void (^)(void))completion{
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.markView removeFromSuperview];
        self.markView = nil;
        if (completion) {
            completion();
        }
        
    }];
}

@end
