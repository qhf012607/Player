//
//  MBHistoryListModel.h
//  yunbaolive
//
//  Created by Jolly on 07/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBHistoryListModel : NSObject
@property (nonatomic,copy) NSString *title;  //标题

@property (nonatomic,copy) NSString *cate_id;  // 分类id

@property (nonatomic,copy) NSString *thumb_app;  //背景图
@property (nonatomic,copy) NSString *views;    //观看次数

@property (nonatomic,copy) NSString *videoid;  //视频id

@property (nonatomic,copy) NSString *href;   // 视频地址

@property (nonatomic,copy) NSString *likes;   // 点赞数

@property (nonatomic,copy) NSString * listid;
@end

NS_ASSUME_NONNULL_END
