//
//  UMHomeShowAlertManager.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/25.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeShowAlertManager.h"
#import "YMHomeLeaseTipView.h"
#import "YMHomeShowAlertView.h"
#import "YMGuideShowAlertView.h"
@implementation YMHomeShowAlertManager

+ (void)showLeaseTipView:(NSArray *)dataArr leaseBlock:(void (^)(NSInteger))leaseBlock {
    YMHomeLeaseTipView *tip = [YMHomeLeaseTipView loadNib];
    tip.leaseBtnBlock = leaseBlock;
    [tip show:dataArr];
}

+ (void)showUnfinishedOrderTipView:(FyFindIndexModelV2 *)model leaseBlock:(void (^)(void))leaseBlock {
    [YMHomeShowAlertView showNoviceAlertViewWithModel:model RegisterBtnBlock:leaseBlock loginBlock:nil closeBlock:nil];
}

+ (void)showGuideViewWithcloseBlock:(void (^)(void))closeBlock {
     NSArray *arr = @[@{@"name":@"多米白卡能做什么？",@"img":@"ct.jpg",@"content":@"回收手机秒速放款，解决短期小额资金问题"},
                                    @{@"name":@"回收价款多久到账？",@"img":@"ct2.jpg",@"content":@"审核通过后立即支付回收价款，最快只需1分钟"},
                                    @{@"name":@"申请回收后的手机，如何给多米白卡？",@"img":@"ct3",@"content":@"用户申请后，可以在租赁期内以原价买断手机，重新拥有自己的爱机"}
                                    ];

    
    [YMGuideShowAlertView showGuideAlertViewWithModel:arr closeBlock:closeBlock];
}
@end
