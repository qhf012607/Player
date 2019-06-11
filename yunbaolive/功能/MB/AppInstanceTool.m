
//
//  AppInstanceTool.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/8.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "AppInstanceTool.h"
#import "LoginAndRegisterViewController.h"
#import "TCNavigationController.h"
#import "Countly.h"
@implementation AppInstanceTool
#define kCountlyHost @"http://countly.manbetlegend.com"
#define kCountlyAppKey @"c2beb9d47eb6e45d7f2f0eabb9e3cefede0d579a"

+ (instancetype)sharedSingleton {
    static AppInstanceTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpTologin) name:LoginNotifacation object:nil];
        
        CountlyConfig* config = CountlyConfig.new;
        config.appKey = kCountlyAppKey;
        config.host = kCountlyHost;
#if DEBUG
        config.enableDebug = YES;
#endif
        config.features = @[CLYCrashReporting,CLYAutoViewTracking];
        
        [Countly.sharedInstance startWithConfig:config];
    }
    return self;
}

- (void)jumpTologin{
    LoginAndRegisterViewController *login = [[LoginAndRegisterViewController alloc]init];
    login.fd_prefersNavigationBarHidden = true;
    TCNavigationController *nav = [[TCNavigationController alloc]initWithRootViewController:login];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).tab presentViewController:nav animated:true completion:nil];
}


@end
