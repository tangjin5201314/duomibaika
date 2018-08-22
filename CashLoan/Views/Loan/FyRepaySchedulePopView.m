//
//  FyRepaySchedulePopView.m
//  CashLoan
//
//  Created by fyhy on 2017/12/8.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepaySchedulePopView.h"
#import "FyRepaySchedulePopViewCell.h"
#import "FyInStagesRateModel.h"

@interface FyRepaySchedulePopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation FyRepaySchedulePopView

static NSString *const reuseaIdentifier_cell = @"reuseaIdentifier_cell";

- (IBAction)close:(id)sender{
    [self fy_Hidden];
}

- (void)setRepaySchedule:(NSArray *)repaySchedule{
    if (_repaySchedule != repaySchedule) {
        _repaySchedule = repaySchedule;
        
        [self.tableView reloadData];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FyRepaySchedulePopViewCell" bundle:nil] forCellReuseIdentifier:reuseaIdentifier_cell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.repaySchedule.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FyInStagesRepayModel *model = self.repaySchedule[indexPath.row];
    FyRepaySchedulePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseaIdentifier_cell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fyTextLabel.text = [NSString stringWithFormat:@"%ld/%ld期", indexPath.row+1, self.repaySchedule.count];
    cell.fyDateLabel.text = model.dueTime;
    cell.fySubTextLabel.text = [model displayPrice];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
