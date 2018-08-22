//
//  FyApproveContactsViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveContactsViewController.h"
#import "RDPickerView.h"
#import "UserInfoModel.h"
#import "AuthDictListModel.h"
#import "AuthDictService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FyAuthorizationUtil.h"
#import <AddressBook/AddressBook.h>
#import "NSString+fyBase64.h"
#import "FyUploadContactsRequest.h"
#import "FyApproveHeaderView.h"
#import "UIViewController+getContactInfor.h"
#import "AddressPickerView.h"
#import "NSString+Validation.h"
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import "NSString+fyAdd.h"
#import "FyApproveContactsRequest.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "FyAuthorizationUtil.h"
#import "JVFloatLabeledTextField.h"
#import "YMApproveManager.h"

@interface FyApproveContactsViewController ()<RDPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate, AddressPickerViewDelegate, AMapLocationManagerDelegate>{
    NSInteger indexPathRow;
    AuthDictModel *_selectModel;
    
//    __block NSString *_address;
//    __block  NSString *_coordinate;
}

@property (weak, nonatomic) IBOutlet UILabel *liveInAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveInAddressLabelEdited;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;


@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emergencyContactRelationShipLabelEdited;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emergencyContactNameTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emergencyContactPhoneLabelEdited;


@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *frequentContactRelationShipLabelEdited;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *frequentContactNameTF;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *frequentContactPhoneLabelEdited;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property(nonatomic,strong)RDPickerView *pickerView;

@property (nonatomic, strong) AuthDictListModel *dictListModel;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *coordinate;

@property (nonatomic ,strong) NSDictionary *dict; //选择省市

@property (strong, nonatomic)AMapLocationManager *locationManager;//定位管理者
@property (strong, nonatomic)YMApproveManager *approveManager;

@end

@implementation FyApproveContactsViewController
- (UserInfoModel *)userModel{
    if (!_userModel) {
        _userModel = [[UserInfoModel alloc] init];
    }
    return _userModel;
}

-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    if (_dict.count != 0) {
        _liveInAddressLabelEdited.text = _dict[@"address"];
        _liveInAddressLabelEdited.textColor = [UIColor textColor];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.autoNext) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.title = @"联系人认证";
    }
    [self configSubviews];
    [self requestDict];
    [self uploadUserContactsInNeed];
//    [self getCoodinate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.locationManager = nil;
    self.locationManager.delegate = nil;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configSubviews{
    _detailAddressTF.delegate = self;
    _emergencyContactNameTF.delegate = self;
    _frequentContactNameTF.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    
    [_emergencyContactRelationShipLabelEdited setPlaceholder:@"请选择紧急联系人关系" floatingTitle:@"与紧急联系人关系"];
    [_emergencyContactNameTF setPlaceholder:@"请输入紧急联系人姓名" floatingTitle:@"紧急联系人姓名"];
    [_emergencyContactPhoneLabelEdited setPlaceholder:@"紧急联系人联系方式" floatingTitle:@"联系方式"];

    [_frequentContactRelationShipLabelEdited setPlaceholder:@"请选择常用联系人关系" floatingTitle:@"与常用联系人关系"];
    [_frequentContactNameTF setPlaceholder:@"请输入常用联系人姓名" floatingTitle:@"常用联系人姓名"];
    [_frequentContactPhoneLabelEdited setPlaceholder:@"常用联系人联系方式" floatingTitle:@"联系方式"];

    _emergencyContactRelationShipLabelEdited.placeholderColor = [UIColor weakTextColor];
    _emergencyContactNameTF.placeholderColor = [UIColor weakTextColor];
    _emergencyContactPhoneLabelEdited.placeholderColor = [UIColor weakTextColor];
    _frequentContactRelationShipLabelEdited.placeholderColor = [UIColor weakTextColor];
    _frequentContactNameTF.placeholderColor = [UIColor weakTextColor];
    _frequentContactPhoneLabelEdited.placeholderColor = [UIColor weakTextColor];
    
    _emergencyContactRelationShipLabelEdited.borderStyle = UITextBorderStyleNone;
    _emergencyContactNameTF.borderStyle = UITextBorderStyleNone;
    _emergencyContactPhoneLabelEdited.borderStyle = UITextBorderStyleNone;
    _frequentContactRelationShipLabelEdited.borderStyle = UITextBorderStyleNone;
    _frequentContactNameTF.borderStyle = UITextBorderStyleNone;
    _frequentContactPhoneLabelEdited.borderStyle = UITextBorderStyleNone;

}


-(void)requestDict{
    WS(weakSelf)
    [AuthDictService requestDictWithType:AuthDictTypeContacts resultModel:^(AuthDictListModel *model, FyResponse *error) {
        if (model) {
            weakSelf.dictListModel = model;
        }
        else{
            [weakSelf fy_toastMessages:error.errorMessage];
        }
    }];
}

//上传通讯录信息
-(void)uploadMethods:(NSArray *)dataArray{
    FyUploadContactsRequest *task = [[FyUploadContactsRequest alloc] init];
    task.info = [[NSString convertToJSONData:dataArray] base64String];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf fy_toastMessages:error.errorMessage];
    }];
    
}


- (void)uploadUserContacts{
    NSMutableArray *addressBookArray = [[NSMutableArray alloc] initWithCapacity:5];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"full name = %@%@",firstName,lastName);
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (NSString*)CFBridgingRelease(ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k)));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
            NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
            [userDic setObject:[NSString stringWithFormat:@"%@%@",lastName,firstName] forKey:@"name"];
            
            NSString *phoneStr = [personPhone numberString];
            
            if (phoneStr.isNotBlank) {
                NSLog(@"personPhoneLabel = %@  personPhone = %@",personPhoneLabel,phoneStr);
                [userDic setObject:[NSString stringWithFormat:@"%@",phoneStr] forKey:@"phone"];
                NSLog(@"userDic = %@",userDic);
                
                [addressBookArray addObject:userDic];
            }
            
        }
    }
    
    [self uploadMethods:[addressBookArray copy]];
}

-(void)uploadUserContactsInNeed{
    WS(weakSelf)
    [FyAuthorizationUtil canReadAddressBookWithBlock:^(BOOL canRead, ABAuthorizationStatus authorStatus) {
        if (canRead) {
            [weakSelf uploadUserContacts];
        }else{
            [FyAuthorizationUtil showRequestAddressBookTipFromViewController:weakSelf autoPop:YES];
        }
    }];
    
}

- (void)getCoodinate {
    WS(weakSelf)
    [self getLoactionCoordinate:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [weakSelf analysisMapData:location regeocode:regeocode];
        [weakSelf hideGif];
    }];
}

- (void)analysisMapData:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode {
    _coordinate = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
    _address = regeocode.formattedAddress;
    NSLog(@"address == %@  _coordinate == %@",regeocode.formattedAddress,_coordinate);
}


- (void)getLoactionCoordinate:(AMapLocatingCompletionBlock)block{
    NSLog(@"实现分类方法");
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self setLocationManagerForHundredMeters];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:block];
}

-(void)setLocationManagerForHundredMeters{
    //1.带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //2.定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    //3.逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}


- (IBAction)doneBtnClick:(id)sender {
//#warning test
    [self uploadData];
//    [self nextStep];
}


- (void)uploadData{
    NSString *contactPhone1 = [_emergencyContactPhoneLabelEdited.text numberString];
    NSString *contactPhone2 = [_frequentContactPhoneLabelEdited.text numberString];
    
    if ([_liveInAddressLabelEdited.text isEqualToString:@"现住址"]) {
        [self fy_toastMessages:@"请选择现住址"];
    }else if (_detailAddressTF.text.length == 0) {
        [self fy_toastMessages:@"请输入详细住址"];
    }else if ([_emergencyContactRelationShipLabelEdited.text isEqualToString:@"请选择紧急联系人关系"]) {
        [self fy_toastMessages:@"请选择紧急联系人关系"];
    }else if (_emergencyContactNameTF.text.length == 0) {
        [self fy_toastMessages:@"请输入紧急联系人姓名"];
    }else if ([_emergencyContactPhoneLabelEdited.text isEqualToString:@"紧急联系人联系方式"]) {
        [self fy_toastMessages:@"请输入紧急联系人联系方式"];
    }else if(![contactPhone1 validationType:ValidationTypePhone11]){
        [self fy_toastMessages:@"联系方式必须为11位"];
    }else if ([_frequentContactRelationShipLabelEdited.text isEqualToString:@"请选择常用联系人关系"]) {
        [self fy_toastMessages:@"请选择常用联系人关系"];
    }else if (_frequentContactNameTF.text.length == 0) {
        [self fy_toastMessages:@"请输入常用联系人姓名"];
    }else if ([_frequentContactPhoneLabelEdited.text isEqualToString:@"常用联系人联系方式"]) {
        [self fy_toastMessages:@"请输入常用联系人联系方式"];
    }else if(![contactPhone2 validationType:ValidationTypePhone11]){
        [self fy_toastMessages:@"联系方式必须为11位"];
    }else if([contactPhone1 isEqualToString:contactPhone2]){
        [self fy_toastMessages:@"两个联系人信息不能相同"];
    }
    
    else {
        //发起Http请求
        [self uploadApproveData];
        
    }
    
}

- (void)uploadApproveData{
    
    FyApproveContactsRequest *task = [[FyApproveContactsRequest alloc] init];
    task.name = [NSString stringWithFormat:@"%@,%@",[_emergencyContactNameTF.text safeContactsString],[_frequentContactNameTF.text  safeContactsString]];
    task.phone = [NSString stringWithFormat:@"%@,%@",[_emergencyContactPhoneLabelEdited.text numberString],[_frequentContactPhoneLabelEdited.text numberString]];
    task.type = @"10,20";
    task.relation = [NSString stringWithFormat:@"%@,%@",[_emergencyContactRelationShipLabelEdited.text safeContactsString],[_frequentContactRelationShipLabelEdited.text safeContactsString]];
    task.liveAddr = _liveInAddressLabelEdited.text;
    task.detailAddr = _detailAddressTF.text;
    task.liveCoordinate = SAFESTRING(_coordinate);
    
    _doneBtn.enabled = NO;
    [self showGif];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        _doneBtn.enabled = YES;
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            if (weakSelf.autoNext) {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf nextStep];
            }else{
                [weakSelf LPShowAletWithContent:@"操作成功" okClick:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        }else{
            [self fy_toastMessages:error.errorMessage];
        }
            

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf hideGif];
        _doneBtn.enabled = YES;
        [weakSelf fy_toastMessages:error.errorMessage];
    }];
}

- (void)nextStep {
    [self.approveManager loadAprroveData:self block:nil];
}


#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.autoNext) {
//        FyApproveHeaderView *view = [FyApproveHeaderView loadNib];
//        view.currentStep = 3;
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    indexPathRow = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            [self selectAddressBook];
        }
            break;
        case 1:
        {
            [_detailAddressTF becomeFirstResponder];
        }
            break;
        case 3:
        {
        }
            break;
        case 4:
        {
            [self selectEmergencyContactRelationShip];
        }
            break;
            
        case 6:
        {
            [self accessAddressBook:0];
            
        }
            break;
        case 8:
        {
            [self selectCommonContactRelationShip];
        }
            break;
            
        case 10:
        {
            [self accessAddressBook:1];
        }
            break;
        default:
            break;
    }
}


- (void)selectAddressBook{
    [self getCoodinate];
    AddressPickerView *addressPickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight , kScreenWidth, 265)];
    addressPickerView.delegate = self;
    
    [addressPickerView show];
}

//选择紧急联系人
- (void)selectEmergencyContactRelationShip{
    if(self.dictListModel.kinsfolkRelationList.count)
    {
        self.pickerView = [[RDPickerView alloc]initWithView:self.view.superview];
        self.pickerView.delegate = self;
        self.pickerView.pickerView.delegate = self;
        self.pickerView.pickerView.dataSource = self;
        [self.pickerView showWithAnimation:YES];
        _selectModel = self.dictListModel.kinsfolkRelationList[0];
    }
}

- (void)selectCommonContactRelationShip{
    if(self.dictListModel.contactRelationList.count)
    {
        self.pickerView = [[RDPickerView alloc]initWithView:self.view.superview];
        self.pickerView.delegate = self;
        self.pickerView.pickerView.delegate = self;
        self.pickerView.pickerView.dataSource = self;
        [self.pickerView showWithAnimation:YES];
        _selectModel = self.dictListModel.contactRelationList[0];
    }
}

-(void)accessAddressBook:(NSInteger)index{
    [self checkAddressBookAuthorizationandGetPeopleInfor:^(NSDictionary *data) {
        NSString *name = data[@"name"];
        NSString *phone = data[@"phone"];
        if (!phone.length){
            phone = @"";
            name = @"";
        }
        if (!name.length || [name rangeOfString:@"null"].location !=NSNotFound) {
            name = phone;
        }
        
        if (index == 0) {
            _emergencyContactPhoneLabelEdited.text = phone;
            _emergencyContactPhoneLabelEdited.textColor = [UIColor textColor];
        }
        else{
            _frequentContactPhoneLabelEdited.text = phone;
            _frequentContactPhoneLabelEdited.textColor = [UIColor textColor];
            
        }
    }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (indexPathRow == 4) {
        return self.dictListModel.kinsfolkRelationList.count;
        
    }else if (indexPathRow == 8) {
        return self.dictListModel.contactRelationList.count;
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    AuthDictModel *model;
    
    if (indexPathRow == 4) {
        model = self.dictListModel.kinsfolkRelationList[row];
    }else if (indexPathRow == 8) {
        model = self.dictListModel.contactRelationList[row];
        
    }
    
    return model.value;
}
-(void)pickerView:(RDPickerView *)view dissmissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (indexPathRow == 4) {
            _selectModel = self.dictListModel.kinsfolkRelationList[[view.pickerView selectedRowInComponent:0]];
            _emergencyContactRelationShipLabelEdited.text = _selectModel.value;
            _emergencyContactRelationShipLabelEdited.textColor = [UIColor textColor];
            
        }else if (indexPathRow == 8) {
            _selectModel = self.dictListModel.contactRelationList[[view.pickerView selectedRowInComponent:0]];
            _frequentContactRelationShipLabelEdited.text = _selectModel.value;
            _frequentContactRelationShipLabelEdited.textColor = [UIColor textColor];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 50) {
        if (string.length > 0) {
            _detailAddressLabel.hidden = NO;
            _detailAddressTipLabel.hidden = YES;
        }else {
            _detailAddressLabel.hidden = YES;
            _detailAddressTipLabel.hidden = NO;
            
        }
    }
    
    return YES;
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick:(AddressPickerView *)addressPickerView{
    [addressPickerView hide];
}
- (void)addressPickerView:(AddressPickerView *)addressPickerView sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    NSString *address= [NSString stringWithFormat:@"%@%@%@",province,city,area];
    self.dict = @{@"address":address};
    [addressPickerView hide];

}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [self getCoodinate];
//    }else if(status != kCLAuthorizationStatusNotDetermined){
//    }
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self getCoodinate];
    }
}

- (YMApproveManager *)approveManager {
    if (!_approveManager) {
        _approveManager = [[YMApproveManager alloc] init];
    }
    return _approveManager;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
