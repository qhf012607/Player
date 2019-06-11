
//
//  MBHomeModel.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBHomeModel.h"

@implementation MBHomeModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"recommend" : @"MBHomeSigleModel",@"latest":@"MBHomeSigleModel",@"hot":@"MBHomeSigleModel"};
}
@end
