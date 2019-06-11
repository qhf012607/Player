//
//  VideoCollectionViewCell.h
//  yunbaolive
//
//  Created by Jolly on 25/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBVideoModelList.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet MBImageView *iconImage;

@property (strong, nonatomic) IBOutlet UILabel *viewNum;
@property (strong, nonatomic) IBOutlet UILabel *videoKind;

- (void)config:(MBVideoModelList *)mode;

@end

NS_ASSUME_NONNULL_END
