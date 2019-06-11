//
//  AppInstanceTool.h
//  yunbaolive
//
//  Created by rhonin on 2019/5/8.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LoginNotifacation @"LoginNotifacation"

NS_ASSUME_NONNULL_BEGIN

@interface AppInstanceTool : NSObject

+ (instancetype)sharedSingleton;

@end

NS_ASSUME_NONNULL_END
