//
//  AuthDictListModel.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthDictModel.h"
@protocol AuthDictModel

@end
@interface AuthDictListModel : NSObject
/**
 联系人关系，type=CONTACT_RELATION
 */
@property (nonatomic,strong)NSArray *contactRelationList;
/**
 直系联系人关系，type=KINSFOLK_RELSTION
 */
@property (nonatomic,strong)NSArray *kinsfolkRelationList;

/**
 教育程度，type=EDUCATIONAL_STATE
 */
@property (nonatomic,strong)NSArray *educationalStateList;
/**
 居住时长，type=LIVE_TIME
 */
@property (nonatomic,strong)NSArray *liveTimeList;
/**
 婚姻状况，type=MARITAL_STATE
 */
@property (nonatomic,strong)NSArray *maritalStateList;

/**
 月薪范围，type=SALARY_RANGE
 */
@property (nonatomic,strong)NSArray *salaryRangeList;
/**
 工作时长，type=WORK_TIME
 */
@property (nonatomic,strong)NSArray *workTimeList;
/**
 银行列表, type=BANK_TYPE
 */
@property (nonatomic,strong)NSArray *bankTypeList;
/**
 职业, type= 
 */
@property (nonatomic,strong)NSArray *workList;
/**
 借款用途, type=
 */
@property (nonatomic,strong)NSArray *loanPurposeList;

@end
