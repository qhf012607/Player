//
//  VideoViewController.m
//  yunbaolive
//
//  Created by Jolly on 02/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "VideoViewController.h"
#import "hotModel.h"
#import "LivePlay.h"
#import "AppDelegate.h"
#import "jumpSlideContent.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "tuijianwindow.h"
#import "HotCollectionViewCell.h"
#import "classVC.h"
#import "allClassView.h"
#import "LookVideo.h"
#import "NearbyVideoModel.h"
#import "ZYTabBar.h"
#import "AFNetworking.h"

@interface VideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,tuijian,UIScrollViewDelegate>
{
    NSDictionary *selectedDic;
    UIImageView *NoInternetImageV;//直播无网络的时候显示
    UIAlertController *alertController;//邀请码填写
    UITextField *codetextfield;
    NSString *type_val;//
    NSString *livetype;//
    tuijianwindow *tuijianw;
    CGFloat oldOffset;
    int page;
    UIView *collectionHeaderView;
    UIAlertController *md5AlertController;
    allClassView *allClassV;
    YBNoWordView *noNetwork;
    
}
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSMutableArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;//加密密码

@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSArray *modelrray;
@end

@implementation VideoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%f",_collectionView.contentOffset.y);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _modelrray = [NSArray array];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.allArray = [NSMutableArray array];
    oldOffset = 0;
    type_val = @"0";
    livetype = @"0";
    page = 1;
    self.infoArray    =  [NSMutableArray array];
    self.zhuboModel    =  [NSMutableArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createCollectionView];
    [self nothingview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeConfig) name:@"home.getconfig" object:nil];
     [self createCollectionHeaderView];
}
- (void)homeConfig{
    [self createCollectionHeaderView];
}
- (void)createCollectionHeaderView{
    if (collectionHeaderView) {
        [collectionHeaderView removeFromSuperview];
        collectionHeaderView = nil;
    }
    collectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/6+35)];
    collectionHeaderView.backgroundColor = [UIColor whiteColor];
    NSArray *liveClass = [common liveclass];
    NSInteger count;
    if (liveClass.count>6) {
        count = 5;
        UIButton *allButton = [UIButton buttonWithType:0];
        allButton.frame = CGRectMake(_window_width/6*5, 0, _window_width/6, _window_width/6);
        allButton.tag = 10086;
        [allButton addTarget:self action:@selector(liveClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [collectionHeaderView addSubview:allButton];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(allButton.width*0.3, allButton.width*0.15, allButton.width*0.4, allButton.width*0.4)];
        [imgView setImage:[UIImage imageNamed:@"live_all"]];
        [allButton addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+allButton.width/8, allButton.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:@"全部"];
        [allButton addSubview:label];
    }else{
        count = liveClass.count;
    }
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(i*(_window_width/6), 0, _window_width/6, _window_width/6);
        button.tag = i + 20180922;
        [button addTarget:self action:@selector(liveClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [collectionHeaderView addSubview:button];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:minstr([liveClass[i] valueForKey:@"thumb"])] placeholderImage:[UIImage imageNamed:@"live_all"]];
        [button addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:minstr([liveClass[i] valueForKey:@"name"])];
        [button addSubview:label];
        
    }
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 60, _window_width, 5) andColor:RGB(244, 245, 246) andView:collectionHeaderView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 200, 30)];
    label.text = @"热门";
    label.font = [UIFont boldSystemFontOfSize:15];
    [collectionHeaderView addSubview:label];
    
}
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-1, (_window_width/2-1) * 1.4);
    flow.minimumLineSpacing = 2;
    flow.minimumInteritemSpacing = 2;
    flow.headerReferenceSize = CGSizeMake(_window_width, 95);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self pullInternetforNew:page];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self pullInternetforNew:page];
        
    }];
    
    [self.view addSubview:self.collectionView];
    _collectionView.contentInset = UIEdgeInsetsMake(44 * Rate, 0, 0, 0);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self pullInternetforNew:1];
    //因为列表不可以每次 都重新刷新，影响用户体验，也浪费流量
    //在视频页面输出视频后返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLiveList:) name:@"delete" object:nil];
    //发布视频成功之后返回首页刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullInternetforNewDown) name:@"reloadlist" object:nil];
}
-(void)nothingview{
    //    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    //    NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    //    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    //    [self.view addSubview:NoInternetImageV];
    //    NoInternetImageV.hidden = YES;
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullInternet];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];
    
}

//获取网络数据
-(void)pullInternet{
    
    [YBToolClass postNetworkWithUrl:@"Home.getHot" andParameter:@{@"p":@(page)} success:^(int code,id info,NSString *msg) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        noNetwork.hidden = YES;
        
        if (code == 0) {
            NSArray *infoA = [info objectAtIndex:0];
            NSArray *list = [infoA valueForKey:@"list"];
            if (page == 1) {
                [_infoArray removeAllObjects];
                [_zhuboModel removeAllObjects];
                if (!collectionHeaderView) {
                    [self createCollectionHeaderView];
                }
            }
            [_infoArray addObjectsFromArray:list];
            for (NSDictionary *dic in list) {
                hotModel *model = [[hotModel alloc]initWithDic:dic];
                [_zhuboModel addObject:model];
            }
            [_collectionView reloadData];
            
            if (list.count == 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } fail:^{
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (_infoArray.count == 0) {
            noNetwork.hidden = NO;
        }
    }];
}
//在视频页面删除视频回来后删除
-(void)getLiveList:(NSNotification *)nsnitofition{
    NSString *videoid = [NSString stringWithFormat:@"%@",[[nsnitofition userInfo] valueForKey:@"videoid"]];
    NSDictionary *deletedic = [NSDictionary dictionary];
    for (NSDictionary *subdic in self.allArray) {
        NSString *videoids = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([videoid isEqual:videoids]) {
            deletedic = subdic;
            break;
        }
    }
    if (deletedic) {
        [self.allArray removeObject:deletedic];
        [self.collectionView reloadData];
    }
}
-(void)refreshNear{
}
//down
-(void)pullInternetforNewDown{
    self.allArray = [NSMutableArray array];
    page = 1;
    [self pullInternetforNew:page];
}
-(void)getDataByFooterup{
    page ++;
    [self pullInternetforNew:page];
}
-(void)pullInternetforNew:(NSInteger)pages{
    
    self.collectionView.userInteractionEnabled = NO;
    
    NSString *url = [NSString stringWithFormat:@"%@&p=%ld",_url,(long)pages];
    WeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        weakSelf.collectionView.userInteractionEnabled = YES;
        if ([code isEqual:@"0"]) {
            NSArray *info = [data valueForKey:@"info"];
            if (page == 1) {
                [self.allArray removeAllObjects];
                if (!collectionHeaderView) {
                    [self createCollectionHeaderView];
                }
            }
            [self.allArray addObjectsFromArray:info];
            //加载成功 停止刷新
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            if (self.allArray.count > 0) {
                [PublicView hiddenTextNoData:_collectionView];
            }else{
                [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
            }
            if (info.count <= 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
            
        }else{
            if (self.allArray) {
                [self.allArray removeAllObjects];
            }
            [self.collectionView reloadData];
            [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
        }
    } Fail:^(id fail) {
        weakSelf.collectionView.userInteractionEnabled = YES;
        [self checkNetwork];
        self.collectionView.userInteractionEnabled = YES;
        if (self.allArray) {
            [self.allArray removeAllObjects];
        }
        [self.collectionView reloadData];
        [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - Table view data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LookVideo *video = [[LookVideo alloc]init];
    
    video.fromWhere = @"myVideoV";
    video.curentIndex = indexPath.row;
    video.videoList = _allArray;
    video.pages = page;
    video.firstPlaceImage = cell.thumbImageView.image;
    video.requestUrl = _url;
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        page = page;
        self.allArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    video.hidesBottomBarWhenPushed = YES;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCELL" forIndexPath:indexPath];
    NSDictionary *subdic = _allArray[indexPath.row];
    cell.videoModel = [[NearbyVideoModel alloc] initWithDic:subdic];
    return cell;
}
#pragma mark ================ collectionview头视图 ===============


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV" forIndexPath:indexPath];
        
        header.backgroundColor = [UIColor whiteColor];
        [header addSubview:collectionHeaderView];
        return header;
    }else{
        return nil;
    }
}

- (void)checkNetwork{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
            page = 1;
            [self pullInternetforNew:page];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
            page = 1;
            [self pullInternetforNew:page];
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            page = 1;
            [self pullInternetforNew:page];
            NSLog(@"wifi-------");
        }
    }];
}







#pragma mark ================ 分类按钮点击事件 ===============
- (void)liveClassBtnClick:(UIButton *)sender{
    if (sender.tag == 10086) {
        if (!allClassV) {
            allClassV = [[allClassView alloc]initWithFrame:CGRectMake(0, 44 * Rate, _window_width, _window_height)];
            [self.view addSubview:allClassV];
        }else{
            allClassV.hidden = NO;
        }
        __weak VideoViewController *weakSelf = self;
        allClassV.block = ^(NSDictionary * _Nonnull dic) {
            [weakSelf pushLiveClassVC:dic];
        };
        [allClassV showWhiteView];
    }else{
        NSDictionary *dic = [common liveclass][sender.tag - 20180922];
        [self pushLiveClassVC:dic];
    }
}
- (void)pushLiveClassVC:(NSDictionary *)dic{
    classVC *class = [[classVC alloc]init];
    class.titleStr = minstr([dic valueForKey:@"name"]);
    class.classID = minstr([dic valueForKey:@"id"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:class animated:YES];
    
}
#pragma mark ================ socrollview代理 ===============
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    oldOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > oldOffset) {
        if (scrollView.contentOffset.y > 0) {
            _pageView.hidden = YES;
            [self hideTabBar];
        }
    }else{
        _pageView.hidden = NO;
        [self showTabBar];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%f",oldOffset);
}
#pragma mark ================ 隐藏和显示tabbar ===============
- (void)hideTabBar {
    
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = YES;
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = NO;
    
}
@end
