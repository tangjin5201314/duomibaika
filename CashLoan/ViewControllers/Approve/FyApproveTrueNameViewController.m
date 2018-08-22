//
//  FyApproveTrueNameViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveTrueNameViewController.h"
#import "AuthDictListModel.h"
#import "AuthDictService.h"
#import <SVProgressHUD/SVProgressHUD.h>

#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>
#import <MGIDCard/MGIDCard.h>
#import "RDPickerView.h"
#import "FyApproveHeaderView.h"
#import "UserInfoModel.h"
#import "FyUploadIDFRequest.h"
#import "FyUploadTureNameRequest.h"
#import "IDCardModel.h"
#import "FyApproveStepUtil.h"
#import "JVFloatLabeledTextField.h"
#import "EventHanlder.h"
#import "FyAffirmAlertView.h"
#import "UIImage+Tools.h"
#import "NSString+Validation.h"
#import "YMApproveManager.h"

#define kMaxSalary 120000

@interface FyApproveTrueNameViewController ()<RDPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    AuthDictModel *_selectModel;
    NSInteger pickerViewIndex;
    __weak NSURLSessionTask *faceTask;
    __weak NSURLSessionTask *uploadTask;
}

@property(nonatomic,strong)RDPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *IDFrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *IDBackBtn;

@property (weak, nonatomic) IBOutlet UIImageView *faceOK;
@property (weak, nonatomic) IBOutlet UIImageView *idFrontOK;
@property (weak, nonatomic) IBOutlet UIImageView *idBackOK;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *nameTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *IDTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *educationTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *professionTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *marriageTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *salaryTF;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *IdCell;


@property (nonatomic, strong) AuthDictListModel *dictListModel;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, strong) FrontModel *frontModel;
@property (nonatomic, strong) YMApproveManager *approveManager;

@property (nonatomic, strong) NSData *faceImageData;

@end

@implementation FyApproveTrueNameViewController

- (UserInfoModel *)userModel{
    if (!_userModel) {
        _userModel = [[UserInfoModel alloc] init];
    }
    return _userModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }

    if (self.autoNext) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.title = @"实名认证";
    }
    
    [self configSubviews];
    [self configFacePlusPlusComplete:nil];
    [self requestDictComplete:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.autoNext) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configFacePlusPlusComplete:(void(^)(BOOL b))complete{
    if ([MGLicenseManager  getLicense]) {
        if (complete)
            complete(YES);
        return;
    }
    
    WS(weakSelf)
       
   if (complete)
       [self showGif];
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        NSLog(@"%@",License ? @"\n============\nFace++激活成功\n==========" : @"\n==========\nFace++激活成功失败\n==========");
        if (!License) {
            [weakSelf LPShowAletWithContent:[NSString stringWithFormat:@"人脸识别激活失败"] dismissText:@"完成"];
            if (complete){
                complete(License);
                [weakSelf hideGif];
            }

            return ;
        }
        
        if (complete){
            complete(License);
            [weakSelf hideGif];
        }

    }];
}

- (void)configSubviews{
    self.faceOK.hidden = YES;
    self.idBackOK.hidden = YES;
    self.idFrontOK.hidden = YES;
    _nameTF.enabled = NO;
    _IDTF.enabled = NO;
    [_nameTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_IDTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_professionTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_educationTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_marriageTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_salaryTF setValue:[UIColor weakTextColor] forKeyPath:@"_placeholderLabel.textColor"];

    [self setIDCellsHidden:YES];
    _IDTF.delegate = self;
    
    _IDTF.borderStyle = UITextBorderStyleNone;
    _nameTF.borderStyle = UITextBorderStyleNone;

    [_professionTF setPlaceholder:@"请选择您的职业信息" floatingTitle:@"职业"];
    [_educationTF setPlaceholder:@"请选择您的学历信息" floatingTitle:@"学历"];
    [_marriageTF setPlaceholder:@"请选择您的婚姻状况" floatingTitle:@"婚姻状况"];
    [_salaryTF setPlaceholder:@"请选择您的月收入(1-120000)" floatingTitle:@"月收入(元)"];
    
    _salaryTF.keyboardType = UIKeyboardTypeNumberPad;
    _salaryTF.delegate = self;
}

- (void)setIDCellsHidden:(BOOL)hidden {
    [self cell:_nameCell setHidden:hidden];
    [self cell:_IdCell setHidden:hidden];
    [self reloadDataAnimated:NO];
}


-(void)requestDictComplete:(void (^)(void))complete{
    [AuthDictService requestDictWithType:AuthDictTypeTrueName resultModel:^(AuthDictListModel *model, FyResponse *error) {
        if (model) {
            self.dictListModel = model;
        }
        else{
            [self fy_toastMessages:error.errorMessage];
        }
        if (complete) {
            complete();
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
- (IBAction)IDEditBtnClick:(id)sender {
    [_IDTF becomeFirstResponder];
}
- (IBAction)nameEditBtnClick:(id)sender {
    [_nameTF becomeFirstResponder];
}

- (IBAction)faceBtnClick:(id)sender {
    [self faceApprove];
}

- (IBAction)IDFrontBtnClick:(id)sender {
    [self getIDImageWithCardType:IDCARD_SIDE_FRONT];
    
}

- (IBAction)IDBackBtnClick:(id)sender {
    [self getIDImageWithCardType:IDCARD_SIDE_BACK];
    
}
- (IBAction)nextBtnClick:(id)sender {
    [self checkData];
//    [self uploadSuccess];
}

- (void)pushToFacePlus{
    /*
    MGLiveManager *liveManager = [[MGLiveManager alloc] init];
    liveManager.actionCount = 3;
    liveManager.actionTimeOut = 10;
    liveManager.randomAction = YES;
    
    [liveManager startFaceDecetionViewController:self
                                          finish:^(FaceIDData *finishDic, UIViewController *viewController) {
                                              [viewController dismissViewControllerAnimated:YES completion:nil];
                                              [self faceLiveViewController:viewController checkOK:YES FaceIDData:finishDic failedType:DETECTION_FAILED_TYPE_MASK];
                                          } error:^(MGLivenessDetectionFailedType errorType, UIViewController *viewController) {
                                               [viewController dismissViewControllerAnimated:YES completion:nil];
                                               [self faceLiveViewController:viewController checkOK:NO FaceIDData:nil failedType:errorType];
                                           }];
*/
}

- (void)pushToIDCardWithType:(MGIDCardSide)type{
    /*
    NSInteger cardType = type;
    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
    cardManager.screenOrientation = MGIDCardScreenOrientationLandscapeLeft;
    [cardManager IDCardStartDetection:self IdCardSide:cardType finish:^(MGIDCardModel *model) {
        [self saveIDCardModel:model cardType:cardType];
        
        //        [EventHanlder trackIDOcrEventWithSuccess:YES];
    } errr:^(MGIDCardError errorType) {
        NSString *errorString;
        //        [EventHanlder trackIDOcrEventWithSuccess:NO];
        
        switch (errorType) {
            case MGIDCardErrorCancel:
            {
                
            }
                break;
            case MGIDCardErrorSimulator:
            {
                errorString = @"暂不支持模拟器";
            }
                break;
            default:
            {
                errorString = @"检测失败";
            }
                break;
        }
        if (errorString) {
            [self LPShowAletWithContent:errorString dismissText:@"完成"];
            
        }
    }];
*/
}

-(void)faceApprove {
    [self configFacePlusPlusComplete:^(BOOL b) {
        if (b) {
            [FyAuthorizationUtil canReadCameraWithBlock:^(BOOL canRead, AVAuthorizationStatus authorStatus) {
                if (canRead) {
                    [self pushToFacePlus];
                }else{
                    [FyAuthorizationUtil showRequestCameraTipFromViewController:self];
                }
            }];
            
        }
    }];
}

- (void)getIDImageWithCardType:(MGIDCardSide)ct {
    [self configFacePlusPlusComplete:^(BOOL b) {
        if (b) {
            [FyAuthorizationUtil canReadCameraWithBlock:^(BOOL canRead, AVAuthorizationStatus authorStatus) {
                if (canRead) {
                    [self pushToIDCardWithType:ct];
                }else{
                    [FyAuthorizationUtil showRequestCameraTipFromViewController:self];
                }
            }];

        }
    }];
}


//人脸识别
-(void)faceLiveViewController:(UIViewController *)viewController checkOK:(BOOL)ok FaceIDData:(FaceIDData *)data  failedType:(MGLivenessDetectionFailedType)failedType{
    if (!ok) {
        [self errorType:failedType];
        [EventHanlder trackFaceRecognitionEventWithSuccess:NO];
        return;
    }
    
    [EventHanlder trackFaceRecognitionEventWithSuccess:YES];
    
    NSData *header = [[data images] valueForKey:@"image_best"];
    NSData *env = [[data images] valueForKey:@"image_env"];

    NSLog(@"%@", [data images].allKeys);
    
//    @"image_env"

    self.userModel.delta = data.delta;
    self.userModel.faceData = header;
    self.userModel.envData = env;
    UIImage *image = [UIImage imageWithData:header];
    [_faceBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_faceBtn setBackgroundImage:image forState:UIControlStateDisabled];
    _faceBtn.enabled = NO;
    _faceOK.hidden = NO;
    
}

- (void)uploadIDF{
    [self showGif];

    FyUploadIDFRequest *task = [[FyUploadIDFRequest alloc] init];
    task.idF = [[FyFileModel alloc] initWithFileData:self.userModel.frontImgData name:@"file" fileName:@"ocrFrontImg.jpg" mimeType:@"image/jpeg"];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if(error.errorCode == RDP2PAppErrorTypeYYSuccess){
            [self performSelector:@selector(configIDFontWithModel:) withObject:model afterDelay:0.5];
//            [self configIDFontWithModel:model];
        }
        else{
            [self fy_toastMessages:error.errorMessage];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self LPShowAletWithContent:error.errorMessage];
    }];
}

- (NSData *)dataWithImageData:(NSData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData];
    image = [UIImage resizeWithImage:image scale:0.2 min:500];
    return UIImageJPEGRepresentation(image, 1);
}

-(void)uploadData{
    [uploadTask cancel];
    [self showGif];

//    FyFileModel *faceFile = [[FyFileModel alloc]initWithFileData:[self dataWithImageData:self.userModel.faceData] name:@"livingImg" fileName:@"livingImg.jpg" mimeType:@"image/jpeg"];
//    FyFileModel *backFile = [[FyFileModel alloc]initWithFileData:[self dataWithImageData:self.userModel.backImgData] name:@"backImg" fileName:@"backImg.jpg" mimeType:@"image/jpeg"];
    FyFileModel *faceFile = [[FyFileModel alloc]initWithFileData:self.userModel.faceData name:@"living" fileName:@"livingImg.jpg" mimeType:@"image/jpeg"];
    FyFileModel *envFile = [[FyFileModel alloc]initWithFileData:self.userModel.envData name:@"imgEnv" fileName:@"imgEnv.jpg" mimeType:@"image/jpeg"];
    FyFileModel *backFile = [[FyFileModel alloc]initWithFileData:self.userModel.backImgData name:@"back" fileName:@"backImg.jpg" mimeType:@"image/jpeg"];

    FyUploadTureNameRequest *task = [[FyUploadTureNameRequest alloc] init];
    task.faceFile = faceFile;
    task.IDBFile = backFile;
    task.education = _educationTF.text;
    task.idNo = _IDTF.text;
    task.idAddr = _frontModel.address;
    task.realName = _nameTF.text;
    task.delta = self.userModel.delta;
    task.envFile = envFile;
    task.salary = _salaryTF.text;
//    task.ocrImg = @"";
    task.marryState = _marriageTF.text;
    task.occupation = _professionTF.text;
//    task.iDPhoto = _frontModel.legality.IDPhoto;
//    task.temporaryIDPhoto = _frontModel.legality.TemporaryIDPhoto;
//    task.edited = _frontModel.legality.Edited;
//    task.photocopy = _frontModel.legality.Photocopy;
//    task.screen = _frontModel.legality.Screen;
    
    WS(weakSelf)
    uploadTask = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [weakSelf uploadSuccess];
        }else{
            [weakSelf resetFaceBtn];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
            [self fy_toastMessages:error.errorMessage];
        }
        [weakSelf resetFaceBtn];
    }];
}

- (void)resetFaceBtn {
    _faceBtn.enabled = YES;
    _faceOK.hidden = YES;
}

- (void)uploadSuccess{
    if (self.autoNext) {
        //芝麻
        [self clickZhima];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickZhima{
//    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyAproveStepZhiMa autoNext:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.approveManager loadAprroveData:self block:nil];
}

- (void)configIDFontWithModel:(FrontModel *)model{
    self.frontModel = model;
    [self setIDCellsHidden:NO];
    self.userModel.realName = _frontModel.name;
    self.userModel.idNo = _frontModel.id_card_number;
    _nameTF.text = self.userModel.realName;
    _IDTF.text = self.userModel.idNo;
    _nameTF.enabled = YES;
    _IDTF.enabled = YES;
    
    if (self.userModel.realName.length > 0 ) {
        [_IDFrontBtn setBackgroundImage:[UIImage imageWithData:self.userModel.frontImgData] forState:UIControlStateNormal];
        _idFrontOK.hidden = NO;
    }
    
    FyAffirmAlertView *alertView = [FyAffirmAlertView loadNib];
    alertView.fy_width = 300;
    alertView.fy_height = 182;
    alertView.tipLabel.text = @"信息有误将影响授信结果";
    alertView.titleKeyLabel.text = @"真实姓名";
    alertView.subTitleKeyLabel.text = @"身份证号";
    alertView.titeValueLabel.text = _frontModel.name;
    alertView.subTiteValueLabel.text = _frontModel.id_card_number;
    alertView.modifyBlock = ^{
        [self IDEditBtnClick:nil];
    };

    [alertView fy_Show];

}

//保存身份证照片
-(void)saveIDCardModel:(MGIDCardModel *)model cardType:(MGIDCardSide)cardType{
    UIImage *image = [model croppedImageOfIDCard];
    if (cardType == IDCARD_SIDE_FRONT) {
        self.userModel.frontImgData = UIImageJPEGRepresentation(image, 1);
        [self uploadIDF];
    }else {
        self.userModel.backImgData = UIImageJPEGRepresentation(image, 1);
        [_IDBackBtn setBackgroundImage:image forState:UIControlStateNormal];
        _idBackOK.hidden = NO;
    }
}


-(void)errorType:(MGLivenessDetectionFailedType)type{
    NSString *errorString;
    switch (type) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND:
        {
            errorString = @"活体检测未成功\n请按照提示完成动作";
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO:
        {
            errorString = @"活体检测未成功";
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT:
        {
            errorString = @"活体检测未成功\n请在规定时间内完成动作";
        }
            break;
        default:
        {
            errorString = @"检测失败";
        }
            break;
    }
    if (errorString) {
        [self LPShowAletWithContent:errorString dismissText:@"完成"];
    }
}

-(void)checkData{
    
    WS(weakSelf)
    NSString *errorMsg;
    
    if (!self.userModel.faceData) {
        errorMsg = @"请先进行人脸识别";
    }
    else if ((!self.userModel.frontImgData || !self.userModel.backImgData)){
        errorMsg = @"请先进行身份证识别";
    }
    else if (!_nameTF.text.length){
        errorMsg = @"请填写真实姓名";
    }
    else if (!_IDTF.text.length){
        errorMsg = @"请填写身份证号";
    }else if(![_IDTF.text isValidIDCard]){
        errorMsg = @"身份证号格式错误";
    }else if (!_educationTF.text.length){
        errorMsg = @"请选择学历";
    }
    else if (!_professionTF.text.length){
        errorMsg = @"请选择职业";
    }
    else if (!_marriageTF.text.length){
        errorMsg = @"请选择婚姻状况";
    }
    else if (!_salaryTF.text.length){
        errorMsg = @"请填入您的月收入";
    }
    else if ([_salaryTF.text integerValue] > kMaxSalary){
        errorMsg = @"金额设置为1-120000之间的整数";
    }
    else{
        [self LPShowAletWithTitle:[NSString stringWithFormat:@"请再次确认您的身份信息\n\n姓名:%@\n身份证号:%@",_nameTF.text,_IDTF.text] Content:@"" left:@"返回修改" right:@"确认提交" rightClick:^{
            [weakSelf uploadData];
        }];
    }
    if (errorMsg) {
        [self LPShowAletWithContent:errorMsg];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.autoNext) {
//        FyApproveHeaderView *view = [FyApproveHeaderView loadNib];
//        view.currentStep = 0;
//        return view;
//    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.autoNext) {
//        return 40;
//    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL cellHiden =  [self cellIsHidden:_nameCell];
    
    NSInteger index = cellHiden ? indexPath.row : indexPath.row - 2;
    pickerViewIndex = index;
    switch (index) {
        case 3:
        {
            [self configEducationalStateList];

        }
            break;
        case 4:
        {
            [self configWorkList];

        }
            break;
        case 5:
        {
            [self configMaritalStateList];

        }
            break;
        default:
            break;
    }
}

- (void)configPickerView {
    self.pickerView = [[RDPickerView alloc]initWithView:self.view.superview];
    self.pickerView.delegate = self;
    self.pickerView.pickerView.delegate = self;
    self.pickerView.pickerView.dataSource = self;
    [self.pickerView showWithAnimation:YES];
}

- (void)configEducationalStateList{
    if(_dictListModel.educationalStateList.count)
    {
        [self configPickerView];
        _selectModel = _dictListModel.educationalStateList[0];
    }else{
        [self showGif];
        [self requestDictComplete:^{
            [self hideGif];
            if(_dictListModel.educationalStateList.count){
                [self configEducationalStateList];
            }
            
        }];
    }
    
}

- (void)configWorkList {
    if(_dictListModel.workList.count)
    {
        [self configPickerView];
        _selectModel = _dictListModel.workList[0];
    }else{
        [self showGif];
        [self requestDictComplete:^{
            [self hideGif];
            if(_dictListModel.workList.count){
                [self configWorkList];
            }
            
        }];
    }
    
}

- (void)configMaritalStateList {
    if(_dictListModel.maritalStateList.count)
    {
        [self configPickerView];
        _selectModel = _dictListModel.maritalStateList[0];
    }else{
        [self showGif];
        [self requestDictComplete:^{
            [self hideGif];
            if(_dictListModel.maritalStateList.count){
                [self configMaritalStateList];
            }
            
        }];
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerViewIndex) {
        case 3:
        {
            return  _dictListModel.educationalStateList.count;
        }
            break;
        case 4:
        {
            return  _dictListModel.workList.count;
        }
            break;
        case 5:
        {
            return _dictListModel.maritalStateList.count;
        }
            break;
        default:
            break;
    }
    
    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    AuthDictModel *model;
    
    switch (pickerViewIndex) {
        case 3:
        {
            model = _dictListModel.educationalStateList[row];
        }
            break;
        case 4:
        {
            model = _dictListModel.workList[row];
        }
            break;
        case 5:
        {
            model = _dictListModel.maritalStateList[row];
        }
            break;
        default:
            break;
    }
    return model.value;
}

- (void)pickerView:(RDPickerView *)view dissmissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (pickerViewIndex == 3) {
            _selectModel = _dictListModel.educationalStateList[[view.pickerView selectedRowInComponent:0]];
            _educationTF.text = _selectModel.value;
            
        }else if (pickerViewIndex == 4) {
            _selectModel = _dictListModel.workList[[view.pickerView selectedRowInComponent:0]];
            _professionTF.text = _selectModel.value;
            
        }else if (pickerViewIndex == 5) {
            _selectModel = _dictListModel.maritalStateList[[view.pickerView selectedRowInComponent:0]];
            _marriageTF.text = _selectModel.value;
            
        }
        
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.salaryTF) {
        if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
            return NO;
        }
        if (string.length == 0) {
            return YES;
        }
        return  textField.text.length < 6;
    }
    return YES;
}

- (YMApproveManager *)approveManager {
    if (!_approveManager) {
        _approveManager = [[YMApproveManager alloc] init];
    }
    return _approveManager;
}

@end
