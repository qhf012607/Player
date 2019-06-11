//
//  MBVideoModelList.h
//  yunbaolive
//
//  Created by Jolly on 25/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBVideoModelList : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *thumb_h5;

@property (nonatomic,copy) NSString *thumb_app;
@property (nonatomic,copy) NSString *views;

@property (nonatomic,copy) NSString *cate_name;

@property (nonatomic,copy) NSString *videoId;

@property (nonatomic,copy) NSString *href;

+ (NSArray *)mj_allowedPropertyNames;

+ (NSArray *)mj_ignoredPropertyNames;
@end

NS_ASSUME_NONNULL_END
