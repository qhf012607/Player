//
//  MBRootViewController.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBRootViewController : UIViewController
@property(nonatomic,strong)UIView *navigateViewWithSeach;


- (void)hiddenNodataView;
/**
 无数据页面

 @param noDatamsg 描述
 */
- (void)showNodata:(NSString*)noDatamsg;

/**
 网络错误提示页

 @param refresh 点击重新加载
 */
-(void)nothingview:(void(^)())refresh;


/**
 默认头部导航

 @param search
 */
- (void)addNavigatView:(void(^)(NSString *text))search;
-(void)buildUpdate;

/**
 默认返回按钮
 
 @param search
 */
- (UIButton*)addBackButtonWithoutNavBar;



/**
 旋转

 @param fullscreen 
 */
- (void)setNewOrientation:(BOOL)fullscreen;

- (void)pop;
@end

NS_ASSUME_NONNULL_END
