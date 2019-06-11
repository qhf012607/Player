//
//  TimerHander.m
//  ManbetX
//
//  Created by rhonin on 2019/2/14.
//  Copyright © 2019年 peale. All rights reserved.
//

#import "TimerHander.h"

@interface TimerHander()
@property(nonatomic,copy)void(^countBlock)(NSInteger);
@property(nonatomic,assign)NSInteger seconds;
@property(nonatomic,weak)dispatch_source_t timerm;
@end

@implementation TimerHander

-(void)setSeconds:(NSInteger)seconds{
    _seconds = seconds;
    if (self.countBlock) {
        self.countBlock(seconds);
    }
}

- (void)startTimer{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    self.timerm = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.seconds --;
            if (self.seconds <= 0) {
                dispatch_cancel(timer);
            }
        });
        
    });
    dispatch_resume(timer);
}

- (void)startTimer:(NSInteger)second countBlock:(void(^)(NSInteger))countblock{
    [self stop];
    self.countBlock = countblock;
    self.seconds = second;
    [self startTimer];
}

- (void)stop{
    if (self.timerm) {
         dispatch_cancel(self.timerm);
    }
    
}


@end
