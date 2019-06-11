//
//  VideoViewController.h
//  yunbaolive
//
//  Created by Jolly on 02/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

#import "ZYTabBar.h"

typedef void (^scrollBlock)(NSMutableArray *array,NSInteger page,NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : UIViewController
//筛选省份  性别。。
@property(nonatomic,copy,nonnull)NSString *province;
@property(nonatomic,copy,nonnull)NSString *sex;
@property(nonatomic,copy,nonnull)NSString *biaoji;
@property(nonatomic,copy,nonnull)NSString *zhuboTitle;
@property(nonatomic,strong,nonnull) UILabel *label;
@property(nonatomic,copy,nonnull)NSString *url;
@property (nonatomic,strong,nonnull)UIView *pageView;

@property(nonatomic,assign)int ismyvideo;


@end

NS_ASSUME_NONNULL_END
