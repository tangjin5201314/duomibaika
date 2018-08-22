//
//  FyUrlPathDef.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#ifndef FyUrlPathDef_h
#define FyUrlPathDef_h

//正式地址
#define APP_BASEURLPATH @"https://api.youmibank.com"
//#define APP_BASEURLPATH @"http://10.4.25.75"

//测试地址
#define APP_BASEURLPATH_DEV @"https://dev.youmibank.com" //http://120.79.161.223
//#define APP_BASEURLPATH_DEV @"http://10.4.25.75" //http://120.79.161.223

//H5服务器地址,上线前需要改成正式环境
#define APP_H5_PRO @"https://api.youmibank.com"
// H5 静态页面链接
//帮助中心
#define YMHELPCENTER @"/helpCenter/help.html"
//关于我们
#define YMABOUTUS @"//aboutUs/about.html"
//征信协议
#define YMREFERENCECHECK @"/agreement/referenceCheck.html"
//注册协议
#define YMREGISTRATIONAGREEMENT @"/agreement/registrationAgreement.html"
//手机租赁
#define YMMOBILERENTAL @"/agreement/mobileRental.html"
//手机回收
#define YMPHONERECYCLING @"/agreement/phoneRecycling.html"

//图片服务器地址
#define AppImageServerUrl @"{app_img_url}"

//key
#define APP_KEY @"oQIhAP24Kb3Bsf7IE14wpl751bQc9VAPsFZ+LdB4riBgg2TDAiEAsSomOO1v8mK2VWhEQh6mttgN"
//secrect 
#define APP_SECRET @"cab3f18c37712ec6cef1dce6e3ca79bca7b605e3ca42f889ba12ca0ab94a6c1c"

//----------------------------------------买断-----------------------------//
#define ACTIVE_REPAY @"ACTIVE_REPAY"  //买断接口订单请求

#define ACTIVE_REPAY_NOTIFY_SYNC @"ACTIVE_REPAY_NOTIFY_SYNC"  //买断通知



//----------------------------------------HomePage-----------------------------//
#define URLPATH_HOMESTATE @"api/borrow/findIndexNewModify.htm"
#define URLPATH_HOMESTATEV2 @"api/borrow/findIndex.htm"

//获取10个最新借款信息
#define URLPATH_GETNEWLOANMSG  @"api/borrow/listIndex.htm"

//----------------------------------------订单详情-----------------------------//
//获取订单列表
#define ORDER_FINDORDERLIST  @"ORDER_FINDORDERLIST"

#define ORDER_HISTORYPHONE  @"ORDER_HISTORYPHONE"  //首页获取历史订单

//----------------------------------------LoginPage-----------------------------//
//发送验证码
#define URLPATH_FETCHSMSCODE    @"api/user/sendSms.htm"
//获取用户协议信息
#define URLPATH_USERPROCOL     @"api/protocol/list.htm"
//登录
#define URLPATH_USERLOGIN      @"api/user/register.htm"
//密码登录
#define URLPATH_USERPWDLOGIN    @"api/user/login.htm"
//验证手机号码是否已存在
#define URLPATH_IsPhoneExists    @"api/user/isPhoneExists.htm"

//----------------------------------------认证中心-----------------------------//
#define URLPATH_AUTHSTATE    @"api/act/mine/userAuth/getUserAuth.htm" //获取用户认证状态
#define URLPATH_STEP_PARAMS    @"api/act/dict/list.htm" //获取认证列表数据
#define URLPATH_TURENAME @"api/act/mine/userInfo/authenticationForIos.htm" //实名认证上传数据
#define URLPATH_TURENAME_IDF @"api/act/mine/userInfo/ocrUrlFace.htm" //实名认证 上传身份证正面照
#define URLPATH_ZHIMAURL @"api/act/mine/zhima/authorize.htm" //请求芝麻认证的url
//#define URLPATH_OPERATORURL      @"api/shujumohe/h5/getUrlAndUserInfo.htm" //请求运营商认证url
#define URLPATH_OPERATORURL      @"api/shujumohe/h5/getUrlAndUserInfoV2.htm" //请求运营商认证url

#define URLPATH_OPERATORTASKID      @"api/shujumohe/h5/taskId.htm" //发送tsaskid
#define URLPATH_UPLOADCONTACT      @"api/act/mine/userInfo/contacts.htm" //提交用户通讯录信息
#define URLPATH_UPLOADCONTACTAPPROVE      @"api/act/mine/contact/saveOrUpdate.htm" //提交联系人认证信息


//---------------------------------------用户中心-----------------------------//
#define URLPATH_USERINFO    @"api/act/user/info.htm" //个人中心数据
#define URLPATH_FEEDBACK    @"api/act/mine/opinion/submit.htm" //用户反馈
#define URLPATH_LOANPSDSTATE    @"api/act/user/getTradeState.htm" //交易密码状态
#define URLPATH_SETPAYPWD        @"api/act/user/setTradePwd.htm" //设置交易密码
#define URLPATH_RESETPAYPWD        @"api/act/user/resetTradePwd.htm" //忘记密码设置交易密码
#define URLPATH_CHECKOLDPWD        @"api/act/user/validateTradePwd.htm" //检查旧的交易密码
#define URLPATH_MODIFYPWD        @"api/act/user/changeTradePwd.htm" //修改交易密码
#define URLPATH_VALIDATAUSER        @"api/act/user/validateUser.htm" //修改密码，验证用户

//---------------------------------------Loan-----------------------------//
#define URLPATH_LOANHISTORY        @"api/act/mine/borrow/pageNew.htm" //借款记录
#define URLPATH_LOANHISTORYV2        @"api/act/mine/borrow/page.htm" //借款记录

//借款详情+还款详情
#define URLPATH_LOADNDETAIL     @"api/act/mine/borrow/findProgress.htm"
#define URLPATH_REPAYHISTORY    @"api/act/mine/borrow/findRepayRecord.htm"
//主动还款详情页面
#define URLPATH_PAYINADVANCEDETAIL @"api/act/borrow/repay/activeRepayDetail.htm"
//借款详情+主动还款(确认按钮)
#define URLPATH_PAYINADVANCE     @"api/act/borrow/repay/activeRepay.htm"
#define URL_CALCULATEBORROW @"api/borrow/choice.htm"
#define URL_LOADAPPLY      @"api/act/borrow/save.htm"
#define URL_FASTREPAY        @"api/act/borrow/repay/lianlianActiveRepay.htm"
//快捷支付 认证支付返回结果回传服务器
#define URL_FASTREPAYCALLBACK        @"api/act/borrow/repay/repayActiveNotifySync.htm"


//---------------------------------------bankcard-----------------------------//
//获取个人信息
#define URLPATH_USERAPPROVEINFO      @"api/act/mine/userInfo/getUserInfo.htm"
#define URLPATH_SAVEBANKCARD @"/api/act/mine/bankCard/signBankCardInfo.htm"
#define URLPATH_BANKAUTHSIGN    @"api/act/mine/bankCard/authSignReturnNew.htm"//签约影响处理(新)
#define URLPATH_BANKREMARK     @"api/remark/list.htm"
#define URLPATH_BANKMODEL      @"api/act/mine/bankCard/getBankCardList.htm"


//卡宾
#define URLPATH_CARDBIN @"api/act/mine/bankCard/getCardInfo.htm"
//公告
#define URLPATH_ANNOUNCEMENT @"api/announcement/announcementPush.htm"
//版本更新
#define URLPATH_CHECKUPDATE          @"/api/act/version/getinfo.htm"
//百川客服
#define URLPATH_YWUSERINFO @"api/act/user/alibaichuan/getUserBaiChuanLoginNameAndPwd.htm"


//----------------------------分享----------------------------
#define URL_SHAREAPP @"api/act/mine/share/shareContent.htm"

//提交统计数据（激活调用）
#define URL_FIRSTSTART    @"/modules/api/channel/appactevt.htm"
#define URL_LOGINSTAT    @"/modules/api/channel/appregevt.htm" //登录统计

#define HOME_GETHOMEINDEX                                 @"HOME_GETHOMEINDEX"   //登录

#define API_SERVICE_CODE_HOMEINDEX                                 @"HOME_GETHOMEINDEX"   //登录
#define API_SERVICE_CODE_ORDER_PREVIEWORDER                                 @"ORDER_PREVIEWORDER"   //计算借款利息
#define API_SERVICE_CODE_ORDER_SAVEORDER                                 @"ORDER_SAVEORDER"   //借款下单
#define API_SERVICE_CODE_GETMOXIEAPIKEYANDTOKEN                                 @"GETMOXIEAPIKEYANDTOKEN"   //魔蝎apikey userid
#define API_SERVICE_CODE_MOXIERETURN                                 @"UPDATECREDITCARDSTATE"   //魔蝎状态置为认证中
#define API_SERVICE_CODE_TBRETURN                                 @"UPDATETAOBAOSTATE"   //淘宝状态置为认证


#define API_SERVICE_CODE_GETSHANYINSDKAUTHINFO                           @"GETSHANYINSDKAUTHINFO"   //淘宝 apikey userid

#define API_SERVICE_CODE_ORDER_FINDORDERLIST                          @"ORDER_FINDORDERLIST"   //订单列表
#define API_SERVICE_CODE_ORDER_GETORDERDETIALS                          @"ORDER_GETORDERDETIALS"   //订单列表
#define API_SERVICE_CODE_COUNT_CREDIT                          @"CREDIT_COUNT_CREDIT"   //计算费率

#define API_SERVICE_CODE_SETTRADEPWD                          @"LOGIN_CHANGETRADEPWD"   //订单列表
#define API_SERVICE_CODE_CENTRE_AUTH_INFO                          @"CENTRE_AUTH_INFO"   //认证中心
#define API_SERVICE_CODE_ZHIMA_AUTHORIZE                          @"ZHIMA_AUTHORIZE"   //芝麻认证
#define API_SERVICE_CODE_GETOPEH5URL                         @"GETOPEH5URL"   //获取运营商认证url认证
#define API_SERVICE_CODE_UPDATEUSERPHONESTATE                         @"UPDATEUSERPHONESTATE"   //更新运营商状态
#define API_SERVICE_CODE_USEREMERCONTACTSAUTH                         @"USEREMERCONTACTSAUTH"   //实名认证接口
#define API_SERVICE_REALNAME_OCR                         @"REALNAME_OCR"   //实名认证 上传身份证正面照
#define API_SERVICE_REALNAME_FACELIVING                         @"REALNAME_FACELIVING"   //实名认证
#define API_SERVICE_GETDICTS                         @"GETDICTS"   //选项字典
#define API_SERVICE_CONTACTS                         @"CONTACTS"   //上传通讯录信息

//绑卡
#define API_SERVICE_CODE_CARD_BIN                         @"CARD_BIN"   //卡bin
#define API_SERVICE_CODE_BIND_BANK_CARD                         @"BIND_BANK_CARD"   //连连绑卡
#define API_SERVICE_CODE_BIND_BANK_CARD_RETURN                         @"BIND_BANK_CARD_RETURN"   //绑卡回调
#define API_SERVICE_CODE_GET_USER_BANKCARD                         @"GET_USER_BANKCARD"   //获取用户银行卡信息
#define API_SERVICE_CODE_GET_USER_INFO                         @"GET_USER_INFO"   //绑卡界面，获取用户姓名、身份证号
#define API_SERVICE_CODE_SUPPORT_BANK_LIST                         @"SUPPORT_BANK_LIST"   //支持银行列表

//公告
#define API_SERVICE_CODE_ACCOUNTINFO_APP_PUSH                         @"ACCOUNTINFO_APP_PUSH"   //公告

//----------------------------登录注册安全中心相关----------------------------
//发送验证码
#define API_SERVICE_CODE_FETCHSMSCODE    @"SMS_SEND"
//验证码校验
#define API_SERVICE_CODE_VERIFYSCODE    @"SMS_VERIFYSMS"
//sms登录或注册
#define API_SERVICE_CODE_USERLOGIN    @"LOGIN_REGISTER"
//pwd登录
#define API_SERVICE_CODE_PWDLOGIN    @"LOGIN_PWDLOGIN"
//修改或设置登录密码
#define API_SERVICE_CODE_SETORRESETLOGINPWD    @"LOGIN_CHANGELOGINPWD"
//忘记登录密码 no token
#define API_SERVICE_CODE_FORGETPWDNOTOKEN    @"LOGIN_FORGETLOGINPASSWORD"
//获取用户协议信息
#define API_SERVICE_CODE_USERPROCOL    @"PROTOCOL"
//检查旧交易密码
#define API_SERVICE_CODE_CHECKOLDPWD        @"LOGIN_AUTHENOLDPWD"
//验证身份
#define API_SERVICE_CODE_VERIFYIDENTITY        @"LOGIN_AUTHENIDENTITY"

//用户中心
#define API_SERVICE_CODE_UserCenter        @"ACCOUNT_INFO"

//用户中心
#define API_SERVICE_CODE_FEEDBACK    @"OPIONON_SAVE" //用户反馈
#define API_SERVICE_CODE_SHARE    @"SHARE_LINK" //分享
//版本更新
#define API_SERVICE_CODE_CHECKUPDATE          @"VERSION_UPDATE"
//传给富银服务器同盾token
#define API_SERVICE_CODE_UPLOADTONGDUNTOKEN      @"LOGIN_REPLACETONGDUNTOKEN"

#endif /* FyUrlPathDef_h */
