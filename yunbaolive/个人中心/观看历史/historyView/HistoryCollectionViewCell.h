//
//  HistoryCollectionViewCell.h
//  yunbaolive
//
//  Created by Jolly on 06/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBHistoryListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HistoryCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UILabel *cateLab;
@property (strong, nonatomic) IBOutlet UILabel *viewsLab;
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;


- (void)config:(MBHistoryListModel *)model;

@end

NS_ASSUME_NONNULL_END
