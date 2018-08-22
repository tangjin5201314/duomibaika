//
//  YMHomeHeaderView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeHeaderView.h"
#import "TXScrollLabelView.h"
@interface YMHomeHeaderView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *separatorLineLabel;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *valueLab;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) UILabel *brand;
@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *memory;

@property (nonatomic, strong) UILabel *brandValue;
@property (nonatomic, strong) UILabel *typeValue;
@property (nonatomic, strong) UILabel *memoryValue;

@property (nonatomic, strong) UILabel *tipLabel;


@property (nonatomic, strong) UIButton *evaluateBtn;

@property (nonatomic, strong) UIView *noticeBarView;
@property (nonatomic, strong) UIImageView *noticeImgView;
@property (nonatomic, strong) TXScrollLabelView *scrollLab;

@property (nonatomic, strong) UIImageView *line1Img;
@property (nonatomic, strong) UIImageView *line2Img;
@property (nonatomic, strong) UIImageView *line3Img;


@end

@implementation YMHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return  self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor bgColor];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 172)];
    self.bgImageView.image = [UIImage imageNamed:@"image_bg"];
    self.bgImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kGuideViewNotification object:nil];
            });
        
    }];
    [self.bgImageView addGestureRecognizer:tap];
    
    
    [self addSubview:self.bgImageView];
    
    self.topImageView = [[UIImageView alloc] init];
//    self.topImageView.image = [UIImage imageNamed:@"home_apply_bgCard"];
    self.topImageView.userInteractionEnabled = YES;
    self.topImageView.backgroundColor = [UIColor whiteColor];
    self.topImageView.layer.cornerRadius = 10.0f;
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(152);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    //分割线
    self.separatorLineLabel = [[UILabel alloc] init];
    self.separatorLineLabel.backgroundColor = [UIColor separatorColor];
    [self.topImageView addSubview:self.separatorLineLabel];
    [self.separatorLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"出售本机最高可拿(元)";
    self.titleLab.textColor = [UIColor textColor];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.topImageView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(72);
        make.centerX.mas_equalTo(self.topImageView.centerX);
    }];
    
    self.valueLab = [[UILabel alloc] init];
    self.valueLab.text = @"4000.00";
    self.valueLab.textColor = [UIColor textColor];
    self.valueLab.font = [UIFont systemFontOfSize:44];
    self.valueLab.textAlignment = NSTextAlignmentCenter;
    [self.topImageView addSubview:self.valueLab];
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.topImageView.centerX);
    }];
    
    self.containerView = [[UIView alloc] init];
//    self.containerView.backgroundColor = [UIColor greenColor];
    [self.topImageView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLab.mas_bottom).offset(10);
        make.centerX.equalTo(self.topImageView.mas_centerX);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(110);
    }];
    
    self.phoneImageView = [[UIImageView alloc] init];
    self.phoneImageView.image = [UIImage imageNamed:@"ym_iphone"];
    [self.containerView addSubview:self.phoneImageView];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(78);
    }];
    
    self.brand = [[UILabel alloc] init];
    self.brand.text = @"品牌:";
    self.brand.font = [UIFont systemFontOfSize:14];
    self.brand.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.brand];
    [self.brand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView.mas_top);
        make.left.equalTo(self.phoneImageView.mas_right).offset(5);
        make.height.mas_equalTo(23);

    }];
    
    self.type = [[UILabel alloc] init];
    self.type.text = @"型号:";
    self.type.font = [UIFont systemFontOfSize:14];
    self.type.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.type];
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brand.mas_bottom).offset(6);
        make.left.equalTo(self.phoneImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.height.equalTo(self.brand.mas_height);

    }];
    
    self.memory = [[UILabel alloc] init];
    self.memory.text = @"内存:";
    self.memory.font = [UIFont systemFontOfSize:14];
    self.memory.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:self.memory];
    [self.memory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.type.mas_bottom).offset(6);
        make.left.equalTo(self.phoneImageView.mas_right).offset(5);
        make.height.equalTo(self.brand.mas_height);

    }];
    
    self.brandValue = [[UILabel alloc] init];
    self.brandValue.textAlignment = NSTextAlignmentCenter;
    self.brandValue.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:self.brandValue];
    [self.brandValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.brand.mas_top);
        make.left.equalTo(self.brand.mas_right).offset(10);
        make.height.equalTo(self.brand.mas_height);

    }];
    
    self.typeValue = [[UILabel alloc] init];
    self.typeValue.textAlignment = NSTextAlignmentCenter;
    self.typeValue.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:self.typeValue];
    [self.typeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.type.mas_top);
        make.left.equalTo(self.type.mas_right).offset(10);
        make.height.equalTo(self.brand.mas_height);

    }];
    
    self.memoryValue = [[UILabel alloc] init];
    self.memoryValue.textAlignment = NSTextAlignmentCenter;
    self.memoryValue.font = [UIFont systemFontOfSize:14];
    [self.containerView addSubview:self.memoryValue];
    [self.memoryValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memory.mas_top);
        make.left.equalTo(self.memory.mas_right).offset(10);
        make.height.equalTo(self.brand.mas_height);

    }];
    
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = @"出售后回租本机，您可继续使用爱机";
    self.tipLabel.textColor = [UIColor colorWithHexString:@"6197c7"];
    self.tipLabel.backgroundColor = [UIColor colorWithHexString:@"f1f8ff"];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.topImageView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.topImageView.centerX);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(230);

    }];
    
    self.evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.evaluateBtn setTitle:@"在线评估，立即拿钱" forState:UIControlStateNormal];
    [self.evaluateBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.evaluateBtn addTarget:self action:@selector(evaluateBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    self.evaluateBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [self.evaluateBtn setBackgroundImage:[UIImage imageNamed:@"btn_lmnq"] forState:UIControlStateNormal];
    [self.topImageView addSubview:self.evaluateBtn];
    [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.height.mas_equalTo(65);
    }];
    
    
    self.noticeBarView = [[UIView alloc] init];
    [self addSubview:self.noticeBarView];
    [self.noticeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(157);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    self.noticeImgView = [[UIImageView alloc] init];
    self.noticeImgView.image = [UIImage imageNamed:@"home_icon_notice"];
    [self.noticeBarView addSubview:self.noticeImgView];
    [self.noticeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(12);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    
    self.scrollLab = [[TXScrollLabelView alloc] initWithFrame:CGRectZero];
    self.scrollLab.scrollSpace = 5;
    self.scrollLab.font = [UIFont systemFontOfSize:13];
    self.scrollLab.backgroundColor = [UIColor clearColor];
    self.scrollLab.scrollType = TXScrollLabelViewTypeFlipNoRepeat;
    self.scrollLab.textAlignment = NSTextAlignmentLeft;
    self.scrollLab.scrollVelocity = 3;
    self.scrollLab.scrollTitleColor = [UIColor colorWithHexString:@"666666"];
    [self.noticeBarView addSubview:self.scrollLab];
    [self.scrollLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noticeImgView.mas_right).offset(8);
        make.right.equalTo(self.noticeBarView).offset(-15);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self drawLine];

}

- (void)displayWithModel:(FyHomeCardModel *)model {
    self.brandValue.text = model.brand;
    self.typeValue.text = model.type;
    self.memoryValue.text = model.memory;
}

- (void)displayWithPrice:(CGFloat)price imgUrl:(NSString *)url {
    self.valueLab.text = [NSString stringWithFormat:@"%.2f",price];
    [self.phoneImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ym_iphone"]];
}

- (void)setScrollLabTexts:(NSArray *)texts {
    self.scrollLab.scrollTexts = texts;
}

- (void)hiddenNoticeView:(BOOL)ret {
    self.noticeBarView.hidden = ret;
}

- (void)evaluateBtnAction {
    if (self.applyBlock) {
        self.applyBlock();
    }
}

- (void)drawLine {
    // 画虚线
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    self.line1Img = [[UIImageView alloc] initWithFrame:CGRectMake(45, 16 + 23, 150, 2)];
    self.line1Img.image = [self drawLineByImageView:self.line1Img];
    [self.containerView addSubview:self.line1Img];
    [self.line1Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brand.mas_bottom).offset(0);
        make.left.mas_equalTo(self.phoneImageView.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(2);
    }];
    
    self.line2Img = [[UIImageView alloc] initWithFrame:CGRectMake(45, 16 + 23, 150, 2)];
    self.line2Img.image = [self drawLineByImageView:self.line1Img];
    [self.containerView addSubview:self.line2Img];
    [self.line2Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.type.mas_bottom).offset(0);
        make.left.mas_equalTo(self.phoneImageView.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(2);
    }];
    
    self.line3Img = [[UIImageView alloc] initWithFrame:CGRectMake(45, 16 + 23, 150, 2)];
    self.line3Img.image = [self drawLineByImageView:self.line3Img];
    [self.containerView addSubview:self.line3Img];
    [self.line3Img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.memory.mas_bottom).offset(0);
        make.left.mas_equalTo(self.phoneImageView.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(2);
    }];
}



// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithHexString:@"dcdcdc"].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, kScreenWidth - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();

}

- (void)layoutSubviews {
    [super layoutSubviews];

}

@end
