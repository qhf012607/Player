//
//  YBNetworking.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "YBNetworking.h"
#import "AFNetworking.h"

@implementation YBNetworking

+(void)postWithUrl:(NSString *)url Dic:(NSDictionary *)dic Suc:(YBPullSuccessBlock)sucBack Fail:(PullFailBlock)failBack {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //NSString *pullUrl = [purl stringByAppendingFormat:@"?service=%@",url];//index.php
    [session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
            //回调
            sucBack(data,code,msg);
        }else{
            NSString *erro_fun = [self getFunName:url];
            sucBack(@{},@"9999",[NSString stringWithFormat:@"接口错误:%@-%@\n%@",number,erro_fun,[responseObject valueForKey:@"msg"]]);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
//        [MBProgressHUD showError:@"网络错误"];
        //必须判断failback是否存在
        if (failBack) {
            failBack(error);
        }
    }];
}
/**
 * 获得接口名称
 * @param url 全地址(eg:xxx/api/public/?service=Video.getRecommendVideos&uid=12470&type=0&p=1)
 * @return 返回的接口名(eg:Video.getRecommendVideos)
 */
+(NSString *)getFunName:(NSString *)url{
    if (![url containsString:@"&"]) {
        url = [url stringByAppendingFormat:@"&"];
    }
    NSRange startRange = [url rangeOfString:@"="];
    NSRange endRange = [url rangeOfString:@"&"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [url substringWithRange:range];
    return result;
}


@end
