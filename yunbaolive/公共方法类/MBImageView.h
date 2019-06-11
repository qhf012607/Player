//
//  MBImageView.h
//  MBDelagateAPP
//
//  Created by rhonin on 2018/10/12.
//  Copyright © 2018年 rhonin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBImageView : UIImageView

- (void)loadGif:(NSString*)name;

- (void)setImageUrlString:(NSString*)urlString;

- (void)setImageUrlString:(NSString*)urlString placeholoder:(NSString*)image;

@end

NS_ASSUME_NONNULL_END
