//
//  UserInfoModel.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/23.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/**
 身份证背面
 */
@property(nonatomic,strong)NSData *backImgData;
/**
 详细地址
 */
@property(nonatomic,copy)NSString *liveDetailAddr;
/**
 学历
 */
@property(nonatomic,copy)NSString *education;
/**
 身份证正面
 */
@property(nonatomic,strong)NSData *frontImgData;
/**
 身份证号
 */
@property(nonatomic,copy)NSString *idNo;
/**
 现居住地址
 */
@property(nonatomic,copy)NSString *liveAddr;
/**
 自拍
 */
@property(nonatomic,copy)NSString *livingImg;
/**
 身份证上照片
 */
@property(nonatomic,copy)NSString *ocrImg;
/**
 姓名
 */
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *userId;
/**
 经度,纬度
 */
@property(nonatomic,copy)NSString *liveCoordinate;

@property (nonatomic,assign) NSInteger state;

/**
 *faceID 姓名
 */
@property(nonatomic,copy)NSString *name;

/**
 *faceID 身份证号
 */
@property(nonatomic,copy)NSString *id_card_number;
/**
 *配合MegLive SDK使用时，用于校验上传数据的校验字符串，此字符串会由MegLive SDK直接返回。
 */
@property (nonatomic,copy) NSString* delta;
@property (nonatomic,strong) NSData* faceData;
@property (nonatomic,strong) NSData* envData;


@end
