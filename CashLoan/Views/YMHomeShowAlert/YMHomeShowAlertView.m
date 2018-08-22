
//
//  YMHomeShowAlertView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeShowAlertView.h"

#define kViewHeight 450
#define kViewMargin 30

@interface YMHomeShowAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *phoneType;
@property (weak, nonatomic) IBOutlet UILabel *leasePriceLab;
@property (weak, nonatomic) IBOutlet UIView *lineA;
@property (weak, nonatomic) IBOutlet UIView *lineB;
@property (weak, nonatomic) IBOutlet UIView *lineC;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
@implementation YMHomeShowAlertView

+ (instancetype)showNoviceAlertViewWithModel:(FyFindIndexModelV2 *)model
                            RegisterBtnBlock:(void (^)())registerBtnBlock
                                  loginBlock:(void (^)(UIButton *))loginBlock
                                  closeBlock:(void (^)())closeBlock {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    YMHomeShowAlertView *registerView = [[NSBundle mainBundle]loadNibNamed:@"YMHomeShowAlertView" owner:self options:nil][0];
    registerView.frame = CGRectMake(0, 0, SCREEN_WIDTH - kViewMargin, kViewHeight);

    registerView.blackView = [[UIView alloc]initWithFrame:window.frame];
    registerView.blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    [window addSubview:registerView.blackView];
    
    registerView.center = window.center;
    [window addSubview:registerView];
    
    registerView.registerBlock = registerBtnBlock;
    registerView.loginBlock = loginBlock;
    registerView.closeBlock = closeBlock;
    
    [registerView displayWithModel:model];
    
    registerView.alpha = 0;
    registerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.3 animations:^{
        registerView.alpha = 1.0;
        registerView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    return registerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineA.backgroundColor = [UIColor separatorColor];
    self.lineB.backgroundColor = [UIColor separatorColor];
    self.lineC.backgroundColor = [UIColor separatorColor];
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = YES;
}

- (void)displayWithModel:(FyFindIndexModelV2 *)model {
    
    self.price.text = [NSString stringWithFormat:@"待交租金：%ld元",(NSInteger)model.UnfishedOrder.allFee - (NSInteger)model.UnfishedOrder.principal];
    
    self.timeLab.text = [NSString stringWithFormat:@"您应于%@日前交租，完成租赁否则会产生逾期费用",[model.UnfishedOrder.rentEndTime substringToIndex:10]];
    
    self.period.text = model.UnfishedOrder.modelName;
    
    self.phoneType.text = [NSString stringWithFormat:@"%ld元",(NSInteger)model.UnfishedOrder.principal];
    self.leasePriceLab.text = [NSString stringWithFormat:@"%ld天",model.UnfishedOrder.period];
}

- (IBAction)leaseDetailAction:(id)sender {
    if (self.registerBlock) {
        self.registerBlock();
    }
    [self closeView];
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [self closeView];
}

- (void)closeView{
  
    [UIView animateWithDuration:0.2 animations:^{
        self.blackView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
