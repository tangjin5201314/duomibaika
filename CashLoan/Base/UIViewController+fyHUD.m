//
//  UIViewController+fyHUD.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIViewController+fyHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "LEEAlert.h"
#import "UIView+Toast.h"
#import "LEEAlertManager.h"
#import "FyHelpViewController.h"
#import "FyH5PageUtil.h"
#import "LCActionSheet.h"
#import "NSString+fyUrl.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (fyHUD)

+ (void)hud_swizzWithClass:(Class)class originSel:(SEL)originalSelector newSel:(SEL)swizzledSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load{
    [self hud_swizzWithClass:[self class] originSel:NSSelectorFromString(@"dealloc") newSel:@selector(hud_dealloc)];
    [self hud_swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewDidDisappear:") newSel:@selector(hud_viewDidDisappear:)];
    [self hud_swizzWithClass:[self class] originSel:NSSelectorFromString(@"viewDidAppear:") newSel:@selector(hud_viewDidAppear:)];
    
}

- (void)hud_dealloc{
    self.HUD = nil;
    [self hud_dealloc];
}

- (void)hud_viewDidAppear:(BOOL)animated{
    [self hud_viewDidAppear:animated];
    self.HUD.hidden = NO;
}

- (void)hud_viewDidDisappear:(BOOL)animated{
    [self hud_viewDidDisappear:animated];
    self.HUD.hidden = YES;
}



- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    if (self.HUD) {
        [self.HUD hideAnimated:NO];
    }
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)hideGif{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self HUD] hideAnimated:YES];
    });

}

- (void)showGifMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 显示模式,改成customView,即显示自定义图片(mode设置,必须写在customView赋值之前)
        //    hud.mode = MBProgressHUDModeCustomView;
        //    // 设置要显示 的自定义的图片
        //    hud.customView = [self loadGifView:imgName];
        //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        // 显示的文字,比如:加载失败...加载中...
        
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = msg;
        hud.backgroundColor = [UIColor colorWithRGB:000000 alpha:.3];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor colorWithRGB:000000 alpha:.4];
        hud.label.textColor = [UIColor whiteColor];
        // 标志:必须为YES,才可以隐藏,  隐藏的时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hideAnimated:YES afterDelay:time];

        [self setHUD:hud];
    });

}

- (void)showGif {
    [self hideGif];
    [self showGifMsg:@"请稍候..." duration:120 imgName:@"点击加载"];
}

- (UIImageView *)loadGifView:(NSString *)image {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:image withExtension:@"gif"];//加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
    size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
    NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
    for (size_t i=0; i < frameCout; i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];//将图片加入数组中
        CGImageRelease(imageRef);
    }
    
    UIImageView* imageview=[[UIImageView alloc] initWithFrame:CGRectMake(00, 0, 80, 80)];
    imageview.animationImages = frames;//将图片数组加入UIImageView动画数组中
    imageview.animationDuration = 1.5 ;//每次动画时长
    [imageview startAnimating];//开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
    
    return imageview;
}


- (void)LPShowAletWithContent:(NSString *)content {
    [self LPShowAletWithContent:content dismissText:@"确定"];
}

- (void)LPShowAletWithContent:(NSString *)content okClick:(okBlock)okblock{
    [self LPShowAletWithContent:content dismissText:@"确定" okClick:okblock];
}

- (void)LPShowAletWithContent:(NSString *)content dismissText:(NSString *)text {
    [self LPShowAletWithContent:content dismissText:text okClick:nil];
}


- (void)LPShowAletWithContent:(NSString *)content dismissText:(NSString *)text okClick:(okBlock)okBlock {
    [LEEAlert alert].config.LeeCornerRadius(7);
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = content;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor textColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = text;
        
        action.titleColor = [UIColor tabBarColor];
        
        action.font = [UIFont systemFontOfSize:18];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = okBlock;
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
    
}


- (void)LPShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText rightClick:(rightBlock)block{
    [self LPShowAletWithTitle:content Content:@"" left:leftText right:rightText rightClick:block];
    
}

- (void)LPShowAletWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText rightClick:(rightBlock)block{
    [self LPShowAletWithTitle:title Content:@"" left:leftText right:rightText leftClick:nil rightClick:block];
}


- (void)LPShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction {
    [self LPShowAletWithTitle:content Content:content left:leftText right:rightText leftClick:leftAction rightClick:rightAction];
}

- (void)fyShowAletWithContent:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction {
    [self LPShowAletWithTitle:content Content:@"" left:leftText right:rightText leftClick:leftAction rightClick:rightAction];
}


- (void)LPShowAletWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction {
    [LEEAlert alert].config.LeeCornerRadius(7);
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = title;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor textColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = content;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = leftText;
        
        action.titleColor = [UIColor textColor];
        
        action.font = [UIFont systemFontOfSize:18];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = leftAction;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = rightText;
        
        action.titleColor = [UIColor tabBarColor];
        
        //        action.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        action.font = [UIFont systemFontOfSize:18];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = rightAction;
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
    
}

- (void)YMLeasePactAlertWithTitle:(NSString *)title Content:(NSString *)content left:(NSString *)leftText right:(NSString *)rightText leftClick:(leftBlock)leftAction rightClick:(rightBlock)rightAction{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    UIButton *pactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pactBtn addTarget:self action:@selector(pactBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [pactBtn setImage:[UIImage imageNamed:@"checkBox-n"] forState:UIControlStateNormal];
    [pactBtn setImage:[UIImage imageNamed:@"checkbox-s"] forState:UIControlStateSelected];
    pactBtn.selected = YES;
    [LEEAlertManager sharedManager].isPactShow = NO;

    [view addSubview:pactBtn];
    [pactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(view.mas_centerY);
    }];
    UILabel *text = [[UILabel alloc] init];
    text.text = @"我已阅读并同意";
    text.font = [UIFont systemFontOfSize:13];
    text.textColor = [UIColor grayColor];
    [view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pactBtn.mas_right).offset(2);
        make.centerY.equalTo(pactBtn);
    }];
    
    UIButton *h5Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [h5Btn setTitle:@"《租赁相关协议》" forState:UIControlStateNormal];
    [h5Btn addTarget:self action:@selector(h5BtnAction) forControlEvents:UIControlEventTouchUpInside];
    [h5Btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    h5Btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:h5Btn];
    [h5Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(text.mas_right).offset(0);
        make.centerY.equalTo(view.mas_centerY);
    }];
    [LEEAlert alert].config.LeeCornerRadius(7);
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = title;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor textColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = content;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        label.textColor = [UIColor grayColor];
    })
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        custom.view = view;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
//    .LeeItemInsets(UIEdgeInsetsMake(20, 10, 10, 10)) // 想为哪一项设置间距范围 直接在其后面设置即可 ()
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = leftText;
        
        action.titleColor = [UIColor textColor];
        
        action.font = [UIFont systemFontOfSize:18];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = leftAction;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = rightText;
        
        action.titleColor = [UIColor tabBarColor];
        
        action.font = [UIFont systemFontOfSize:18];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = rightAction;
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}

- (void)pactBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [LEEAlertManager sharedManager].isPactShow = !sender.selected;
}

- (void)h5BtnAction {
    WS(weakSelf)
    [LEEAlert closeWithCompletionBlock:^{
        [weakSelf toPushLicenseAgreement];
    }];
}

/**
 跳转授权协议
 */
- (void)toPushLicenseAgreement {
    [LEEAlertManager sharedManager].isPactShow = NO;

    NSArray *titleArr = @[@"多米白卡手机融资租赁合同",@"多米白卡居间服务协议"];
    NSArray *urlArr = @[[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMMOBILERENTAL],[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMPHONERECYCLING]];

    WS(weakSelf)
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitleArray:titleArr];
    actionSheet.clickedHandler = ^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            NSString *title = titleArr[buttonIndex - 1];
            NSString *urlStr = urlArr[buttonIndex - 1];
            [weakSelf pushToProtocolWithModel:urlStr title:title];
        }
    };
    
    actionSheet.titleFont = [UIFont systemFontOfSize:18];
    actionSheet.titleColor = [UIColor textColorV2];
    actionSheet.buttonFont = [UIFont systemFontOfSize:17];
    actionSheet.buttonColor = [UIColor textColorV2];
    actionSheet.unBlur = YES;
    [actionSheet show];
}

- (void)pushToProtocolWithModel:(NSString *)urlStr title:(NSString *)title {
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = title;
    vc.url = [urlStr fy_UrlString];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)CallLiMaYouQian {
    [self makeCall:@"4000808012"];
}

- (void)makeCall:(NSString *)phoneNumber {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

- (void)fy_toastMessages:(NSString *)message hidenDelay:(CGFloat)delay{
    [CSToastManager sharedStyle].backgroundColor = [UIColor colorWithWhite:0 alpha:0xa0/255.0];
    [CSToastManager sharedStyle].horizontalPadding = 20;
    [CSToastManager sharedStyle].verticalPadding = 20;

    
    [self.view.window fy_hideAllToasts];
    
    if (delay < 0) {
        [self.view.window fy_makeToast:message duration:[CSToastManager defaultDuration] position:CSToastPositionCenter];

    }else{
        [self.view.window fy_makeToast:message duration:delay position:CSToastPositionCenter];
    }
    
}

- (void)fy_toastMessages:(NSString *)message{
    [self fy_toastMessages:message hidenDelay:-1];
}


@end
