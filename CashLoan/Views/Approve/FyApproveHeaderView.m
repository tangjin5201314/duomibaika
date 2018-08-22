//
//  FyApproveHeaderView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveHeaderView.h"

@interface FyApproveHeaderView()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation FyApproveHeaderView

- (void)setCurrentStep:(NSInteger)currentStep{
    _currentStep = currentStep;
    
    [self configUI];
}

- (void)configUI{
    switch (self.currentStep) {
            case 0:
        {
            self.imageView.image = [UIImage imageNamed:@"flow_first"];
        }
            break;
            case 1:
        {
            self.imageView.image = [UIImage imageNamed:@"flow_Second"];
        }
            break;
            case 2:
        {
            self.imageView.image = [UIImage imageNamed:@"flow_Third"];
        }
            break;
            case 3:
        {
            self.imageView.image = [UIImage imageNamed:@"flow_Fourth"];
        }
            break;

        default:
            break;
    }
    
    for(NSInteger i = 0; i < 4; i++){
        UILabel *label = [self viewWithTag:1000+i];
        label.textColor = i == self.currentStep ? [UIColor whiteColor] : [UIColor textColorV2];
    }
    
    [self sendSubviewToBack:self.imageView];

}

@end
