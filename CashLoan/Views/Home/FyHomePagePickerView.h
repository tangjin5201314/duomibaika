//
//  FyHomePagePickerView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FyHomePagePickerView;

@protocol FYHomePagePickerDataSource <NSObject>

@optional
- (CGFloat)widthForComponent:(NSInteger)component;
- (NSTextAlignment)textAlignmentInComponent:(NSInteger)component;

@required
- (NSInteger)fyNumberOfComponent;
- (NSString *_Nonnull)titleInComponent:(NSInteger)component;
- (NSInteger)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView numberOfRowInComponent:(NSInteger)component;//某一列的行数
- (nullable NSString *)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSString *_Nonnull)withFitTitleInComponent:(NSInteger)component;

@end

@protocol FYHomePagePickerDelegate <NSObject>

@optional

- (void)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView didSelectRow:(NSInteger)row forComponent:(NSInteger)component;

@end


@interface FyHomePagePickerView : UIView

@property (nonatomic,assign)_Nonnull IBOutlet id <FYHomePagePickerDataSource> dataSource;
@property (nonatomic,assign)_Nonnull IBOutlet id <FYHomePagePickerDelegate> delegate;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animate;
- (void)selectValue:(NSString *_Nonnull)value inComponent:(NSInteger)component animated:(BOOL)animate;

- (void)reloadData;

@end
