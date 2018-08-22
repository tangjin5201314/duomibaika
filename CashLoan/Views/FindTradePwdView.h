//
//  FindTradePwdView.h
//  CashLoan
//
//  Created by rdmacmini on 17/2/23.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCountDownButton.h"

@protocol FindTradePwdViewDelegate <NSObject>

-(void)FindTradePwdSendValidCode:(NSString *)phone;

-(void)FindTradePhone:(NSString *)phone withRealName:(NSString *)realName withCardId:(NSString *)CardId withCode:(NSString *)code;

@end

@interface FindTradePwdView : UIView

@property (nonatomic, weak) id<FindTradePwdViewDelegate> FindTradePwdViewDelegate;
@property (nonatomic, retain) UITextField *phoneTF;  //手机号
@property (nonatomic, retain) UITextField *nameTF;  //真实姓名
@property (nonatomic, retain) UIButton *resetBtn;  //修改按钮
@property (nonatomic, retain) UITextField *CardIdTF;  //身份证号
@property (nonatomic, retain) UITextField *codeTF;  //短信验证码
@property (nonatomic, strong) RDCountDownButton *getCodeBtn;  //短信验证码


-(instancetype)initFindTradePwdView;
-(void)loadPhoneTF:(NSString *)phone;
@end
