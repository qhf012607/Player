//
//  MBHomeBannerModel.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/24.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "aWapIndex.h"
#import "aSuggestVideo.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBHomeBannerModel : NSObject
@property (nonatomic,copy)NSArray *aSuggestVideoList;

@property (nonatomic,copy)NSArray *aWapIndexSlide;

@property (nonatomic,copy)NSArray *aLiveInfoList;

@property (nonatomic,copy)NSArray *aLive;
@property (nonatomic,copy)NSArray *aVideo;
@end

NS_ASSUME_NONNULL_END
