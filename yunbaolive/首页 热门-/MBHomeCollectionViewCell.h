//
//  MBHomeCollectionViewCell.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/24.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBHomeSigleModel.h"
#import "aSuggestVideo.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet MBImageView *imageCover;
@property (weak, nonatomic) IBOutlet UILabel *cate;

- (void)config:(MBHomeSigleModel*)mode;
- (void)configVideo:(aSuggestVideo*)model;
@end

NS_ASSUME_NONNULL_END
