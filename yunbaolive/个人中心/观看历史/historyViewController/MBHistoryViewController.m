//
//  MBHistoryViewController.m
//  yunbaolive
//
//  Created by Jolly on 06/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "MBHistoryViewController.h"
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
#import "HistoryCollectionViewCell.h"
#import "MBHistoryModel.h"
#import "MBHistoryListModel.h"

@interface MBHistoryViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) int instanceIndex;
@property (nonatomic,strong) MBHistoryModel * model;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * urlArray;
@property (nonatomic,strong) NSIndexPath * selectIndex;
@property (nonatomic,strong) MBHistoryListModel * modelHistory;
@property (nonatomic,strong) NSString * str;
@property (nonatomic,strong) NSMutableArray * arr;
@property (nonatomic,strong) NSMutableArray *  children;
@property (nonatomic,strong) NSMutableArray * videoIdArr;
@property (nonatomic,strong) UILabel * noDataLabel;
@property (nonatomic,strong) NSString * noDataStr;
@end



@implementation MBHistoryViewController


- (void)viewDidLoad {
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftbutton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(deleteAllBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isHistory) {
        self.title = @"观看历史";
        UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
        self.navigationItem.rightBarButtonItem=rightitem;
        
        self.str = @"history";
        self.noDataStr = @"观看历史";
    }else
    {
        self.title = @"视频收藏";
        self.str = @"likes";
        self.noDataStr = @"视频收藏";
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];

    self.urlArray = [NSMutableArray new];
    self.dataArray = [NSMutableArray new];
    self.arr = [[NSMutableArray alloc] init];
    self.videoIdArr = [[NSMutableArray alloc] init];
    [self createCollection];
    [self update];
   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteClick) name:@"loginOut" object:nil];
}
- (void)showNoDataLabel
{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 25)];
        _noDataLabel.text = [NSString stringWithFormat:@"暂无%@",self.noDataStr];
        _noDataLabel.textColor = [UIColor grayColor];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_noDataLabel];
    }
    if ([self.model.aVideo  count] == 0) {
        _noDataLabel.hidden = NO;
    }
    else{
        _noDataLabel.hidden = YES;
    }
}
- (void)update {
    [MBProgressHUD showMessage:@""];
    //http://10.5.45.160/v1/historyLikesList?timeStamp=15537388732&secretKey=46581e349ae828d3b957d1f9b1fae314&uid=22738&historyLikes=history
    //  [self.arr addObject:self.modelHistory.listid];
//    [self.urlArray addObject:self.modelHistory.href];
//    [self.videoIdArr addObject:self.modelHistory.videoid];
    WeakSelf
    [self.videoIdArr removeAllObjects];
    [self.urlArray removeAllObjects];
    [self.arr removeAllObjects];
    [[PRNetWork GetHistoryListhWith:@{@"uid":[Config getOwnID],@"historyLikes":self.str}]subscribeNext:^(id x) {
         [MBProgressHUD hideHUD];
        weakSelf.model = [MBHistoryModel mj_objectWithKeyValues:x[@"data"]];
        self.dataArray = [x[@"data"] objectForKey:@"aVideo"];
        self.children = [self.model.aVideo mutableCopy];
        NSString * str = [NSString stringWithFormat:@"%@",[x[@"data"] objectForKey:@"aVideo"]];
        NSLog(@"str === %@",str);
        if ([str isEqualToString:@"<null>"]) {
            
        }else
        {
            for (NSDictionary * dic in self.dataArray) {
                NSString * listStr = [dic objectForKey:@"listid"];
                NSString * hrefStr = [dic objectForKey:@"href"];
                NSString * videoId = [dic objectForKey:@"videoid"];
                [self.arr addObject:listStr];
                [self.urlArray addObject:hrefStr];
                [self.videoIdArr addObject:videoId];
            }
        }
        [weakSelf.collectionView reloadData];
           [self showNoDataLabel];
    }];

}
//创建collection
- (void)createCollection {
    if (!self.instanceIndex) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout: layout];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.collectionView];
        [self.collectionView registerNib:  [UINib nibWithNibName:@"HistoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryCell"];

        self.instanceIndex = 1;

    }

    [self.collectionView reloadData];
 
}

#pragma mark -- collectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.model.aVideo.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    HistoryCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryCell" forIndexPath:indexPath];

    self.modelHistory = self.model.aVideo[indexPath.row];

    [cell config:self.modelHistory];

//    [self.arr addObject:self.modelHistory.listid];
//    [self.urlArray addObject:self.modelHistory.href];
//    [self.videoIdArr addObject:self.modelHistory.videoid];
     cell.deleteBtn.tag = indexPath.row;
     [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isHistory) {
        [cell.deleteBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    }else
    {
        [cell.deleteBtn setImage:[UIImage imageNamed:@"aixin"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    LookVideo *video = [[LookVideo alloc]init];
    video.fromWhere = @"myVideoV";
    video.curentIndex = indexPath.row;
    video.videoList =  self.dataArray;
    video.pages = 1;
    video.cate  = 0;
    video.viewVc = 1;
    //    video.firstPlaceImage = cell.thumbImageView.image;
    video.requestUrl = self.urlArray[indexPath.row];
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        page = page;
        self.urlArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    video.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:video animated:YES completion:nil];
        [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);

    return size;
}

//- (void)deleteClick
//{
//    NSLog(@"接受删除通知");
//
//}

- (void)btnClick:(UIButton *)sender
{

        NSIndexPath * index = [NSIndexPath indexPathWithIndex:sender.tag];
    
    
    
    WeakSelf
    if (_isHistory) {
        [[PRNetWork GetDeleteHistoryWith:@{@"videoViewsIds":self.arr[sender.tag]}] subscribeNext:^(id x) {
            NSLog(@"=========>%@",x[@"data"]);
        }];
        [self update];
    }else
    {
        NSLog(@"self.videoIdArr  %@",self.videoIdArr[sender.tag]);
        NSDictionary * dic = @{@"uid":[Config getOwnID],@"videoId":self.videoIdArr[sender.tag]};
        [[PRNetWork GetVideoGiveLikesWith:dic] subscribeNext:^(id x) {
            NSDictionary * likeDic = x[@"data"];
            NSLog(@"==likeDic %@",likeDic);
            NSLog(@"msg  ===  %@",x[@"msg"]);
            NSString * msg = [NSString stringWithFormat:@"%@",x[@"msg"]];
            NSInteger status = [[NSString stringWithFormat:@"%@",likeDic[@"status"]] integerValue];
            if (status == 2)
            {
                [MBProgressHUD showSuccess:@"取消成功"];
//                [self.collectionView deselectItemAtIndexPath:index animated:YES];
//                [self.children removeObjectAtIndex:sender.tag];
//                self.model.aVideo = self.children;
//                [self.collectionView reloadData];
//                [self showNoDataLabel];
            }else
            {
                [MBProgressHUD showError:@"取消收藏失败,请重试"];
            }
            [self update];
        }];
    }
}


- (void)deleteAllBtn
{
    
    NSArray * dele = @[@"12",@"23",@"34"];
    for (NSString * listIdStr in dele) {
        NSLog(@"清除的历史 %@",listIdStr);
    }
    NSString *string = [self.arr componentsJoinedByString:@"_"];
    NSLog(@"清除的历史string %@",string);

    [self.children removeAllObjects];
    self.model.aVideo = self.children;
    [self.collectionView reloadData];
    [self showNoDataLabel];
    [[PRNetWork GetDeleteHistoryWith:@{@"videoViewsIds":string}] subscribeNext:^(id x) {
        NSLog(@"=========>%@",x[@"data"]);
    }];
}

@end
