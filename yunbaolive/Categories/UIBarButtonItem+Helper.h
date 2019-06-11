//
//  UIBarButtonItem+Helper.h
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Helper)

+ (UIBarButtonItem *)createDefaultLeftBarItemWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithImage:(NSString *)imageString target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithImage:(NSString *)imageString title:(NSString *)title  target:(id)target  action:(SEL)action titleEdgeInsets:(UIEdgeInsets)edgeInsets imageInsets:(UIEdgeInsets)imageInsets;
+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag title:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag imageString:(NSString *)imageString target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag imageString:(NSString *)imageString title:(NSString *)title  target:(id)target  action:(SEL)action titleEdgeInsets:(UIEdgeInsets)edgeInsets imageInsets:(UIEdgeInsets)imageEdgesets;

//适配xcode9 打包系统方法按钮有BUG的 方法
+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag title:(NSString *)title target:(id)target action:(SEL)action TitleColor:(UIColor*)titleColor;
@end
