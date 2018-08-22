//
//  LZKLoadingView.h
//  testWeb
//
//  Created by 李哲楷 on 16/8/3.
//  Copyright © 2016年 李哲楷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZKLoadingView : UIVisualEffectView

@property (nonatomic,strong)UIActivityIndicatorView *indicator;

- (void)stopLoading;

+ (LZKLoadingView *)showInView:(UIView *)view portrait:(BOOL)portrait;

@end
