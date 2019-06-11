//
//  DHNetWork.m
//  MXProject
//
//  Created by Kamael on 2018/7/7.
//  Copyright © 2018年 olin. All rights reserved.
//

#import "PRNetWork.h"
#import "QNMD5.h"

@implementation PRNetWork

+ (RACSignal *)countLivePlayWith:(NSDictionary *)dict{
    NSString *url = @"/v1/liveDetails";
    return   [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }] ;
}

/** 首頁列表 */
+ (RACSignal *)GetHomeListWith:(NSDictionary *)dict{
    NSString *url = @"/api/kantv/playlist";
    return   [[RACRequest postDataWithUrl:url server:curl dic:nil] map:^id(id value) {
        return value;
    }] ;
}

/** 轮播图 */
+ (RACSignal *)GetLunBoWith:(NSDictionary *)dict{
    NSString *url = @"/v1/wapIndex";
    return   [[RACRequest postDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }] ;
}

/** 直播分类 */
+ (RACSignal *)GetAliveCate:(NSDictionary *)dict{
    NSString *url = @"/v1/wapVideoLiveCate";
    return   [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }] ;
}

/** 直播列表 */
+ (RACSignal *)GetAliveList:(NSDictionary *)dict{
    NSString *url = @"/v1/liveData";
//    NSLog(@"%@     ,,,,, %@",[dict getSecretKey],[NSDictionary getNowTimeTimestamp]);
    return   [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }] ;
}


/** 轮播图 */
//+ (RACSignal *)GetHomeListWith:(NSDictionary *)dict{
//    NSString *url = @"/api/kantv/playlist";
//    return   [[RACRequest postDataWithUrl:url dic:dict] map:^id(id value) {
//        return value;
//    }] ;
//}
/**视频界面列表*/
+ (RACSignal *)GetVideoListWith:(NSDictionary *)dict{
    NSString * url = @"/v1/wapVideo";
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}
/**视频界面分类按钮*/
+ (RACSignal *)GetVideoCateWith:(NSDictionary *)dict {
    NSString * url = @"/v1/wapVideoLiveCate";
//    NSDictionary * dic = @{@"timeStamp":@"1553738873",@"secretKey":@"3595cd9fbafa3b04ac72368f4d494ceb"};
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}
/**视频详情页*/
+ (RACSignal *)GetVideoDetailsWith:(NSDictionary *)dict {
    NSString * url = @"/v1/wapVideoDetails";
    
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}

/**视频点赞*/
+ (RACSignal *)GetVideoGiveLikesWith:(NSDictionary *)dict {
    NSString * url = @"/v1/giveLikes";
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}

/**浏览历史列表*/
+ (RACSignal *)GetHistoryListhWith:(NSDictionary *)dict {
    NSString * url = @"/v1/historyLikesList";
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}

/**删除历史*/
+ (RACSignal *)GetDeleteHistoryWith:(NSDictionary *)dict {
    NSString * url = @"/v1/wapDelView";
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}

/**猜你喜欢**/
+ (RACSignal *)GetVideoPreferWith:(NSDictionary *)dict
{
    NSString * url = @"/v1/videoPrefer";
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
    
}

+ (RACSignal *)loginWithDic:(NSDictionary *)dict{
    NSString *url = @"Login.userLogin";
    NSString *requestUrl = [NSString stringWithFormat:@"api/public/?service=%@",url];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([Config getOwnID]),@"uid",minstr([Config getOwnToken]),@"token", nil];
    [pDic addEntriesFromDictionary:dict];
    return   [[RACRequest postDataWithUrl:requestUrl server:curl dic:pDic] map:^id(id value) {
        return value;
    }] ;
}


+ (RACSignal *)searchKeyWork:(NSDictionary *)dict{
    NSString *url = @"v1/search";
   
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}


+ (RACSignal *)searchMore:(NSDictionary *)dict{
    NSString *url = @"v1/moresearch";
    
    return [[RACRequest getDataWithUrl:url server:curl dic:[dict getSecretKey]] map:^id(id value) {
        return value;
    }];
}


+(NSString*)getErrorString:(NSInteger)code{
    NSDictionary *dic = @{@"1001":@"系统错误，请重试",@"3000":@"日期范围错误，请查询三个月内记录",@"3001":@"日期不能为空",@"3002":@"日期格式错误",@"3003":@"数字显示格式错误",@"3004":@"旧密码错误",@"3006":@"登录失败",@"3007":@"已读失败",@"3008":@"删除失败",@"4000":@"不被授权",@"9000":@"未知错误",@"888":@"网络异常",@"999":@"服务器异常"};
    NSString *codestring = [NSString stringWithFormat:@"%ld",(long)code];
    NSString *errorString = [dic valueForKey:codestring];
    return errorString;
}

@end




@implementation NSDictionary (sort)

- (NSDictionary*)getSecretKey{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self];
    [dic setValue:[NSDictionary getNowTimeTimestamp] forKey:@"timeStamp"];
    [dic setValue:[dic sortedParam] forKey:@"secretKey"];
    NSDictionary *dicN = dic;
    return dicN;
}
- (NSString*)sortedParam{
    NSArray *keyArray = [self allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[self objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *timeSamp = [NSDictionary getNowTimeTimestamp];
  
    NSString *sign = [NSString stringWithFormat:@"977695322249140a2cce0803e2657052%@%@",[signArray componentsJoinedByString:@"&"],timeSamp];
    
    return [QNMD5 MD5:sign];
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}
@end
