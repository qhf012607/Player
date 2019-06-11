//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFTableData.h"
typedef void(^CellLikeBtnBlock)();
@interface ZFDouYinCell : UITableViewCell 

@property (nonatomic, strong) ZFTableData *data;

@property (nonatomic, strong) CellLikeBtnBlock cellLikeBtnBlock;

@property (nonatomic, strong) UIButton *likeBtn;

- (void)likeBtn:(CellLikeBtnBlock)block;

@end
