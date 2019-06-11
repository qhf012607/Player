//
//  VideoCollectionViewCell.m
//  yunbaolive
//
//  Created by Jolly on 25/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)config:(MBVideoModelList *)mode{
    
//    [self.iconImage setImageUrlString:mode.thumb_app];
    //    self.imageCover.backgroundColor = [UIColor redColor];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.clipsToBounds  = YES;//是否剪切掉超出 UIImageView 范围的图片
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:mode.thumb_app] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLab.text = mode.title;
    self.viewNum.text = mode.views;
    self.videoKind.text = mode.cate_name;
    
}
@end
