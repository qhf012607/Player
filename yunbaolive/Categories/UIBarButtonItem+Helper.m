//
//  UIBarButtonItem+Helper.m
//  QCColumbus
//
//  Created by Chen on 15/4/15.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "UIBarButtonItem+Helper.h"

#import "NSString+Calculation.h"
@implementation UIBarButtonItem (Helper)

+ (UIBarButtonItem *)createDefaultLeftBarItemWithTarget:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
   // button.backgroundColor = [UIColor redColor];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 32)];
    [button setTitle:@"" forState:UIControlStateNormal];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)createItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [self createItemWithTag:nil title:title target:target action:action];
}

+ (UIBarButtonItem *)createItemWithImage:(NSString *)imageString target:(id)target action:(SEL)action {
    return [self createItemWithTag:nil imageString:imageString target:target action:action];
}

+ (UIBarButtonItem *)createItemWithImage:(NSString *)imageString title:(NSString *)title  target:(id)target  action:(SEL)action titleEdgeInsets:(UIEdgeInsets)edgeInsets imageInsets:(UIEdgeInsets)imageInsets {
    return  [self createItemWithTag:nil imageString:imageString title:title target:target action:action titleEdgeInsets:edgeInsets imageInsets:imageInsets];
}

+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag title:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *item;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect rectToFit = [title calculateLabelRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:font];
    btn.frame = CGRectMake(0, 0, rectToFit.size.width, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.accessibilityIdentifier = tag;
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag title:(NSString *)title target:(id)target action:(SEL)action TitleColor:(UIColor*)titleColor {
    UIBarButtonItem *item;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    CGRect rectToFit = [title calculateLabelRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:font];
    btn.frame = CGRectMake(0, 0, rectToFit.size.width, 44);
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
  //  [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.accessibilityIdentifier = tag;
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)createItemWithTag:(NSString *)tag imageString:(NSString *)imageString target:(id)target action:(SEL)action{
    UIBarButtonItem *item;
    UIImage *image = [UIImage imageNamed:imageString];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width, 44);
    [btn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.accessibilityIdentifier = tag;
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}


@end
