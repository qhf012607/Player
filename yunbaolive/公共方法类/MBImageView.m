//
//  MBImageView.m
//  MBDelagateAPP
//
//  Created by rhonin on 2018/10/12.
//  Copyright © 2018年 rhonin. All rights reserved.
//

#import "MBImageView.h"
#import "UIImage+GIF.h"

@implementation MBImageView

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = true;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = true;
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
     self.contentMode = UIViewContentModeScaleAspectFill;
     self.clipsToBounds = true;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = true;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = true;
    }
    return self;
}
- (void)setImageUrlString:(NSString*)urlString{
    if (urlString.length > 0) {
        NSURL *url = [NSURL URLWithString:urlString];
        [self sd_setImageWithURL:url placeholderImage:nil];
    }
}

- (void)setImageUrlString:(NSString*)urlString placeholoder:(NSString*)image{
    if (urlString.length > 0) {
    NSURL *url = [NSURL URLWithString:urlString];
    if (image) {
         [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:image]];
    }else{
         [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultPlace"]];
    }
    }
}

- (void)loadGif:(NSString*)name{
    UIImage *image = [UIImage sd_animatedGIFNamed:name];
    self.image = image;
}

@end
