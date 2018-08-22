//
//  IDCardModel.h
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/5/9.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackModel : NSObject
@end

@interface BirthdayModel : NSObject
@property(nonatomic,copy)NSString *day;
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *year;
@end
/**
 如果用户调用时设置可选参数legality为“1”，则返回身份证照片的合法性检查结果，否则不返回该字段。结果为五种分类的概率值（取［0，1］区间实数，取3位有效数字，总和等于1.0），返回结果样例见2.1.4。五种分类为：
 
 ID Photo （正式身份证照片）
 
 Temporary ID Photo  （临时身份证照片）
 
 Photocopy （正式身份证的复印件）
 
 Screen （手机或电脑屏幕翻拍的照片）
 
 Edited （用工具合成或者编辑过的身份证图片）
 */
@interface LegalityModel : NSObject
@property(nonatomic,copy)NSString *IDPhoto;
@property(nonatomic,copy)NSString *TemporaryIDPhoto;
@property(nonatomic,copy)NSString *Edited;
@property(nonatomic,copy)NSString *Photocopy;
@property(nonatomic,copy)NSString *Screen;
@end

@interface FrontModel : NSObject
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *id_card_number;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *race;
@property(nonatomic,copy)NSString *side;
@property(nonatomic,strong) BirthdayModel *birthday;
@property(nonatomic,strong) LegalityModel *legality;
@end

@interface IDCardModel : NSObject
@property (nonatomic,strong) BackModel *back;
@property (nonatomic,strong) FrontModel *front;

@property (nonatomic,copy) NSString *idCard;
@property (nonatomic,copy) NSString *name;


@end
