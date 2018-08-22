//
//  FeedBackView.h
//  Pods
//
//  Created by hey on 2016/11/24.
//
//

#import <UIKit/UIKit.h>



@interface FeedBackView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *remainLabel;

@property (nonatomic, copy)  void(^txtBlock)(NSString *txt);

-(instancetype) initFeedBackView;
@end
