//
//  MBCountly.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/28.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBCountly.h"
#import "Countly.h"
@implementation MBCountly
+ (void)countPage:(NSString*)pageName{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([Config getOwnID].length > 0) {
        [dic setValue:[Config getOwnID] forKey:@"用户名"] ;
    }else{
         [dic setValue:@"游客" forKey:@"用户名"] ;
    }
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [dic setValue:version forKey:@"版本号"];
    [Countly.sharedInstance recordEvent:pageName segmentation:dic];
}
@end
