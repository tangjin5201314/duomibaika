//
//  YMHomeNormalCell.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMHomeNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

- (void)displayContent:(NSDictionary *)dic;
@end