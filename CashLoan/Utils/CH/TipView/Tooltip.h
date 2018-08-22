//
//  Tooltip.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/10.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TooltipFlow;

@interface Tooltip : NSObject

@property(nonatomic, weak) TooltipFlow *flow;
@property (nonatomic, strong) NSString *messageRes;
@property (nonatomic, strong) NSAttributedString *attributedMessageRes;
@property (nonatomic, strong) NSString *anchorViewId;


- (Tooltip *)initWithFlow:(TooltipFlow *)flow res:(NSString *)res anchorViewId:(NSString *)anchorViewId;

//public TooltipLayout createView(Activity activity) {
//    TooltipLayout layout = (TooltipLayout) activity.getLayoutInflater().inflate(R.layout.tooltip_layout, null);
//    layout.setTooltip(this);
//    return layout;
//}

- (UIView *)getAnchorView:(UIViewController *)inViewController;

@end
