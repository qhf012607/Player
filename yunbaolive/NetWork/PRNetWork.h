//
//  DHNetWork.h
//  MXProject
//
//  Created by Kamael on 2018/7/7.
//  Copyright © 2018年 olin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACRequest.h"
NS_ASSUME_NONNULL_BEGIN
@interface PRNetWork : NSObject



/**
 首頁列表

 @param dict
 @return data
 */
+ (RACSignal *)GetHomeListWith:(NSDictionary *)dict;




/**
 获取轮播图

 @param
 @return dic
 */
+ (RACSignal *)GetLunBoWith:(NSDictionary *)dict;



/**
 获取直播分类
 
 @param
 @return dic
 */

+ (RACSignal *)GetAliveCate:(NSDictionary *)dict;

/**
 获取直播列表
 
 @param
 @return dic
 */

+ (RACSignal *)GetAliveList:(NSDictionary *)dict;


/**
搜索
 */
+ (RACSignal *)searchKeyWork:(NSDictionary *)dict;



/**
 搜索更多

 @param dict
 @return
 */
+ (RACSignal *)searchMore:(NSDictionary *)dict;

/**
 视频列表

 @param 
 @return
 */
+ (RACSignal *)GetVideoListWith:(NSDictionary *)dict;

/**
 直播计数
 
 @param
 @return
 */
+ (RACSignal *)countLivePlayWith:(NSDictionary *)dict;


/**
 视频列表分类

 @param dict
 @return 
 */
+ (RACSignal *)GetVideoCateWith:(NSDictionary *)dict;


/**

 登录
 
 @param dict
 @return
 */
+ (RACSignal *)loginWithDic:(NSDictionary *)dict;


/**

 视频详情
 */
+ (RACSignal *)GetVideoDetailsWith:(NSDictionary *)dict;


/**
 视频点赞
 */
+ (RACSignal *)GetVideoGiveLikesWith:(NSDictionary *)dict;

/**
 浏览历史列表
 */
+ (RACSignal *)GetHistoryListhWith:(NSDictionary *)dict;

/**
 删除历史
 */
+ (RACSignal *)GetDeleteHistoryWith:(NSDictionary *)dict;



 
 /**
 猜你喜欢
 */
+ (RACSignal *)GetVideoPreferWith:(NSDictionary *)dict;
/**
 获取错误提示
 
 @param code 错误码
 @return 错误提示
 */
+(NSString*)getErrorString:(NSInteger)code;

@end
NS_ASSUME_NONNULL_END


@interface NSDictionary (sort)
- (NSDictionary*_Nullable)getSecretKey;
+(NSString *_Nullable)getNowTimeTimestamp;  ///时间戳

- (NSString*_Nullable)sortedParam;  //加密
@end

