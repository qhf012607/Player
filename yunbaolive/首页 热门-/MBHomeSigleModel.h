//
//  MBHomeSigleModel.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBHomeSigleModel : NSObject
@property (nonatomic,copy)NSString *time;

@property (nonatomic,copy)NSString *strtotime;

@property (nonatomic,copy)NSString *cate_name;
@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *stream;
@property (nonatomic,copy)NSString *home;

@property (nonatomic,copy)NSString *away;
@property (nonatomic,copy)NSString *streamname;

@property (nonatomic,copy)NSString *videolink;

@property (nonatomic,copy)NSString *ishd;
@property (nonatomic,copy)NSString *isinali;

@property (nonatomic,copy)NSString *thumb;

@property (nonatomic,copy)NSString *views;
@property (nonatomic,copy)NSString *href_rtmp;

@property (nonatomic,copy)NSString *href_flv;

@property (nonatomic,copy)NSString *href_m3u8;
@end

NS_ASSUME_NONNULL_END
