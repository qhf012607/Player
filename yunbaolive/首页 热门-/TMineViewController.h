//
//  TMineViewController.h
//  yunbaolive
//
//  Created by Jolly on 27/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMineViewController : UIViewController
@property (nonatomic, strong) NSMutableArray * videoUrlArr;
- (void)playTheIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
