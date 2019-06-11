//
//  LiveTelecastViewController.h
//  yunbaolive
//
//  Created by Jolly on 10/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

#import "ZYTabBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveTelecastViewController : UIViewController
//筛选省份  性别。。
@property(nonatomic,copy,nonnull)NSString *province;
@property(nonatomic,copy,nonnull)NSString *sex;
@property(nonatomic,copy,nonnull)NSString *biaoji;
@property(nonatomic,copy,nonnull)NSString *zhuboTitle;
@property(nonatomic,strong,nonnull) UILabel *label;
@property(nonatomic,copy,nonnull)NSString *url;
@property (nonatomic,strong,nonnull)UIView *pageView;
@end

NS_ASSUME_NONNULL_END
