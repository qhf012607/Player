//
//  aSuggestVideo.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/24.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "aSuggestVideo.h"

@implementation aSuggestVideo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end
