//
//  FyHomeActionView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeActionView.h"
#import "FyBannerModelV2.h"

@interface FyHomeActionView()


@end

@implementation FyHomeActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)handleAciton:(UIButton *)sender{
    if (self.homeActionBlock) {
        self.homeActionBlock(sender.tag - 1000);
    }
}

- (void)setBanners:(FyHomeActionBannersModel *)banners{
    if (_banners != banners) {
        _banners = banners;
        
        [self configBanners];
    }
}

- (void)configBanners{
    UILabel *label1 = [self viewWithTag:3000];
    UILabel *label2 = [self viewWithTag:3001];
    UILabel *label3 = [self viewWithTag:3002];

    UIImageView *image1 = [self viewWithTag:2000];
    UIImageView *image2 = [self viewWithTag:2001];
    UIImageView *image3 = [self viewWithTag:2002];
    
    label1.text = @"认证中心";
    label2.text = @"帮助中心";
    label3.text = @"借款攻略";

    image1.image = [UIImage imageNamed:@"home_icon_ID"];
    image2.image = [UIImage imageNamed:@"home_icon_help"];
    image3.image = [UIImage imageNamed:@"home_icon_raiders"];
    
    NSMutableArray *banners = [@[] mutableCopy];
    [banners addObject:(self.banners.leftBanner ?: [NSNull null])];
    [banners addObject:(self.banners.centerBanner ?: [NSNull null])];
    [banners addObject:(self.banners.rightBanner ?: [NSNull null])];

    for (NSInteger i = 0; i < banners.count; i++) {
        FyBannerModelV2 *banner = banners[i];
        if ([banner isKindOfClass:[NSNull class]]) continue;
        UILabel *label = [self viewWithTag:3000+i];
        UIImageView *imageV = [self viewWithTag:2000+i];

        UIImage *planceholder = [UIImage imageNamed:@"home_icon_ID"];
        if (i == 1) {
            planceholder = [UIImage imageNamed:@"home_icon_help"];
        }
        if (i == 2) {
            planceholder = [UIImage imageNamed:@"home_icon_raiders"];
        }

        
        label.text = banner.title;
        if (banner.icon.length) {
            [imageV sd_setImageWithURL:[NSURL URLWithString:banner.icon] placeholderImage:planceholder];
        }
    }

}

@end
