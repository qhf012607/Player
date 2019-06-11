//
//  MBSuperPlayerViewController.h
//  yunbaolive
//
//  Created by rhonin on 2019/4/27.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBRootViewController.h"
#import "MBHomeSigleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBSuperPlayerViewController : MBRootViewController
@property(nonatomic,strong)NSString *livetype;
@property(nonatomic,strong)MBHomeSigleModel *model;
@end

NS_ASSUME_NONNULL_END
