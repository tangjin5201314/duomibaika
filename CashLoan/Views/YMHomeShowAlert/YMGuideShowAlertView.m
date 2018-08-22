//
//  YMGuideShowAlertView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/3/1.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMGuideShowAlertView.h"

#define kViewHeight 520
#define kViewMargin 30
@interface YMGuideShowAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImg;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
@implementation YMGuideShowAlertView

+ (instancetype)showGuideAlertViewWithModel:(NSArray *)arr
                                  closeBlock:(void (^)())closeBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    YMGuideShowAlertView *guideView = [[NSBundle mainBundle] loadNibNamed:@"YMGuideShowAlertView" owner:self options:nil][0];
    guideView.frame = CGRectMake(0, 0, SCREEN_WIDTH - kViewMargin, kViewHeight);

    guideView.blackView = [[UIView alloc]initWithFrame:window.frame];
    guideView.blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [window addSubview:guideView.blackView];
    
    guideView.dataArr = arr;
    guideView.index = 0;
    guideView.center = window.center;
    guideView.centerY = window.centerY + 50;
    [window addSubview:guideView];
    
//    registerView.registerBlock = registerBtnBlock;
//    registerView.loginBlock = loginBlock;
    guideView.closeBlock = closeBlock;
    
//    [registerView displayWithModel:model];
    
    guideView.alpha = 0;
    guideView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.3 animations:^{
        guideView.alpha = 1.0;
        guideView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    return guideView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = YES;
}

- (IBAction)clickBtnAction:(id)sender {
    self.index++;
    
    NSLog(@"dataArr == %@",self.dataArr);
    if (self.index <= self.dataArr.count -1) {
        NSDictionary *dic = self.dataArr[self.index];
        NSString *title = dic[@"name"];
        NSString *content = dic[@"content"];
        NSString *img = dic[@"img"];
        self.titleLab.text = title;
        self.contentLab.text = content;
        self.backgroudImg.image = [UIImage imageNamed:img];
        
        if (self.index == self.dataArr.count-1) {
            [self.clickBtn setBackgroundImage:[UIImage imageNamed:@"ymguidewc"] forState:UIControlStateNormal];
        }
        return;
    }
    [self closeView];
}

- (IBAction)closeBtnAction:(id)sender {
    [self closeView];
}

- (void)closeView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.blackView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.blackView removeFromSuperview];
    }];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
