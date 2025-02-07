//
//  TimerHander.h
//  ManbetX
//
//  Created by rhonin on 2019/2/14.
//  Copyright © 2019年 peale. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerHander : NSObject
- (void)startTimer:(NSInteger)second countBlock:(void(^)(NSInteger))countblock;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
