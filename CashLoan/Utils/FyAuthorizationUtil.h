//
//  FyAuthorizationUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^FyAddressBookBlock)(BOOL canRead, ABAuthorizationStatus authorStatus);
typedef void(^FyCameraBlock)(BOOL canRead, AVAuthorizationStatus authorStatus);
typedef void(^FyLocationBlock)(BOOL canRead, CLAuthorizationStatus authorStatus);

@interface FyAuthorizationUtil : NSObject

//是否可以读取通讯录
+ (void)canReadAddressBookWithBlock:(FyAddressBookBlock)block;
+ (void)canReadCameraWithBlock:(FyCameraBlock)block;

+ (BOOL)allowLocation;

+ (void)showRequestCameraTipFromViewController:(UIViewController *)viewController;
+ (void)showRequestAddressBookTipFromViewController:(UIViewController *)viewController autoPop:(BOOL)pop;
+ (void)showRequestLoacationTipFromViewController:(UIViewController *)viewController autoPop:(BOOL)pop;

@end
