//
//  anchorOnline.h
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "anchorCell.h"
@protocol anchorOnlineDelegate <NSObject>
- (void)removeShouhuView;
- (void)startLink:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_BEGIN

@interface anchorOnline : UIView<UITableViewDelegate,UITableViewDataSource,anchorCellDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITextField *searchT;
@property(nonatomic,assign)id<anchorOnlineDelegate> delegate;

- (void)show;
@end

NS_ASSUME_NONNULL_END
