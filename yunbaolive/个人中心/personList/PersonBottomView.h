//
//  PersonBottomView.h
//  yunbaolive
//
//  Created by Jolly on 23/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PersonBottomViewDelegate <NSObject>

-(void)perform:(NSString *)text;

@end

@interface PersonBottomView : UIImageView
{
    UILabel *line1;
    UILabel *line2;
}
@property(nonatomic,assign)id<PersonBottomViewDelegate>BottpmViewDelegate;

//传进来的btn数组
@property (nonatomic, strong) NSArray *btnArr;
//按钮图片
@property (nonatomic, strong) NSArray *imgArr;
//num数组
@property (nonatomic, strong) NSArray *numArr;

//直播btn
@property (nonatomic, strong) UIButton *liveBtn;
//直播num
@property (nonatomic, strong) UILabel *liveNum;
//关注btn
@property (nonatomic, strong) UIButton *forceBtn;
//关注num
@property (nonatomic, strong) UILabel *forceNum;
//粉丝btn
@property (nonatomic, strong) UIButton *fanBtn;
//粉丝num
@property (nonatomic, strong) UILabel *fanNum;

-(void)setAgain:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
