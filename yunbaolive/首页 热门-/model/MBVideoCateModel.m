//
//  MBVideoCateModel.m
//  yunbaolive
//
//  Created by Jolly on 27/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "MBVideoCateModel.h"

@implementation MBVideoCateModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"cateId" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}
@end
