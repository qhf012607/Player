//
//  aSuggestVideo.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/24.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface aSuggestVideo : NSObject
@property (nonatomic,copy)NSString *ID;

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *thumb_h5;
@property (nonatomic,copy)NSString *thumb_app;
@property (nonatomic,copy)NSString *href;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *cate_name;
@property (nonatomic,copy)NSString *views;
@property (nonatomic,copy)NSString *likes;
@property (nonatomic,copy)NSString *virtual_views;
@property (nonatomic,copy)NSString *existLike;
@property (nonatomic,copy)NSString *comments;
@end

NS_ASSUME_NONNULL_END
