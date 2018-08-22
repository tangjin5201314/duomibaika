
//
//  YMBlankView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/25.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMBlankView.h"
#define kBtnColor [UIColor fy_colorWithHexString:@"#2583F6"]

@interface YMBlankView ()
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end
@implementation YMBlankView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.resetBtn.layer.borderColor = kBtnColor.CGColor;
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.cornerRadius = 4;
    self.resetBtn.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor bgColor];

}

- (IBAction)resetBtnAction:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

@end
