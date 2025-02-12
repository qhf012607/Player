//
//  JPIMMore.h
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddBtnDelegate <NSObject>
@optional
- (void)photoClick;
- (void)cameraClick;
-(void)voiceInputClick;
-(void)locationClick;

@end
@interface JCHATMoreView : UIView
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;

@property (weak, nonatomic) IBOutlet UIButton *voiceInputBtn;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (assign, nonatomic)  id<AddBtnDelegate>delegate;

@end


@interface JCHATMoreViewContainer : UIView
@property (strong, nonatomic) JCHATMoreView *moreView;

@end
