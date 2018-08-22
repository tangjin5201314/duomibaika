//
//  TooltipManager.h
//  ZHUKE5.0
//
//  Created by 陈浩 on 17/2/13.
//  Copyright © 2017年 beelieve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TooltipFlow.h"

@interface TooltipManager : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (TooltipManager*)sharedInstance;

@property (nonatomic, copy) NSString *cardNo;

- (void)startFlowIfNeeded:(UIViewController *)activity flowID:(NSString *)flowID;
- (BOOL)canShowNextTooltip:(UIViewController *)activity flowID:(NSString *)flowID;
- (void)onFlowDone:(TooltipFlow *)flow;
- (void)onNextClicked:(UIViewController *)activity tooltip:(Tooltip *)tooltip;
- (void)dismissTooltip:(UIViewController *)activity tooltip:(Tooltip *)tooltip;
- (void)resetAllFlows;
- (void)setMessage:(NSString *)message attributedMessage:(NSAttributedString *)attributedString forTooltip:(NSString *)tooltipID inFlow:(NSString *)flowID;

- (BOOL)isVisible;
- (void)resetFlow:(NSString *)flowID;

- (void)setDisableTooltips:(BOOL)disableTooltips;

@end
