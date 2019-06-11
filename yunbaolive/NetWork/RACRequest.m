//
//  RACRequest.m
//  HotLove
//
//  Created by apple on 17/5/14.
//  Copyright © 2017年 才艺秀. All rights reserved.
//

#import "RACRequest.h"
#import "XMNetworking.h"
//#import "UIDevice+FCUUID.h"
#import "objc/runtime.h"
#define Server @"http://manner8.com"

@implementation RACRequest
static NSString *urlServe = @"";
/**获取app版本号*/
+ (NSString *)getVersion{
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersionStr = [appVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger appVersion = appVersionStr.integerValue;
    if(appVersion < 100){
        appVersion = appVersion *10;
    }
    return [NSString stringWithFormat:@"%ld",(long)appVersion];
}

/**配置公共参数*/
+ (void)setupConfigNeedParameters:(BOOL)need{
    Ivar ivar_1 = class_getInstanceVariable([XMCenter class], "_generalParameters");
    object_setIvar([XMCenter defaultCenter], ivar_1, nil);
    
    [XMCenter setupConfig:^(XMConfig *config) {
        config.generalServer = urlServe;
//        if ([DLMemberCenter center].token.length>0) {
//             config.generalHeaders = @{@"Authorization": [DLMemberCenter center].token};
//        }
       
        /*
        if(GGappDelegate.raUser)
        {
            NSString *auditStatus = GGappDelegate.isExamine ? @"1" : @"2";//1审核中 2非审核
            
            config.generalParameters = @{@"token": GGappDelegate.raUser.token?GGappDelegate.raUser.token:@"",@"userId":GGappDelegate.raUser.user_id?GGappDelegate.raUser.user_id:@"",@"clientType":@"苹果",@"auditStatus":auditStatus,@"clientVersion":[self getVersion],@"imei":[FCUUID uuidForDevice]};
        }else{
            NSString *auditStatus = GGappDelegate.isExamine ? @"1" : @"2";//1审核中 2非审核
            config.generalParameters = @{@"clientType":@"苹果",@"auditStatus":auditStatus,@"clientVersion":[self getVersion],@"imei":[FCUUID uuidForDevice]};
        }*/
//        if(need){
//            config.generalParameters = @{@"p":@"ios",@"app_version":[self getVersion],@"uid":@"AFFF65AA-E5B3-400D-8679-B367393848E0"};
//        }
        config.generalUserInfo = nil;
        config.callbackQueue = dispatch_get_main_queue();
        config.engine = [XMEngine sharedEngine];
#ifdef DEBUG
        config.consoleLog = YES;
#endif
    }];
}

+ (RACSignal *)postDataWithUrl:(NSString *)url server:(NSString*)server
                          dic:(NSDictionary *)parameters{
    urlServe = server;
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self class] setupConfigNeedParameters:YES];
        NSInteger status = [XMCenter defaultCenter].engine.reachabilityStatus;
        if(status==-1||status==0){
            NSError *error = [NSError errorWithDomain:@"网络不给力" code:888 userInfo:nil];
            [subscriber sendError:error];
        }

//        [XMCenter defaultCenter].engine.afJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [XMCenter sendRequest:^(XMRequest *request) {
            request.api = url;
            request.parameters = parameters;
            request.timeoutInterval = 20;
        } onSuccess:^(id responseObject) {

//            NSError *testError = [NSError errorWithDomain:@"测试异常" code:888 userInfo:nil];
//            [subscriber sendError:testError];
            //将数据捆版到signal
            NSDictionary *dic = responseObject;
            NSNumber *code = dic[@"code"];
            if (code == nil || [code intValue] == 1|| [code intValue] == 200) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }else{
                NSError *error = [NSError errorWithDomain:@"" code:[code intValue]  userInfo:nil];
                [subscriber sendError:error];
            }
        } onFailure:^(NSError *error) {
            NSLog(@"oldError = %@",error);
#if DEBUG

#else
            error = [NSError errorWithDomain:@"服务器异常！" code:999 userInfo:nil];
#endif
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^
                {
                    NSLog(@"clear up");
                }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

+ (RACSignal *)getDataWithUrl:(NSString *)url server:(NSString*)server
                           dic:(NSDictionary *)parameters{
    urlServe = server;
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self class] setupConfigNeedParameters:NO];
        NSInteger status = [XMCenter defaultCenter].engine.reachabilityStatus;
        if(status==-1||status==0){
            NSError *error = [NSError errorWithDomain:@"网络不给力" code:888 userInfo:nil];
            [subscriber sendError:error];
        }
        [XMCenter sendRequest:^(XMRequest *request) {
            request.api = url;
            request.parameters = parameters;
            request.timeoutInterval = 20;
            request.httpMethod = kXMHTTPMethodGET;
            
        } onSuccess:^(id responseObject) {
           
            NSDictionary *dic = responseObject;
            NSNumber *code = dic[@"code"];
            if (code == nil || [code intValue] == 200) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }else{
                NSError *error = [NSError errorWithDomain:@"" code:[code intValue]  userInfo:nil];
                [subscriber sendError:error];
            }
           
        } onFailure:^(NSError *error) {
            NSLog(@"oldError = %@",error);
#if DEBUG
            
#else
            error = [NSError errorWithDomain:@"服务器异常！" code:999 userInfo:nil];
#endif
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^
                {
                    NSLog(@"clear up");
                }];
    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


@end
