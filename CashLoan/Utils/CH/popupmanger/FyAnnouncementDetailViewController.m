//
//  FyAnnouncementDetailViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "FyAnnouncementDetailViewController.h"

@interface FyAnnouncementDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation FyAnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.model.title;
    self.contentLabel.attributedText = [self attributedStringWithContent:self.model.content];
    self.timeLabel.text = [self dateString:self.model.publishTime fromFormat:@"yyyy-MM-dd hh:mm:ss" toFormat:@"yyyy年MM月dd日"];
    
    self.title = @"公告";
    
    self.navigationItem.leftBarButtonItems = [self fy_createBackButton];
}

- (NSString *)dateString:(NSString *)dateString fromFormat:(NSString *)formFormat toFormat:(NSString *)toFormat{
    NSDateFormatter *fromF = [[NSDateFormatter alloc] init];
    fromF.dateFormat = formFormat;
    
    NSDate *date = [fromF dateFromString:dateString];
    
    NSDateFormatter *toF = [[NSDateFormatter alloc] init];
    toF.dateFormat = toFormat;
    
    return [toF stringFromDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)attributedStringWithContent:(NSString *)content{
    if (content.length == 0) {
        return nil;
    }
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.lineSpacing = 10;
    
    return [[NSAttributedString alloc] initWithString:content attributes:@{NSParagraphStyleAttributeName:textStyle}];
}

-(NSArray<UIBarButtonItem *>*) fy_createBackButton

{
    //两个个item靠近距离
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    backBtn.frame = CGRectMake(0, 0, 60, 32);
    [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"     " forState:UIControlStateNormal];
    [backBtn sizeToFit];
    return @[[[UIBarButtonItem alloc] initWithCustomView:backBtn]];
    
}

- (void)popself{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.closeBlock) {
            self.closeBlock();
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
