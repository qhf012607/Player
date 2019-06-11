//
//  NearbyVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NearbyVC.h"

#import "AFNetworking.h"
#import "NearbyVideoModel.h"
#import "NearbyCell.h"
#import "LookVideo.h"


@interface NearbyVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger _paging;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation NearbyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [NSMutableArray array];
    self.models = [NSArray array];
    _paging = 1;
    
    [self.view addSubview:self.collectionView];
    
    [self pullData];
}

- (NSArray *)models {
    NSMutableArray *m_array = [NSMutableArray array];
    for (NSDictionary *dic in _dataArray) {
        NearbyVideoModel *model = [NearbyVideoModel modelWithDic:dic];
        [m_array addObject:model];
    }
    _models = m_array;
    return _models;
}

-(void)pullData {
   _collectionView.userInteractionEnabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@&p=%ld",_url,(long)_paging];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        _collectionView.userInteractionEnabled = YES;
        if ([code isEqual:@"0"]) {
            NSArray *info = [data valueForKey:@"info"];
            if (_paging == 1) {
                [_dataArray removeAllObjects];
            }
            if (info.count <= 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                 [_dataArray addObjectsFromArray:info];
            }
            if (_dataArray.count > 0) {
                [PublicView hiddenTextNoData:_collectionView];
            }else{
                [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无附近视频哦~"];
            }
            [_collectionView reloadData];
            
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
            
        }else{
            if (_dataArray) {
                [_dataArray removeAllObjects];
            }
            [_collectionView reloadData];
            [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无附近视频哦~"];
        }
    } Fail:^(id fail) {
        _collectionView.userInteractionEnabled = YES;
        [self checkNetwork];
        _collectionView.userInteractionEnabled = YES;
        if (_dataArray) {
            [_dataArray removeAllObjects];
        }
        [_collectionView reloadData];
        [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无附近视频哦~"];
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - CollectionView 代理
/*
 * minimumLineSpacing、minimumInteritemSpacing去设置
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0,0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}
*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NearbyCell *cell = (NearbyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NearbyCell" forIndexPath:indexPath];
    NearbyVideoModel *model = _models[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NearbyCell *cell = (NearbyCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LookVideo *video = [[LookVideo alloc]init];
    video.fromWhere = @"NearbyVC";
    video.curentIndex = indexPath.row;
    video.videoList = _dataArray;
    video.pages = _paging;
    video.firstPlaceImage = cell.coverIV.image;
    video.requestUrl = _url;
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        _paging = page;
        self.dataArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}

#pragma mark - set/get
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake(_window_width/2-1, (_window_width/2-1) * 1.4);
        flow.minimumLineSpacing = 2;
        flow.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,statusbarHeight, _window_width, _window_height-49-statusbarHeight-ShowDiff) collectionViewLayout:flow];
        [_collectionView registerNib:[UINib nibWithNibName:@"NearbyCell" bundle:nil] forCellWithReuseIdentifier:@"NearbyCell"];
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
        _collectionView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _paging ++;
            [self pullData];
        }];
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            [self pullData];
            
        }];
    }
    return _collectionView;
}

#pragma mark - 网络监听
- (void)checkNetwork{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
            _paging = 1;
            [self pullData];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
            _paging = 1;
            [self pullData];
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            _paging = 1;
            [self pullData];
            NSLog(@"wifi-------");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
