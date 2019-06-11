//
//  MainCollectionReusableView.h
//  Mbb
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 WHSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainPushDelegate <NSObject>

- (void)pushNextView:(NSInteger)kind;
- (void)pushGoodsDetailsView:(NSString *)goodsID withKind:(NSString *)kind;

@end

@interface MainCollectionReusableView : UICollectionReusableView

- (void)WithImgs:(NSArray *)imgArr WithAddress:(NSString *)Address;
@property (nonatomic, weak) id <MainPushDelegate> delegate;

@end
