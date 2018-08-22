//
//  FyH5PageUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyH5PageUtil.h"
#import "FyH5ModelRequest.h"

//借款协议（通用）
#define LP_H5   @"/h5/fyjr"
//帮助中心
#define LP_H5_Help    @"/helpCenter"
//帮助中心
#define LP_H5_BorrowRaiders    @"/borrowRaiders"
//关于我们
#define LP_H5_aboutUs  @"/h5/fyjr/aboutUs.html"
//绑卡协议
//#define LP_H5_LoanBindcard     @"/h5/fyjr/bindcard.html"
#define LP_H5_LoanBindcard     @"/entrustedDebitAuthorization"

//注册协议
#define LP_H5_RegisterProtocol     @"/h5/fyjr/protocol_register.html"
//信息收集及使用规则
#define LP_H5_RegisterRules     @"/h5/fyjr/protocol_rules.html"
//协议模板
#define LP_H5_LoanProtocolData    @"/h5/protocol_borrow.html"

#define Rd_HB_H5PageList     @"api/h5/list.htm"
#define Rd_HB_RemarkList     @"api/remark/list.htm"
 
#define LP_H5_LoanProtocol    @"/h5/fyjr/protocol_borroweg.html"


@implementation FyH5PageUtil

+ (NSString *)urlPathWithType:(FyH5PageType)type{
    NSString *urlString = @"";
    if (type == FyH5PageTypeHelp) {
        urlString = LP_H5_Help;
    }else
    if (type == FyH5PageTypeAboutUs) {
        urlString = LP_H5_aboutUs;
    }else
    if(type == FyH5PageTypeLoanProtocol){
        urlString = LP_H5_LoanProtocolData;

    }else
    if (type == FyH5PageTypeBindCard) {
        urlString = LP_H5_LoanBindcard;
    }else if(type == FyH5PageTypeLoanEGProtocol){
        urlString = LP_H5_LoanProtocol;
        
    }else if(type == FyH5PageTypeBorrowRaiders){
        urlString = LP_H5_BorrowRaiders;
    }

    NSString *devHost = @"https://apps.limayq.com";
    NSString *prodHost = @"https://app.limayq.com";
    NSString *host = [FyNetworkManger sharedInstance].useProductionServer ? prodHost : devHost;
    
    return [self domaine:host path:urlString];
}

+ (NSString *)domaine:(NSString *)domaine path:(NSString *)path{
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:domaine]].absoluteString;
}


+ (NSString *)urlPathWithLink:(NSString *)link{
    return [[FyNetworkManger sharedInstance] baseURLWithPath:link];
}

+ (NSString *)loanProcotolWithState:(LoanState)state borrowID:(NSString *)borrowID{
    NSString *url;
    switch (state) {
        case LoanStateInView: //10
        case LoanStatePass: //20
        case LoanStateNoPass: //21
        case LoanStateWaitingRecheck: //22
        case LoanStateRecheckPass: //26
        case LoanStateRecheckNoPass: //27
        case LoanStateInLoan: //29
            
            url = [FyH5PageUtil urlPathWithType:FyH5PageTypeLoanProtocol];
            break;
            
        default:
            url = [NSString stringWithFormat:@"%@?userid=%@&borrowId=%@",[FyH5PageUtil urlPathWithType:FyH5PageTypeLoanProtocol],[FyUserCenter sharedInstance].userId,borrowID];
            break;
    }
    
    return url;
}

+ (NSString *)loanProcotolWithBorrowH5Link:(NSString *)h5Link{
    if (h5Link.length == 0) {
        return [FyH5PageUtil urlPathWithType:FyH5PageTypeLoanProtocol];
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",LP_H5,[h5Link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    return [[FyNetworkManger sharedInstance] baseURLWithPath:path];

}

+ (NSString *)phoneNumber{
    return  @"400-080-8012";
}

+ (void)call{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [self phoneNumber]]]];

}

+(void)requestDataWithType:(FyH5PageType)type result:(void (^)(H5PageModel *model,FyResponse *response))resultBlock{
    NSString *API;
    switch (type) {
        case FyH5PageTypeAboutUs:
        case FyH5PageTypeHelp:
        {
            API = Rd_HB_H5PageList;
        }
            break;
        case FyH5PageTypeBankRemark:
        {
            API = Rd_HB_RemarkList;
        }
            break;
        default:
            break;
    }

    FyH5ModelRequest *task = [[FyH5ModelRequest alloc] init];
    task.api = API;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *t, FyResponse *error, id model) {
        NSString *key;
        switch (type) {
            case FyH5PageTypeAboutUs:
            {
                key = @"h5_about_us";
            }
                break;
            case FyH5PageTypeHelp:
            {
                key = @"h5_help";
            }
                break;
            case FyH5PageTypeBankRemark:
            {
                key = @"remark_bank_card";
            }
                break;
            
            default:
                break;
        }
        
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            for (NSDictionary *dic in [model objectForKey:@"list"]) {
                if ([[dic objectForKey:@"code"]isEqualToString:key]) {
                    H5PageModel *dataModel = [[H5PageModel alloc]init];
                    dataModel.code = dic[@"code"];
                    dataModel.value = dic[@"value"];
                    dataModel.name = dic[@"name"];
                    resultBlock(dataModel,error);
                }
            }
        }
        else{
            resultBlock(nil,error);
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        resultBlock(nil,error);
    }];
    
}

@end
