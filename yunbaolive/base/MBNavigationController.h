//
//  QCNavigationController.h
//  QCColumbus
//
//  Created by Chen on 15/4/8.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enablePopGesture;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated enablePopGesture:(BOOL)enablePopGesture;

//禁止左滑手势
- (void)enableGestureRecognizer:(BOOL)enable;

@end

@interface UINavigationController (Identifier)
@property (nonatomic, copy) NSString *identifier;
@end

@interface UIViewController (popSupporting)

- (void)willPopSelf;

@end
