//
//  SYPasswordView.m
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "SYPasswordView.h"
#import "HexColor.h"
#import "NSString+Validation.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
@interface SYPasswordView ()

@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) UIView *cursor;


@end

@implementation SYPasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
    }
    return self;
}

- (void)makeLineRed:(BOOL)red{
    UIColor *lineColor = red ? [UIColor colorWithHexString:@"#FB2205"] : [UIColor colorWithHexString:@"#333333"];
    
    for (UIView *line in self.lineArray) {
        line.backgroundColor = lineColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(0, 0, self.frame.size.width, K_Field_Height);
    
    CGFloat width = self.frame.size.width / kDotCount;
    CGFloat space = 10;

    for (NSInteger i = 0; i < self.lineArray.count; i++) {
        UIView *lineView = self.lineArray[i];
        lineView.frame = CGRectMake(CGRectGetMinX(self.textField.frame) + i * width+space, K_Field_Height, width-2*space, 1);
    }
    
    for (NSInteger i = 0; i < self.dotArray.count; i++) {
        UIView *dotView = self.dotArray[i];
        dotView.frame = CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height);
    }
    UIView *dotV = self.dotArray[0];
    self.cursor.center = dotV.center;
}
- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = self.frame.size.width / kDotCount;
    CGFloat space = 10;

    self.dotArray = [[NSMutableArray alloc] init];
    self.lineArray = [[NSMutableArray alloc] init];

    //生成分割线
    for (int i = 0; i < kDotCount; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + i * width+space, K_Field_Height, width-2*space, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:lineView];
        [self.lineArray addObject:lineView];
    }
    
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
    
    self.cursor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, K_Field_Height-20)];
    self.cursor.backgroundColor = [UIColor grayColor];
    [self.cursor.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    [self addSubview:self.cursor];
}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }else if(![string validationExpression:@"^\\d{1}"]){ //非数字
        return NO;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    
    UIView *nexDot = self.dotArray.count>textField.text.length ? self.dotArray[textField.text.length] : nil;
    if (nexDot) {
        self.cursor.hidden = NO;
        self.cursor.center = nexDot.center;
    }else{
        self.cursor.hidden = YES;
    }
    
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
        if (self.allPasswordPut) {
            if (textField.text.length>=6) {
                self.allPasswordPut([textField.text substringToIndex:6]);
            }
        }
    }
    if (textField.text.length < kDotCount) {
        if (self.textChange) {
            self.textChange();
        }
    }
    
}

#pragma mark - init

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
//        _textField.layer.borderColor = [[UIColor colorWithHexString:@"#dddddd"] CGColor];
//        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

@end
