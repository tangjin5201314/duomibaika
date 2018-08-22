//
//  FeedBackView.m
//  Pods
//
//  Created by hey on 2016/11/24.
//
//

#import "FeedBackView.h"
#import <Masonry/Masonry.h>
#define MaxSize 100

@interface FeedBackView ()<UITextViewDelegate>

@end

@implementation FeedBackView

-(instancetype) initFeedBackView
{
    self = [super init];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(void)createViews
{
//    self.backgroundColor = [UIColor viewBackgroundColor];

    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textColor = [UIColor textColorV2];
    [self addSubview:_textView];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.textColor = [UIColor weakTextColor];
    _tipLabel.numberOfLines = 0;
    _tipLabel.text = @"请输入您的反馈意见,我们会为您不断进步。";
    _tipLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_tipLabel];
    
    _remainLabel = [[UILabel alloc] init];
    _remainLabel.textColor = [UIColor textColorV2];
    _remainLabel.font = [UIFont systemFontOfSize:15];
    _remainLabel.text = [NSString stringWithFormat:@"0/%d",MaxSize];
    [self addSubview:_remainLabel];
    
}

-(void)createConstrains
{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.mas_equalTo(0);
        make.right.equalTo(self);
        make.bottom.mas_equalTo(0);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.right.equalTo(self).offset(-14);
        make.top.equalTo(self).offset(14);
    }];
    
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_textView).offset(-20);
        make.right.equalTo(_textView).offset(-20);
    }];
}

#pragma mark------ Text View Delegate
-(void)textViewDidBeginEditing:(UITextField *)textField
{
    _tipLabel.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        _tipLabel.hidden = NO;
    }
}

//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    
    
    NSString *toBeString = textView.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > MaxSize)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MaxSize];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:MaxSize];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MaxSize)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
        //字数限制操作
        if (textView.text.length >= MaxSize) {
            textView.text = [textView.text substringToIndex:MaxSize];
        }
        _remainLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,MaxSize];
    }
        if (self.txtBlock) {
            self.txtBlock(textView.text);
        }
}



@end
