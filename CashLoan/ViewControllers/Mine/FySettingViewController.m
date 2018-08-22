//
//  FySettingViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySettingViewController.h"
#import "MineSettingModel.h"
#import "FyLoanPwdStateRequest.h"
#import "FySetPsdViewCotroller.h"
#import "FyModifyPayPwdViewController.h"

@interface FySettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *pwdCell;

@property (nonatomic, strong) MineSettingModel *model;

@end

@implementation FySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
//    if ([FyUserCenter sharedInstance].appIsInView) {
//        [self cell:self.pwdCell setHidden:YES];
//        [self reloadDataAnimated:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestData
{
    [self showGif];
    
    FyLoanPwdStateRequest *task = [[FyLoanPwdStateRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, MineSettingModel * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self hideGif];
            self.model = model;
            _pwdLabel.text = model.changeable ? @"修改交易密码" : @"设置交易密码";
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];
    }];
    
}

- (IBAction)loginOutBtnClick:(id)sender {
    [self LPShowAletWithTitle:@"确定要登出当前账号？" Content:@"" left:@"取消" right:@"确定" leftClick:^{
        
    } rightClick:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:FYNOTIFICATION_LOGOUT object:nil];
        
    }];
}

- (void)updatePwd{
    FyModifyPayPwdViewController *vc = [[FyModifyPayPwdViewController alloc] init];
    vc.type = 1;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)setPwd{
    if (_model) {
        if (_model.setable == YES) {
            FySetPsdViewCotroller *vc = [[FySetPsdViewCotroller alloc] init];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self LPShowAletWithTitle:@"亲，请先填写个人信息哦~" Content:@"" left:@"取消" right:@"确定" leftClick:^{
            } rightClick:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([FyUserCenter sharedInstance].appIsInView) return;
    if (indexPath.row == 1) {
        if ([_pwdLabel.text isEqualToString:@"设置交易密码"]){
            [self setPwd];
        }else if ([_pwdLabel.text isEqualToString:@"修改交易密码"]){
            [self updatePwd];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 10.0f;
    }else if (indexPath.row == 1){
        return 55.0f;
    }else if (indexPath.row == 2) {
        return CGRectGetHeight(tableView.frame) - 65 - 50;
    }
    return 0;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
