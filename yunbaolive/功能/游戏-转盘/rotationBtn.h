//
//  rotationBtn.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/4/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rotationBtn : UIButton

@property (strong, nonatomic) UILabel *badge;

@property(nonatomic,strong)UILabel *smallLabels;
@property(nonatomic,strong)UILabel *mysmallLabels;
/**
 *  角标显示的信息，可以为数字和文字
 */
@property (nonatomic) NSString *badgeValue;
/**
 *  角标背景颜色，默认为红色
 */
@property (nonatomic) UIColor *badgeBGColor;
/**
 *  角标文字的颜色
 */
@property (nonatomic) UIColor *badgeTextColor;
/**
 *  角标字号
 */
@property (nonatomic) UIFont *badgeFont;
/**
 *  角标的气泡边界
 */
@property (nonatomic) CGFloat badgePadding;
/**
 *  角标的最小尺寸
 */
@property (nonatomic) CGFloat badgeMinSize;
/**
 *  角标的x值
 */
@property (nonatomic) CGFloat badgeOriginX;
/**
 *  角标的y值
 */
@property (nonatomic) CGFloat badgeOriginY;
/**
 *  当角标为0时，自动去除角标
 */
@property BOOL shouldHideBadgeAtZero;
/**
 *  当角标的值发生变化，角标的动画是否显示
 */
@property BOOL shouldAnimateBadge;

-(void)removeBadge;
-(void)badgeInit;
@end
