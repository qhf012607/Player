//
//  MBHomeModel.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBHomeModel : NSObject

@property (nonatomic,copy)NSArray *recommend;

@property (nonatomic,copy)NSArray *latest;

@property (nonatomic,copy)NSArray *hot;



@end

NS_ASSUME_NONNULL_END
