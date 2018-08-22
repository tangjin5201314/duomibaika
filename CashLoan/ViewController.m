//
//  ViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "ViewController.h"
#import "FyNetworkManger.h"
#import "FyHomePageStateRequest.h"
#import "FyHomePagePickerView.h"
#import "FyHomeStatusModel.h"

@interface ViewController ()<FYHomePagePickerDelegate, FYHomePagePickerDataSource>

@property (nonatomic, strong) IBOutlet FyHomePagePickerView *homePagePickerView;
@property (nonatomic, strong) FyHomeStatusModel *homeModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FyHomePageStateRequest *task = [[FyHomePageStateRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        self.homeModel = model;
        [self.homePagePickerView reloadData];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {

    }];
    
    NSLog(@"%@", [self.view class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)fyNumberOfComponent{
    return 2;
}
- (NSString *_Nonnull)titleInComponent:(NSInteger)component{
    if (component == 0) {
        return @"元";
    }
    return @"天";
}
- (NSString *)withFitTitleInComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.maxCredit.length > 0 ? self.homeModel.maxCredit : @"3000";
    }
    return self.homeModel.maxDays.length > 0 ? self.homeModel.maxDays : @"30";

}

- (NSInteger)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView numberOfRowInComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.creditList.count;
    }
    return self.homeModel.dayList.count;
}
- (nullable NSString *)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.creditList[row];
    }
    return self.homeModel.dayList[row];

}

- (void)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView didSelectRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"select row %ld in component %ld", (long)row, (long)component);
}


@end
