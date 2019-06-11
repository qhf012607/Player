//
//  ZYTabBar.m
//  自定义tabbarDemo
//
//  Created by tarena on 16/7/1.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ZYTabBar.h"
#import "UIView+LBExtension.h"
#import <objc/runtime.h>

#define ZYMagin 30
@interface ZYTabBar ()<MXtabbarDelegate>
@property(nonatomic,strong)MBImageView *image;
@end
@implementation ZYTabBar
@dynamic delegate;
- (instancetype)init{
    if (self = [super init]) {
        if (!self.plusBtn) {
            
            self.plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55, 55)];
           // self.plusBtn.delegate = self;
            [self.plusBtn setBackgroundImage:[UIImage imageNamed:@"playNowBack"] forState:UIControlStateNormal];
            self.image = [[MBImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            self.image.image = [UIImage imageNamed:@"bofang"];
            [self.plusBtn addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside];
//            [self setUpPathButton:self.plusBtn];
            //必须加到父视图上
            [self addSubview:self.plusBtn];
               [self addSubview:self.image];
            //        UILabel *label = [[UILabel alloc]init];
            //        label.text = @"发布";
            //        label.font = [UIFont systemFontOfSize:13];
            //        //[label sizeToFit];
            //        label.textColor = [UIColor grayColor];
            //        label.centerX = _plusBtn.centerX;
            //        label.centerY = CGRectGetMaxY(_plusBtn.frame) + ZYMagin;
            //        [self.superview addSubview:label];
        }
    }
    return self;
}

//重新绘制按钮
- (void)layoutSubviews {
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton,找出这些类型的按钮,然后重新排布位置 ,空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
           //每一个按钮的宽度 == tabbar的五分之一
            btn.width = self.width/5;
            btn.x = btn.width * btnIndex;
            btn.y = 5;
            btnIndex ++;
            //如果是索引是1(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
                
            }
        }
    }
    NSInteger x = 0;
    if (iPhoneX) {
        x = 34/2;
    }
    self.plusBtn.centerX = self.width/2 ;
    self.plusBtn.centerY = self.height/2 - 10 - x;
    self.image.center = self.plusBtn.center;
}

- (void)addButton{
    if ([self.delegate respondsToSelector:@selector(pathButton:clickItemButtonAtIndex:)]) {
        [self.delegate pathButton:self clickItemButtonAtIndex:0];
    }
}
- (void)pathButton:(MXtabbar *)MXtabbar clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    
    if ([self.delegate respondsToSelector:@selector(pathButton:clickItemButtonAtIndex:)]) {
        [self.delegate pathButton:self clickItemButtonAtIndex:itemButtonIndex];
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
     CGPoint newA = [self convertPoint:point toView:self.plusBtn];
    if (self.isHidden) {
         return [super hitTest:point withEvent:event];
    }
    if ( [self.plusBtn pointInside:newA withEvent:event])
    {
        return self.plusBtn;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
@end















