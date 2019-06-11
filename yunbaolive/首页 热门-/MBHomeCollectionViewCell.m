
//
//  MBHomeCollectionViewCell.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/24.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBHomeCollectionViewCell.h"

@implementation MBHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageCover.layer.cornerRadius = 4;
}


- (void)config:(MBHomeSigleModel*)mode{
    [self.imageCover setImageUrlString:mode.thumb placeholoder:@"placeholder"];
//    self.imageCover.backgroundColor = [UIColor redColor];
    self.leftLab.text = mode.title;
    self.rightLab.text = mode.views;
    self.cate.text = mode.cate_name;
}


- (void)configVideo:(aSuggestVideo*)model{
     [self.imageCover setImageUrlString:model.thumb_app placeholoder:@"placeholder"];
    self.leftLab.text = model.title;
    self.rightLab.text = model.views;
    self.cate.text = model.cate_name;
}
@end
