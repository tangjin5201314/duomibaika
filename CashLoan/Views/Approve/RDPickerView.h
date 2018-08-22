//
//  RDPickerView.h
//  Pods
//
//  Created by Mr_zhaohy on 2016/11/24.
//
//

#import <UIKit/UIKit.h>
@class RDPickerView;
@protocol RDPickerViewDelegate <NSObject>

/**
 RDPickerView消失

 @param view RDPickerView
 @param buttonIndex 按钮索引，0:取消/点击背景，1:确定
 */
-(void)pickerView:(RDPickerView *)view dissmissWithButtonIndex:(NSInteger)buttonIndex;

@end

@interface RDPickerView : UIView

@property (nonatomic,strong)UIPickerView *pickerView;


@property (nonatomic,weak) id <RDPickerViewDelegate> delegate;

-(void)showWithAnimation:(BOOL)animation;
-(void)dissmissWithAnimation:(BOOL)animation;

-(instancetype)initWithView:(UIView *)view;

@end
