#import "YBUserInfoViewController.h"
#import "YBUserInfoListTableViewCell.h"
#import "YBPersonTableViewCell.h"
#import "YBPersonTableViewModel.h"
#import "LiveNodeViewController.h"
#import "fansViewController.h"
#import "attrViewController.h"
#import "myInfoEdit.h"
#import "setView.h"
#import "myProfitVC.h"
//#import "CoinVeiw.h"
#import "webH5.h"
#import "market.h"
#import "equipment.h"
#import "AppDelegate.h"
#import "PhoneLoginVC.h"
#import "mineVideoVC.h"
#import "MBHistoryViewController.h"
#import "LoginAndRegisterViewController.h"
#import "setView.h"
#import "webH5.h"
#import "getpasswangViewController.h"
@interface YBUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,personInfoCellDelegate,UIAlertViewDelegate>
{
    NSArray *listArr;
    UIView *navi;
    NSInteger count;
    NSArray *infoArray;
    
}
@property (nonatomic, assign, getter=isOpenPay) BOOL openPay;
@property(nonatomic,strong)NSDictionary *infoArray;//个人信息
@property (nonatomic, strong) YBPersonTableViewModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * nameTArr;
@property (nonatomic, strong) NSArray * nameArr;
@property (nonatomic, strong) NSArray * ImageArr;
@property (nonatomic, strong) NSString * phoneStr;
@property (nonatomic, strong) UILabel * cacheStr;
@end
@implementation YBUserInfoViewController
-(void)getPersonInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
    //NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
    //NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *build = [NSString stringWithFormat:@"%@",app_build];
    //这个地方传版本号，做上架隐藏，只有版本号跟后台一致，才会隐藏部分上架限制功能，不会影响其他正常使用客户(后台位置：私密设置-基本设置 -IOS上架版本号)
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"?service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@",[Config getOwnID],[Config getOwnToken],build];
    [session GET:userBaseUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                
                LiveUser *user = [Config myProfile];
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                self.infoArray = info;
                user.user_nicename = minstr([info valueForKey:@"user_nicename"]);
                user.sex = minstr([info valueForKey:@"sex"]);
                user.level =minstr([info valueForKey:@"level"]);
                user.avatar = minstr([info valueForKey:@"avatar"]);
                user.city = minstr([info valueForKey:@"city"]);
                user.level_anchor = minstr([info valueForKey:@"level_anchor"]);
                user.ID = minstr([info valueForKey:@"id"]);
                [Config updateProfile:user];
                //保存靓号和vip信息
                NSDictionary *liang = [info valueForKey:@"liang"];
                NSString *liangnum = minstr([liang valueForKey:@"name"]);
                NSDictionary *vip = [info valueForKey:@"vip"];
                NSString *type = minstr([vip valueForKey:@"type"]);
                NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
                [Config saveVipandliang:subdic];
                _model = [YBPersonTableViewModel modelWithDic:info];
//                NSArray *list = [info valueForKey:@"list"];
//                for (NSDictionary * dic  in list) {
//                    NSString * name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
//                }
//                listArr = [NSMutableArray array];
//                NSInteger secionCount;
//                if (list.count%5 == 0) {
//                    secionCount = list.count/5;
//                }else{
//                    secionCount = list.count/5+1;
//                }
//                for (int i = 0; i < secionCount; i++) {
//                    NSMutableArray *arr = [NSMutableArray array];
//                    int aaaaa;
//                    if ((i+1)*5>list.count) {
//                        aaaaa = (int)list.count;
//                    }else{
//                        aaaaa = (i+1)*5;
//                    }
//                    for (int j = i*5; j < aaaaa; j++) {
//                        [arr addObject:list[j]];
//                    }
//                    [listArr addObject:arr];
//                }
//                listArr = list;
//                [common savepersoncontroller:listArr];//保存在本地，防止没网的时候不显示
                [self.tableView reloadData];
            }
            if ([code isEqual:@"700"]) {
                [self quitLogin];
            }
            else{
//                listArr = [NSArray arrayWithArray:[common getpersonc]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
        else{
//            listArr = [NSMutableArray arrayWithArray:[common getpersonc]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
//       listArr = [NSArray arrayWithArray:[common getpersonc]];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getPersonInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkNetwork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    [self creatNavi];
//    listArr = [NSArray arrayWithArray:[common getpersonc]];
//
//    count = 0;


    
    self.nameArr = @[

                                      @[@"隐私政策",@"服务条款",@"清除缓存",@"关于我们",@"检查更新"],

                                      @[@"修改密码",@"退出登录"]


                       ];
    NSLog(@"slef.nameArr %@",self.nameArr);

    self.ImageArr = @[@[@"yinsi",@"fuwu",@"qingchu",@"lianxiwomen",@"jianchagengxin"],@[@"shezhi",@"tuichudenglu"]];
//    [self.tableView reloadData];
    [self setUI];
}

- (void)requestData{
    [YBToolClass postNetworkWithUrl:@"User.getPerSetting" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            infoArray = info;
            [self.tableView reloadData];
        }
    } fail:^{
        
    }];
}

//MARK:-设置tableView
-(void)setUI
{
    [self.tableView registerClass:[YBPersonTableViewCell class] forCellReuseIdentifier:@"YBPersonTableViewCell"];
    [self.tableView registerClass:[YBUserInfoListTableViewCell class] forCellReuseIdentifier:@"YBUserInfoListTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(_window_height-ShowDiff-49);
    }];
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.view.backgroundColor = RGB(244, 245, 246);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
  
//    [self creatNavi];
}
//MARK:-tableviewDateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//102
    {
        YBPersonTableViewCell *cell = [YBPersonTableViewCell cellWithTabelView:tableView];
        
        
//        cell.iconView.image = [UIImage imageNamed:@"头像"];
        /// 设置头像
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
  
        /// 设置昵称
//        cell.nameLabel.text = @"神婆骑驴追火箭";
        cell.nameLabel.textColor = [UIColor whiteColor];
        cell.nameLabel.text = [Config getOwnNicename];
        if ([[Config getSex] isEqual:@"1"]) {
            [cell.sexView setImage:[UIImage imageNamed:@"sex_man"]];
        }
        else{
            [cell.sexView setImage:[UIImage imageNamed:@"sex_woman"]];
        }
//        [cell.levelView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",[Config getLevel]]]];
//        [cell.level_anchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",[Config level_anchor]]]];
        NSDictionary *levelDic = [common getUserLevelMessage:[Config getLevel]];
        [cell.levelView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
        NSDictionary *levelDic1 = [common getAnchorLevelMessage:[Config level_anchor]];
        [cell.level_anchorView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic1 valueForKey:@"thumb"])]];

        cell.personCellDelegate = self;
        
        /// 个人信息数据
//        if (self.infoArray) {
//            cell.model = _model;
//        }
        return cell;
    }
    else  {
        YBUserInfoListTableViewCell *cell = [YBUserInfoListTableViewCell cellWithTabelView:tableView];
//        NSDictionary *subdic = listArr[indexPath.section-1][indexPath.row];
///       cell.nameL.text = minstr([subdic valueForKey:@"name"]);
         cell.nameL.text =  self.nameArr[indexPath.section - 1][indexPath.row];
 ///       [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:minstr([subdic valueForKey:@"thumb"])]];
        
        cell.iconImage.image =  [UIImage imageNamed:self.ImageArr[indexPath.section - 1][indexPath.row]];
        
       
      
            if (indexPath.section == 1) {
                if (indexPath.row == 2) {
                    count ++;
                    NSLog(@"count===========> %ld",(long)count);
                      if (count == 1) {
                    self.cacheStr = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, 15, 100, cell.frame.size.height - 30)];
                    self.cacheStr.text =[NSString stringWithFormat:@"%.2fM",[self readCacheSize]];
                    self.cacheStr.textColor = RGB_COLOR(@"#626162", 1);
                    self.cacheStr.font = [UIFont systemFontOfSize:14];
                    self.cacheStr.textAlignment = NSTextAlignmentRight;
                    [cell.contentView addSubview:self.cacheStr];
                    
                      }
                }else if (indexPath.row == 4) {
                    
                    if (count == 1) {
                        NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, 15, 100, cell.frame.size.height - 30)];
                       lab.text = build;
                       lab.textColor = RGB_COLOR(@"#626162", 1);
                       lab.font = [UIFont systemFontOfSize:14];
                       lab.textAlignment = NSTextAlignmentRight;
                       [cell.contentView addSubview:lab];
                    }
                }
        }else
        {
            
        }
      
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return listArr.count+1;
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    
/**
//    else
//        if (section == 1)
//    {
//        return listArr.count;
//    }
        
//    return [listArr[section-1] count];
 */
    
    else if (section == 1)
    {
        return 5;
    }else
    {
        return 2;
    }
        
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return _window_width/2+30;
    }
        return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else
        return 8;
}
//-(void)pushH5Webviewinfo:(NSDictionary *)subdic{
//    NSString *url = minstr([subdic valueForKey:@"href"]);
//    if (url.length >9) {
//        webH5 *VC = [[webH5 alloc]init];
//        VC.titles = minstr([subdic valueForKey:@"name"]);
//        VC.urls = [self addurl:url];
//        [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
//     }
//}
//所有h5需要拼接uid和token
-(NSString *)addurl:(NSString *)url{
    return [url stringByAppendingFormat:@"&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
}
//我的收益
-(void)Myearnings{
    myProfitVC *VC = [[myProfitVC alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的钻石
-(void)MyDiamonds{
//    CoinVeiw *VC = [[CoinVeiw alloc]init];
//    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//商城
-(void)ShoppingMall{
    market *VC = [[market alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//装备中心
-(void)Myequipment{
    equipment *VC = [[equipment alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//设置
-(void)SetUp{
    setView *VC = [[setView alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的视频
-(void)mineVideo{
    mineVideoVC *VC = [[mineVideoVC alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    #warning 根据ID判断 进入 哪个页面（ID 不可随意更改（服务端，客户端））
//    if (indexPath.section == 2&&indexPath.row == 1) {
//        [self quitLogin];
//    }
//
//    if (indexPath.section == 1&&indexPath.row == 3) {
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"拨打客服热线" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIWebView * callWebView = [[UIWebView alloc]init];
//            NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneStr]];
//            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//            [self.view addSubview:callWebView];
//        }];
//        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:callAction];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
    
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            ///隐私政策 /index.php?g=portal&m=page&a=index&id=3
            NSDictionary *subDic = infoArray[1];
            webH5 *web = [[webH5 alloc]init];
            web.urls = [NSString stringWithFormat:@"%@/index.php?g=portal&m=page&a=index&id=3",curl];
            [self.navigationController pushViewController:web animated:YES];

        }else if (indexPath.row == 1)
        {
            /// 服务条款 /index.php?g=portal&m=page&a=index&id=4
            NSDictionary *subDic = infoArray[2];
            webH5 *web = [[webH5 alloc]init];
            web.urls = [NSString stringWithFormat:@"%@/index.php?g=portal&m=page&a=index&id=4",curl];
            [self.navigationController pushViewController:web animated:YES];
            
            
            
        }else if (indexPath.row == 2)
        {
            ///清除缓存
            self.cacheStr.text = @"0.0KB";
            [self clearFile];
        }else if (indexPath.row == 3) {
            ///联系我们 /index.php?g=portal&m=page&a=index&id=5
//            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"拨打客服热线" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction * callAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UIWebView * callWebView = [[UIWebView alloc]init];
//                NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneStr]];
//                [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//                [self.view addSubview:callWebView];
//            }];
//            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:callAction];
//            [alertController addAction:cancelAction];
//            [self presentViewController:alertController animated:YES completion:nil];
            NSDictionary *subDic = infoArray[3];
            webH5 *web = [[webH5 alloc]init];
            web.urls = [NSString stringWithFormat:@"%@/index.php?g=portal&m=page&a=index&id=5",curl];
            [self.navigationController pushViewController:web animated:YES];
        }else
        {
            ///检查更新
            [self getbanben];
//            [self SetUp];
        }
        
    }else {
        if (indexPath.row == 0) {
            getpasswangViewController * getVC = [[getpasswangViewController alloc] init];
         [self.navigationController pushViewController:getVC animated:YES];
        }else if (indexPath.row == 1) {
            [self quitLogin];
        }
    }
    
    
//     if (indexPath.section > 0) {
//        NSDictionary *subdic = listArr[indexPath.section-1][indexPath.row];
//        int selectedid = [subdic[@"id"] intValue];//选项ID
//        NSString *url = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"href"]];
//        if (url.length >9) {
//            [self pushH5Webviewinfo:subdic];
//        }
//        else{
//            /*
//             1我的收益  2 我的钻石  4 在线商城 5 装备中心 13 个性设置  19 我的视频
//             其他页面 都是H5
//             */
//            switch (selectedid) {
//                //原生页面无法动态添加
//                case 1:
//                    [self Myearnings];//我的收益
//                    break;
//                case 2:
//                    [self MyDiamonds];//我的钻石
//                    break;
//                case 4:
//                    [self ShoppingMall];//在线商城
//                    break;
//                case 5:
//                    [self Myequipment];//装备中心
//                    break;
//                case 13:
//                    [self SetUp];//设置
//                    break;
//                case 19:
//                    [self mineVideo];//我的视频
//                    break;
//
//                default:
//                    break;
//            }
//        }

//    }
}//MARK:-懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(246, 246, 246);
    }
    return _tableView;
}
-(void)pushLiveNodeList{
    MBHistoryViewController *historyVC = [[MBHistoryViewController alloc]init];
    historyVC.isHistory = YES;
    [[MXBADelegate sharedAppDelegate] pushViewController:historyVC animated:YES];
}

-(void)pushFansList{
//    fansViewController *fans = [[fansViewController alloc]init];
//    fans.fensiUid = [Config getOwnID];
//    [[MXBADelegate sharedAppDelegate] pushViewController:fans animated:YES];
    UIAlertController * newAlert=[UIAlertController
                                  alertControllerWithTitle: @"通知"
                                  message:@"敬请期待"
                                  preferredStyle:UIAlertControllerStyleAlert
                                  ];
    UIAlertAction * newAlertAction=[UIAlertAction
                                    actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                    handler:nil
                                    ];
    //弹框按钮
    [newAlert addAction:newAlertAction];
    [self presentViewController:newAlert animated:true completion:nil];
}
-(void)pushAttentionList{
    MBHistoryViewController *historyVC = [[MBHistoryViewController alloc]init];
    historyVC.isHistory = NO;
    [[MXBADelegate sharedAppDelegate] pushViewController:historyVC animated:YES];
}
-(void)pushEditView{
    myInfoEdit *info = [[myInfoEdit alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:info animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 64+statusbarHeight) {
        navi.alpha = 1;
    }else{
        navi.alpha = scrollView.contentOffset.y/(64.00000+statusbarHeight);
    }
}

//退出登录函数
-(void)quitLogin
{
    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [Config clearProfile];
//    [JMSGUser logout:^(id resultObject, NSError *error) {
//        if (!error) {
//            //退出登录成功
//        } else {
//            //退出登录失败
//        }
//    }];
    self.tabBarController.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter]postNotificationName:LoginNotifacation object:nil];
    
}
#pragma mark -
#pragma mark - navi
-(void)creatNavi {
    navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navi.backgroundColor = normalColors;
    [self.view addSubview:navi];

    //标题
    UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20+statusbarHeight, _window_width-120, 44)];
    midLabel.backgroundColor = [UIColor clearColor];
    midLabel.font = fontMT(16);
    midLabel.text = [Config getOwnNicename];
    midLabel.textAlignment = NSTextAlignmentCenter;
    midLabel.textColor = [UIColor blackColor];
    [navi addSubview:midLabel];

//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5+statusbarHeight, _window_width, 0.5)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [navi addSubview:line];
    navi.alpha = 0;
    
}


-( float )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
        NSLog(@"folderSize %lldld",folderSize);
    }
    
    return folderSize/( 1024.0 * 1024.0);
    
}

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
    //读取缓存大小
    float cacheSize = [self readCacheSize] *1024;
    // [NSString stringWithFormat:@"%.2fKB",cacheSize];
    self.cacheStr.text = @"0.0KB";
    NSLog(@"cacheStr %@",self.cacheStr);
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)getbanben{
    NSUserDefaults * users = [NSUserDefaults standardUserDefaults];
    NSString * url = [users objectForKey:@"ipa_url"];
    NSString * ipa_des  =  [users objectForKey:@"ipa_des"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地
    NSNumber *build = (NSNumber *)[common ipa_ver];//远程
    NSComparisonResult r = [app_build compare:build];
    if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"提示" message:minstr(ipa_des) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"使用旧版" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[users objectForKey:@"ipa_url"]]];
        }];
        [alertContro addAction:sureAction];
        [self presentViewController:alertContro animated:YES completion:nil];
//        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:options completionHandler:nil];
        
        [MBProgressHUD hideHUD];
    }else if(r == NSOrderedSame) {//可改为if(r == 0L)
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"当前已是最新版本" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - 网络监听
- (void)checkNetwork{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //            [self requestMoreVideo];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"当前无网络连接" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
           
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
          
            NSLog(@"wifi-------");
        }
    }];
}
@end
