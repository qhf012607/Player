//
//  commectDetails.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HideComment)();

@interface commectDetails : UIViewController

@property(nonatomic,copy)HideComment event;
@property(nonatomic,strong)NSDictionary *hostDic;//主人信息

@end
