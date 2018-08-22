//
//  FyFindIndexModelV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanPremiseModelV2.h"
#import "FyBannerModelV2.h"
#import "FyHomeCardModel.h"
#import "FyUserCenterModel.h"
#import "FyHomeActionBannersModel.h"
#import "FyLoanMsgModel.h"

@interface YMHomeMobileModel : FyLoanPremiseModelV2
//机型
@property (nonatomic, copy) NSString *phone_name;
//产商
@property (nonatomic, copy) NSString *phone_firm;
//品牌
@property (nonatomic, copy) NSString *phone_brand;
//内部型号
@property (nonatomic, copy) NSString *phone_model;
//内存
@property (nonatomic, copy) NSString *phone_memory;
//图片
@property (nonatomic, copy) NSString *phone_img;
//总值
@property (nonatomic, assign) CGFloat total_value;
//估值
@property (nonatomic, assign) CGFloat assessment_value;
//历史订单中，是否选中
@property (nonatomic, assign) BOOL isSelected;
//历史订单中，才有
@property (nonatomic, copy) NSString *udid;
//历史订单中，才有
@property (nonatomic, assign) NSInteger num;




@end


@interface YMHomePeriodListModel : FyLoanPremiseModelV2
//
@property (nonatomic, copy) NSString *name;
//产商
@property (nonatomic, assign) NSInteger value;
@end

@interface YMHomeUnfishedOrderModel : FyLoanPremiseModelV2
//订单id
@property (nonatomic, copy) NSString *id;
//机型名称
@property (nonatomic, copy) NSString *modelName;
//内存
@property (nonatomic, copy) NSString *phoneMemory;
//租赁天数
@property (nonatomic, assign) NSInteger period;
//机器估值
@property (nonatomic, assign) CGFloat principal;
//总租金
@property (nonatomic, assign) CGFloat rentFee;
//状态 1:审核中 6:审核失败 2:放款中 5:已完成 4:已逾期 7:待交租
@property (nonatomic, assign) NSInteger status;
//机器唯一识别码
@property (nonatomic, copy) NSString *udid;
//状态文字描述
@property (nonatomic, copy) NSString *statusStr;
//回收时间，未放款时为空
@property (nonatomic, copy) NSString *loanTime;
//订单编号
@property (nonatomic, copy) NSString *orderNo;
//折旧费
@property (nonatomic, assign) CGFloat depreciationFee;
//日租金
@property (nonatomic, assign) CGFloat dayRentFee;
//平台服务费/day
@property (nonatomic, assign) NSInteger dayAuthFee;
//总金额 (包过上述所有费用)
@property (nonatomic, assign) CGFloat allFee;
//逾期管理费
@property (nonatomic, assign) CGFloat overdueFee;
//租借到期时间，未放款为空
@property (nonatomic, copy) NSString *rentEndTime;

@end

@interface FyFindIndexModelV2 : FyLoanPremiseModelV2
//日租金
@property (nonatomic, copy) NSString *daily_rents;
//信审费用
@property (nonatomic, assign) NSInteger audit_fee;


//mobile
@property (nonatomic, strong) YMHomeMobileModel *mobile;
//时间期限数组
@property (nonatomic, strong) NSArray<YMHomePeriodListModel *> *periodList;
//0无 1用户有未完成订单 2手机有未完成订单 3弹
@property (nonatomic, assign) NSInteger IsUnfished;
//未完成订单数组
@property (nonatomic, strong) YMHomeUnfishedOrderModel *UnfishedOrder;

@end
