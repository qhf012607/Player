//
//  ZYTabBarController.m
//  tabbar增加弹出bar
//
//  Created by tarena on 16/7/2.
//  Copyright © 2016年 张永强. All rights reserved.
//
#import "ZYTabBarController.h"
#import "ZYTabBar.h"
//#import "Livebroadcast.h"
#import "homepageController.h"
#import "YBUserInfoViewController.h"
#import "NearVC.h"
#import "RankVC.h"
#import "myInfoEdit.h"
#import "LivePlay.h"
#import "live&VideoSelectView.h"
#import "MessageListVC.h"
//#include "TiSDKInterface.h"
#import "LiveTelecastViewController.h"
#import "MainVideoViewController.h"
#import "MBHomeViewController.h"
#import "TMineViewController.h"
#import "MBAlivePlayerViewController.h"
#import "MBNavigationController.h"
#import "MBVideoViewController.h"
#import "TCNavigationController.h"
#import "LookVideo.h"
@interface ZYTabBarController ()<ZYTabBarDelegate,UIAlertViewDelegate,liveVideoDelegate,UITabBarControllerDelegate>
{
    UIAlertView *alertupdate;
    NSString *type_val;//
    NSString *livetype;//
    UIAlertController *md5AlertController;
    NSDictionary *playDic;
    homepageController *homePage;
    live_VideoSelectView *selectView;
}
@property(nonatomic,strong)NSString *Build;

@property (nonatomic,assign) NSInteger  indexFlag;　　//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic, strong) NSMutableArray * listArray;



@end
@implementation ZYTabBarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aaaa:) name:@"jinruzhibojiantongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbbb:) name:@"system_notification" object:nil];

    self.delegate = self;
    self.dataArray = [[NSMutableArray alloc]init];
    self.urlArray = [[NSMutableArray alloc] init];
    self.listArray = [[NSMutableArray alloc] init];
    [self buildUpdate];
    //设置子视图
    [self setUpAllChildVc];
    [self configureMXtabbar];

}
- (void)configureMXtabbar {
    ZYTabBar *zytabbar = [ZYTabBar new];
    zytabbar.delegate = self;
    zytabbar.backgroundColor = [UIColor whiteColor];
     if (@available(iOS 10.0, *)) {
         [zytabbar setTintColor:[UIColor blackColor]];
         zytabbar.unselectedItemTintColor = [UIColor blackColor];
     }else{
         NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
         textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
         textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
         
         // 选中时字体颜色和选中图片颜色一致
         NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
         selectedTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
         selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
         
         // 通过appearance统一设置所有UITabBarItem的文字属性样式
         UITabBarItem *item = [UITabBarItem appearance];
         [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
         [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    }
    [self setValue:zytabbar forKeyPath:@"tabBar"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
#pragma mark  在这里更换 左右tabbar的image
- (void)setUpAllChildVc {    
    
    //首页
//    if (!homePage) {
//        homePage = [[homepageController alloc]init];
//    }
    MBHomeViewController *cont = [[MBHomeViewController alloc]init];
   
    //直播
    MBAlivePlayerViewController * liveVC = [[MBAlivePlayerViewController alloc] init];
    //视频
    MBVideoViewController * videoVC = [[MBVideoViewController alloc] init];
    RankVC *rVC = [[RankVC alloc]init];
    
//    TMineViewController * mine = [[TMineViewController alloc] init];
    //我的
    YBUserInfoViewController *userInfo = [[YBUserInfoViewController alloc] init];
    
    [self setUpOneChildVcWithVc:cont Image:@"首页" selectedImage:@"首页_2" title:@"首页"];
    [self setUpOneChildVcWithVc:liveVC Image:@"矢量智能对象" selectedImage:@"直播2" title:@"直播"];
    [self setUpOneChildVcWithVc:videoVC Image:@"shipin" selectedImage:@"shipin2" title:@"视频"];
    [self setUpOneChildVcWithVc:userInfo Image:@"wode" selectedImage:@"我的2" title:@"我的"];
    
//    [self setUpOneChildVcWithVc:mine Image:@"wode" selectedImage:@"我的2" title:@"我的"];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
     Vc.fd_prefersNavigationBarHidden = YES;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    [Vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -7)];
    [Vc.tabBarItem setImageInsets:UIEdgeInsetsMake(-5, 0, 5, 0)];

    [self addChildViewController:nav];
}
//点击开始直播
- (void)pathButton:(MXtabbar *)MXtabbar clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    WeakSelf
    [MBProgressHUD showMessage:@"正在加载"];
//    [[PRNetWork GetVideoPreferWith:@{@"showAll":@(1),@"iUid":[Config getOwnID]?[Config getOwnID]:@""}] subscribeNext:^(id x) {
//        weakSelf.dataArray = x[@"data"];
//        for (NSDictionary * hrefDic in self.dataArray) {
//            NSString * hrefStr = [hrefDic objectForKey:@"href"];
//            [weakSelf.urlArray addObject:hrefStr];
//        }
//        LookVideo *video = [[LookVideo alloc]init];
//        video.fromWhere = @"myVideoV";
//        video.curentIndex = 0;
//        video.videoList =  self.dataArray;
//        video.pages = 1;
//        //    video.firstPlaceImage = cell.thumbImageView.image;
//        video.requestUrl = self.urlArray[0];
//        video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
//            page = page;
//            self.urlArray = array;
//        };
//        video.hidesBottomBarWhenPushed = YES;
//        [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
////        [weakSelf presentViewController:video animated:YES completion:nil];
//        [MBProgressHUD hideHUD];
//    } error:^(NSError *error) {
////        [MBProgressHUD showMessage:@"加载失败"];
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"加载失败"];
//    }];
    NSString * iUid;
    if ([Config getOwnID]) {
        iUid = [NSString stringWithFormat:@"%@",[Config getOwnID]];
    }else
    {
        iUid = @"0";
    }
    NSDictionary * dic = @{@"pageNum": @(1),@"cate_id":@(0),@"iUid":iUid};
    [[PRNetWork GetVideoListWith:dic] subscribeNext:^(id x) {
          weakSelf.dataArray = [x[@"data"] objectForKey:@"aVideo"];
        for (NSArray * array in self.dataArray) {
            [weakSelf.listArray addObject:array];
        }
        for (NSDictionary * hrefDic in self.dataArray) {
            NSString * hrefStr = [hrefDic objectForKey:@"href"];
            [weakSelf.urlArray addObject:hrefStr];
        }
        LookVideo *video = [[LookVideo alloc]init];
        video.fromWhere = @"myVideoV";
        video.curentIndex = 0;
        video.videoList =  self.dataArray;
        video.pages = 1;
        video.cate = 0;
        video.requestUrl = self.urlArray[0];
        video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
            page = page;
            self.urlArray = array;
        };
        video.hidesBottomBarWhenPushed = YES;
        [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
        [MBProgressHUD hideHUD];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载失败"];
    }];
    
    NSLog(@"点击中间按钮");
}

-(void)buildUpdate{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:[NSString stringWithFormat:@"%@?service=Home.getConfig",purl] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            int code = [minstr([data valueForKey:@"code"]) intValue];
            NSArray *info = [data valueForKey:@"info"];
            if (code == 0) {
                NSDictionary *subdic = [info firstObject];
                if (![subdic isEqual:[NSNull null]]) {
//                    [TiSDK init:minstr([subdic valueForKey:@"sprout_key"])];
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *ios_shelves = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"ios_shelves"]];
                    //ios_shelves 为上架版本号，与本地一致则为上架版本,需要隐藏一些东西
                    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
                    NSString *build = [NSString stringWithFormat:@"%@",app_build];
                    if (![ios_shelves isEqual:build]) {
                        //  NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
                        //  NSLog(@"当前应用软件版本:%@",appCurVersion);
                        NSString *ipa_des = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"ipa_des"]];
                        NSNumber *build = [subdic valueForKey:@"ipa_ver"];//远程
                        NSComparisonResult r = [app_build compare:build];
                        _Build =[NSString stringWithFormat:@"%@",[subdic valueForKey:@"ipa_url"]];
                        
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:_Build forKey:@"ipa_url"];
                        [defaults setObject:ipa_des forKey:@"ipa_des"];
                        [defaults synchronize];
                        
                        if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
//                            alertupdate = [[UIAlertView alloc]initWithTitle:@"提示" message:minstr(ipa_des) delegate:self cancelButtonTitle:@"使用旧版" otherButtonTitles:@"前往更新", nil];
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                [alertupdate show];
//                            });
                        }
                    }
                    else{
                        
                        
                    }
                    NSString *maintain_switch = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"maintain_switch"]];
                    NSString *maintain_tips = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"maintain_tips"]];
                    if ([maintain_switch isEqual:@"1"]) {
                        UIAlertView *alertMaintain = [[UIAlertView alloc]initWithTitle:@"维护信息" message:maintain_tips delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [alertMaintain show];
                    }
                    liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                    [common saveProfile:commons];
                    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        [self downloadAllLevelImage:[subdic valueForKey:@"level"]];
                    });

                    //接口请求完成发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"home.getconfig" object:nil];
                }

            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0) {
            
            return;
        }
        else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_Build]];
            
        }
}
- (void)aaaa:(NSNotification *)noti{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self setSelectedIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [homePage moveToControllerAtIndex:0 animated:YES];
    });
    
//    playDic = [noti object];
//    [self checklive:minstr([playDic valueForKey:@"stream"]) andliveuid:minstr([playDic valueForKey:@"uid"])];
}
- (void)bbbb:(NSNotification *)noti{
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[MessageListVC class]]) {
            return;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MessageListVC *vc = [[MessageListVC alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
    });

}

#pragma mark ================ 检查房间类型 ===============
-(void)checklive:(NSString *)stream andliveuid:(NSString *)liveuid{
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.checkLive"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = @"post";
    NSString *param = [NSString stringWithFormat:@"uid=%@&token=%@&liveuid=%@&stream=%@",[Config getOwnID],[Config getOwnToken],liveuid,stream];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [MBProgressHUD showError:@"无网络"];
    }
    else{
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
        NSNumber *number = [dic valueForKey:@"ret"];
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [dic valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
                }
                else if ([type isEqual:@"1"]){
                    NSString *_MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    //密码
                    md5AlertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该房间为密码房间" preferredStyle:UIAlertControllerStyleAlert];
                    //添加一个取消按钮
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }]];
                    
                    //在AlertView中添加一个输入框
                    [md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.placeholder = @"请输入密码";
                    }];
                    
                    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *alertTextField = md5AlertController.textFields.firstObject;
                        //                        [self checkMD5WithText:envirnmentNameTextField.text andMD5:_MD5];
                        //输出 检查是否正确无误
                        NSLog(@"你输入的文本%@",alertTextField.text);
                        if ([_MD5 isEqualToString:[self stringToMD5:alertTextField.text]]) {
                            [self pushMovieVC];
                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:@"密码错误"];
                            [self presentViewController:md5AlertController animated:true completion:nil];
                            return ;
                        }
                        
                    }]];
                    
                    
                    //present出AlertView
                    [self presentViewController:md5AlertController animated:true completion:nil];
                    
                    
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:minstr([info valueForKey:@"type_msg"]) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];
                        
                    }];
                    [alertContro addAction:cancleAction];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self doCoastRoomCharge];
                    }];
                    [alertContro addAction:sureAction];
                        [self presentViewController:alertContro animated:YES completion:nil];
                }
                
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
    }
    
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
//执行扣费
-(void)doCoastRoomCharge{
    [YBToolClass postNetworkWithUrl:@"Live.roomCharge" andParameter:@{@"liveuid":minstr([playDic valueForKey:@"uid"]),@"stream":minstr([playDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            [self pushMovieVC];
            //计时扣费
            
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }

    } fail:^{
        
    }];
   
}
-(void)pushMovieVC{
    
    moviePlay *player = [[moviePlay alloc]init];
    player.playDoc = playDic;
    player.type_val = type_val;
    player.livetype = livetype;
    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == tabBarController.childViewControllers[3]) {
        if ([Config getOwnID]) {
            return true;
        }else{
            
            return false;
        }
    }
    return true;
    
  
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index == 3) {
        if ([Config getOwnID]) {
            //  self.tabBarController.selectedIndex = 3;
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:LoginNotifacation object:nil];
            return;
        }
    }
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
    
        //添加动画
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue = [NSNumber numberWithFloat:0.9];   //初始伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1.1];     //结束伸缩倍数
    
        [[arry[index] layer] addAnimation:animation forKey:nil];
        self.indexFlag = index;
    }
}


- (void)downloadAllLevelImage:(NSArray *)arr{
    for (NSDictionary *dic in arr) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        }];
        
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    [super setSelectedIndex:selectedIndex];
    
    self.indexFlag = selectedIndex;
}

#pragma mark ================ 视频直播选择视图代理 ===============
-(void)clickLive:(BOOL)islive{
    if (islive) {
//        Livebroadcast *start = [[Livebroadcast alloc]init];
//        [[MXBADelegate sharedAppDelegate] pushViewController:start animated:YES];

    }else{
//        TCVideoRecordViewController *video = [[TCVideoRecordViewController alloc]init];
//        [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
    }
    [self hideSelctView];
}
-(void)hideSelctView{
    [selectView removeFromSuperview];
    selectView = nil;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 设置启动时TabBar Y值以适配iPhone X
- (void)viewWillLayoutSubviews{
    if (KiPhoneXSeries) {
        CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
        tabFrame.size.height = 80;
        tabFrame.origin.y = self.view.frame.size.height - 80;
        self.tabBar.frame = tabFrame;
    }
}
@end
