//
//  MBVideoDetailModel.h
//  yunbaolive
//
//  Created by Jolly on 06/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBVideoDetailModel : NSObject
@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *thumb_app;
@property (nonatomic,copy)NSString *href;

@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *views;
@property (nonatomic,copy)NSString *comments;
@property (nonatomic,copy)NSString *existLike;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *user_nicename;


@end

NS_ASSUME_NONNULL_END
