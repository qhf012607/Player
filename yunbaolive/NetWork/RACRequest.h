//
//  RACRequest.h
//  HotLove
//
//  Created by apple on 17/5/14.
//  Copyright © 2017年 Kamael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACRequest : NSObject

/**
 POST 获取数据

 @param url        请求url_api
 @param server        请求服务器地址 url
 @param parameters 请求参数

 @return 请求结果信号
 */
+ (RACSignal *)postDataWithUrl:(NSString *)url server:(NSString*)server
                           dic:(NSDictionary *)parameters;
/**
 GET 获取数据
 
 @param url        请求url
 @param parameters 请求参数
 
 @return 请求结果信号
 */
+ (RACSignal *)getDataWithUrl:(NSString *)url server:(NSString*)server
                          dic:(NSDictionary *)parameters;






@end
