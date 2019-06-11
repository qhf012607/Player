//
//  exoensiveGifGiftV.m
//  yunbaolive
//
//  Created by Boom on 2018/10/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "exoensiveGifGiftV.h"
#import <YYWebImage/YYWebImage.h>
@implementation exoensiveGifGiftV{
}

-(instancetype)initWithGiftData:(NSDictionary *)giftData{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self creatUIWithGiftData:giftData];
    }
    return self;
}
- (void)creatUIWithGiftData:(NSDictionary *)giftData{
    UIImageView *imgView = [YYAnimatedImageView new];
    imgView.frame = CGRectMake(0, 0, _window_width, _window_height);
    imgView.yy_imageURL = [NSURL URLWithString:minstr([giftData valueForKey:@"swf"])];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgView];
    CGFloat seconds = [[giftData valueForKey:@"swftime"] floatValue];

    NSString *titleStr = [NSString stringWithFormat:@"%@ 送了一个%@",minstr([giftData valueForKey:@"nicename"]),minstr([giftData valueForKey:@"giftname"])];
    CGFloat titleWidth = [[YBToolClass sharedInstance] widthOfString:titleStr andFont:[UIFont systemFontOfSize:14] andHeight:30];
    UIImageView *titleBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width, 110, 35+titleWidth+20, 30)];
    titleBackImgView.image = [UIImage imageNamed:@"moviePlay_title"];
    titleBackImgView.alpha = 0.5;
    titleBackImgView.layer.cornerRadius = 15;
    titleBackImgView.layer.masksToBounds = YES;
    [self addSubview:titleBackImgView];
    UIImageView *laba = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
    laba.image = [UIImage imageNamed:@"豪华礼物提示.png"];
    [titleBackImgView addSubview:laba];
    UILabel *titL = [[UILabel alloc]initWithFrame:CGRectMake(laba.right+10, 0, titleWidth+20, 30)];
    titL.text = titleStr;
    titL.textColor = [UIColor whiteColor];
    titL.font = [UIFont systemFontOfSize:14];
    [titleBackImgView addSubview:titL];
    [UIView animateWithDuration:seconds/4 animations:^{
        titleBackImgView.alpha = 1;
        titleBackImgView.x = 10;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds*0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:seconds/4 animations:^{
            titleBackImgView.alpha = 0;
            titleBackImgView.x = -_window_width;
        } completion:^(BOOL finished) {
            [titleBackImgView removeFromSuperview];
        }];
        
    });

}
@end
