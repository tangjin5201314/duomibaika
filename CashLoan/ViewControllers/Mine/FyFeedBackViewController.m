//
//  FyFeedBackViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFeedBackViewController.h"
#import "FeedBackView.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FyFeedBackRequest.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface FyFeedBackViewController ()

@property (nonatomic, weak) IBOutlet FeedBackView *feedBackView;
@property (nonatomic, weak) IBOutlet UIButton *sureButton;

@end

@implementation FyFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"意见反馈";
    self.fy_navigationBarLineColor = [UIColor whiteColor];
    _sureButton.enabled = NO;
    _feedBackView.txtBlock = ^(NSString *txt) {
        if (txt.length > 0) {
            _sureButton.backgroundColor = [UIColor textGradientEndColor];
            _sureButton.enabled = YES;
        }else{
            _sureButton.backgroundColor = [UIColor unableSelectColor];
            _sureButton.enabled = NO;

        }
    };
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [_feedBackView.textView becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendFeedBack:(UIButton *)sender
{
    NSString *errorMsg;
    if (!_feedBackView.textView.text.length) {
        errorMsg = @"请输入您的反馈意见";
    }
    else if ([self stringContainsEmoji:_feedBackView.textView.text]){
        errorMsg = @"输入内容含有表情，请重新输入";
    }
    else{
        [SVProgressHUD show];
        sender.enabled = NO;
        
        FyFeedBackRequest *task = [[FyFeedBackRequest alloc] init];
        task.message = _feedBackView.textView.text;
        
        [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
            sender.enabled = YES;
            [SVProgressHUD dismiss];
            
            if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
                [self LPShowAletWithContent:error.errorMessage okClick:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
            sender.enabled = YES;
            [self fy_toastMessages:error.errorMessage];
        }];
        
        
        if (errorMsg) {
            [self LPShowAletWithContent:errorMsg];
        }
    }
}
/*
 *利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */
- (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = NO;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
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
