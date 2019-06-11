//
//  MBVideoViewController.m
//  yunbaolive
//
//  Created by Jolly on 01/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//
#import "MainVideoViewController.h"
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
#import "MBVideoModel.h"
#import "MainCollectionReusableView.h"
#import "VideoCollectionViewCell.h"
#import "MBHomeCollectionViewCell.h"
#import "MBVideoModelList.h"
#import "MBVideoCateModel.h"
#import "MBVideoViewController.h"
#import "MBVideoDetailViewController.h"
#import "TMineViewController.h"
#import "MBImageView.h"
@import FSPagerView;
@interface MBVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,tuijian,UIScrollViewDelegate,UITextFieldDelegate>
{
    //    UIView *collectionHeaderView;
    allClassView *allClassV;
    int page;
    NSString * currentPage1;

    
}
@property(nonatomic,strong)UIView *collectionHeaderView;
@property(nonatomic,strong)UIView *showView;
@property(nonatomic,assign)NSInteger cateCount;
@property(nonatomic,assign)int instanceIndex;

@property(nonatomic,strong)NSArray * arr;
@property(nonatomic,strong)MBVideoModel * model;
@property(nonatomic,strong)MBVideoCateModel * cate;

@property(nonatomic,strong)FSPagerView *page;
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSMutableArray *infoArray;//获取到的主播列表信息

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;//加密密码

@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSArray *modelrray;

@property (nonatomic ,strong) UIView * logoView;
@property (nonatomic, strong) UITextField *searchText; // 搜索框

@property (nonatomic, strong) NSArray *userArray;


@property (nonatomic, strong) NSMutableArray * urlArray;
@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * moreArray;
@property (nonatomic,strong) NSMutableArray * listArray;
@property (nonatomic,strong) NSString * iUid;
@property (nonatomic,strong) NSString * cateId;
@property (nonatomic,strong) UILabel * noDataLabel;


@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,strong)NSMutableArray *arrayButton;
@property(nonatomic,strong)NSMutableArray *arrayButtonHead;
@property(nonatomic,assign)NSInteger indexPath;
@property(nonatomic,assign)NSInteger totolNum;
@end

@implementation MBVideoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%f",_collectionView.contentOffset.y);
    [self.collectionView reloadData];
    
}
- (void)getVideoList:(NSString *)cate {
    [MBProgressHUD showMessage:@"正在加载"];

    if ([Config getOwnID]) {
        self.iUid = [Config getOwnID];
    }else
    {
        self.iUid = @"0";
    }    WeakSelf
    //http://10.5.45.160/v1/wapVideo?timeStamp=15537388732&secretKey=2d900bb47cfa85d76a4a0aa67dca0f45&pageNum=1&cate_id=0&iUid=4
    currentPage1 = [NSString stringWithFormat:@"%ld",(long)self.currentPage];
    NSDictionary * dic = @{@"pageNum": currentPage1,@"cate_id":cate,@"iUid":self.iUid};
    
    NSLog(@"视频界面uid %@",[Config getOwnID]);
    
    [[PRNetWork GetVideoListWith:dic]subscribeNext:^(id x) {
        if (weakSelf.currentPage == 1) {
            [weakSelf.moreArray removeAllObjects];
        }
        weakSelf.model = [MBVideoModel mj_objectWithKeyValues:x[@"data"]];
        weakSelf.dataArray = [x[@"data"] objectForKey:@"aVideo"];
        weakSelf.totolNum = [x[@"data"][@"iTotalPageNum"] intValue];
        
        for (NSArray * arr in weakSelf.model.aVideo) {
            [weakSelf.moreArray addObject:arr];
        }
       
        if (weakSelf.model.aVideo.count == 0) {
            weakSelf.currentPage = weakSelf.currentPage - 1;
//            weakSelf.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
//            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];

        }else
        {
            for (NSDictionary * hrefDic in self.dataArray) {
                NSString * hrefStr = [NSString stringWithFormat:@"%@",[hrefDic objectForKey:@"href"]];
                [weakSelf.urlArray addObject:hrefStr];
            }
            
            for (NSArray * array in self.dataArray) {
                [weakSelf.listArray addObject:array];
            }
        }
      
        [self createCollection];
     
        [weakSelf showNoDataLabel];
        weakSelf.cateId = cate;
        [MBProgressHUD hideHUD];
    } error:^(NSError *error) {
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
      [weakSelf nothingview:^{
          [weakSelf update];
      }];
    }];
}

- (void)update {
    self.indexPath = 1;
    WeakSelf
    //http://10.5.45.160/v1/wapVideoLiveCate?timeStamp=1553738873&secretKey=2bc8a3f1ca2c2e01ac088cda109ddd85&videoLive=live
    [[PRNetWork GetVideoCateWith:@{@"videoLive":@"video"}]subscribeNext:^(id x) {
        
        weakSelf.userArray = [MBVideoCateModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [self createCollectionHeaderView];

        if (weakSelf.userArray.count > 0) {
            MBVideoCateModel * model = weakSelf.userArray[0];
            
            for (MBImageView *image in weakSelf.arrayButton) {
                if (image.tag == 0) {
                    [image setImageUrlString:model.checked_thumb];
                }else{
                    
                }
            }
            for (MBImageView *image in self.arrayButtonHead) {
                if (image.tag == 0) {
                    [image setImageUrlString:model.checked_thumb];
                }else{
                    
                }
            }
            
            if ([model.cate_name_en isEqualToString:@"all"]) {
                [weakSelf getVideoList:@"0"];

            }else
            {
                [weakSelf getVideoList:model.cateId];
            }
        }
        
    } error:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [MBProgressHUD hideHUD];
        [weakSelf nothingview:^{
            [weakSelf update];
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.automaticallyAdjustsScrollViewInsets = NO;
    _ismyvideo = 0;
    _modelrray = [NSArray array];
    self.moreArray = [[NSMutableArray alloc] init];
    self.arrayButtonHead = [NSMutableArray array];
    self.arrayButton = [NSMutableArray array];
 //   self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
 //   self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    page = 1;
    _currentPage = 1;

    [self addNavigatView:^(NSString * _Nonnull text) {
        
    }];
    [self update];
    self.urlArray = [NSMutableArray new];
    self.dataArray = [NSMutableArray new];
    self.listArray = [NSMutableArray new];
}

// 显示无数据提示
- (void)showNoDataLabel
{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 25)];
        _noDataLabel.text = @"暂无相关视频";
        _noDataLabel.textColor = [UIColor grayColor];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_noDataLabel];
    }
    if ([self.moreArray count] == 0) {
        _noDataLabel.hidden = NO;
     //   self.collectionView.footer.hidden = YES;
    }
    else{
        _noDataLabel.hidden = YES;
     //   self.collectionView.footer.hidden = NO;

    }
}


//创建collection
- (void)createCollection {
    if (!self.instanceIndex) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
//        layout.headerReferenceSize = CGSizeMake(_window_width, _window_width/6);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout: layout];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(TopHeight);
        }];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.collectionView];
      
        [self.collectionView registerNib:  [UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];
        
        self.instanceIndex = 1;
        
        WEAKSELF
//        self.collectionView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//            weakSelf.currentPage = 1;
//           
//            [self update];
//            
//            }];
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];

//        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//            [self  loadMoreData];
//        }];
        if (self.totolNum > self.currentPage) {
            self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            [(MJRefreshAutoNormalFooter*)self.collectionView.mj_footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        }
        [self.collectionView reloadData];
    }
    [self.collectionView.mj_header endRefreshing];

    if (self.totolNum > self.currentPage){
        [self.collectionView.mj_footer endRefreshing];
    }else{
        if (self.moreArray.count == 0) {
             [(MJRefreshAutoNormalFooter*)self.collectionView.mj_footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        }else{
             [(MJRefreshAutoNormalFooter*)self.collectionView.mj_footer setTitle:@"加载完毕" forState:MJRefreshStateNoMoreData];
        }
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
   
    [self.collectionView reloadData];

    [self.view addSubview:self.showView];
    
    /// 顶部选项卡
    [self.view bringSubviewToFront:self.navigateViewWithSeach];
    [self showNoDataLabel];
    
}
- (void)loadRefreshData {
    self.currentPage = 1;
    self.indexPath = 1;
    [self.moreArray removeAllObjects];
    [self.listArray removeAllObjects];
    [self.urlArray  removeAllObjects];
    [self getVideoList:self.cateId];
}
-(void)loadMoreData{
    _currentPage += 1;
    self.indexPath ++;
//    [self.collectionView.mj_footer resetNoMoreData];
    [self getVideoList:self.cateId];
//    [self.collectionView.mj_footer endRefreshing];
}

- (void)createCollectionHeaderView{
    if (self.collectionHeaderView) {
        [self.collectionHeaderView removeFromSuperview];
        self.collectionHeaderView = nil;
    }
    self.collectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/6+10)];
    self.collectionHeaderView.backgroundColor = [UIColor whiteColor];
    [self.collectionHeaderView addLineLayer:CGRectMake(0, _window_width/6, SCREEN_WIDTH, 0.5) color:[UIColor lightGrayColor]];
    NSArray *liveClass = self.userArray;
    NSInteger count;
    if (liveClass.count>6) {
        count = 5;
        UIButton *allButton = [UIButton buttonWithType:0];
        allButton.frame = CGRectMake(_window_width/6*5, 0, _window_width/6, _window_width/6);
        allButton.tag = 10086;
        [allButton addTarget:self action:@selector(showWhiteView:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionHeaderView addSubview:allButton];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(allButton.width*0.3, allButton.width*0.15, allButton.width*0.4, allButton.width*0.4)];
        [imgView setImage:[UIImage imageNamed:@"quanbu"]];
        [allButton addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+allButton.width/8, allButton.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:@"更多"];
        [allButton addSubview:label];
    }else{
        count = liveClass.count;
    }
    for (int i = 0; i < count; i++) {
        MBVideoCateModel *model = self.userArray[i];
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(i*(_window_width/6), 0, _window_width/6, _window_width/6);
        button.tag = i ;
        [button addTarget:self action:@selector(cateSlect:) forControlEvents:UIControlEventTouchUpInside];
        [self.collectionHeaderView addSubview:button];
        MBImageView *imgView = [[MBImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
        [imgView setImageUrlString:model.thumb placeholoder:@"quanbu"];
        imgView.userInteractionEnabled = false;
        imgView.tag = i;
        [button addSubview:imgView];
        [self.arrayButtonHead addObject:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:model.cate_name];
        [button addSubview:label];
        
    }
    [self showAllview];
}

- (void)showAllview{
    _cateCount = 0;
    NSArray *classArray = self.userArray;
    if (classArray.count % 5 == 0) {
        _cateCount = classArray.count/5;
    }else{
        _cateCount = classArray.count / 5 +1;
    }
    [self.showView removeAllSubViews];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, _cateCount*_window_width/6+20)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.showView addSubview:whiteView];
    CGFloat speace = (_window_width/6)/6;
    for (int i = 0; i < classArray.count; i++) {
        MBVideoCateModel *model = classArray[i];
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(speace + i%5*(_window_width/6+speace) , 2.5 + (i/5)*_window_width/6, _window_width/6, _window_width/6);
        button.tag = i ;
        [button addTarget:self action:@selector(cateSlect:) forControlEvents:UIControlEventTouchUpInside];
        
        [whiteView addSubview:button];
        MBImageView *imgView = [[MBImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
        [imgView setImageUrlString:model.thumb placeholoder:@"quanbu"];
        imgView.userInteractionEnabled = false;
        [button addSubview:imgView];
        [self.arrayButton addObject:imgView];
        imgView.tag = i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:model.cate_name];
        [button addSubview:label];
    }
}
#pragma mark -- collectionViewDelegate


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.moreArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    MBVideoModelList * modelVideo;
//    modelVideo = self.model.aVideo[indexPath.row];
    modelVideo = self.moreArray[indexPath.row];
    [cell config:modelVideo];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    [self.collectionView reloadData];
    LookVideo *video = [[LookVideo alloc]init];
    video.fromWhere = @"myVideoV";
    video.curentIndex = indexPath.row;
    video.videoList =  self.listArray;
    video.pages = _currentPage;
//    video.firstPlaceImage = cell.thumbImageView.image;
    video.requestUrl = self.urlArray[indexPath.row];
    video.cate = self.cateId;
    video.viewVc = 1;
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        page = page;
        self.urlArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    video.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:video animated:YES completion:nil];
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
    
//    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
//    /* arr remove VC1 */
//    [arr removeObject:self];
//    /* arr add VC2 */
//    [arr addObject:video];
//    [self.navigationController setViewControllers:arr animated:YES];
//
//    NSArray *viewControlles = self.navigationController.viewControllers;
//
//        NSMutableArray *newviewControlles = [NSMutableArray array];
//
//        if ([viewControlles count] > 0) {
//
//                for (int i=0; i < [viewControlles count]-1; i++) {
//
//                        [newviewControlles addObject:[viewControlles objectAtIndex:i]];
//
//                    }
//
//            }
//
//        [newviewControlles addObject:video];
//
//        [self.navigationController setViewControllers:newviewControlles animated:YES];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
        return CGSizeMake(SCREEN_WIDTH, _window_width/6+10);
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);
    
    return size;
}

#pragma mark ================ collectionview头视图 ===============


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV" forIndexPath:indexPath];
        
        header.backgroundColor = [UIColor whiteColor];
        [header removeAllSubViews];
        [header addSubview:self.collectionHeaderView];
        return header;
    }else{
        return nil;
    }
}

#pragma mark ================ 分类按钮点击事件 ===============
- (void)showWhiteView:(UIButton*)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, TopHeight, _window_width,SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
        
    }];
}

#pragma mark ==========分类弹框 ==========
- (UIView*)showView{
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, -_cateCount*_window_width/6, SCREEN_WIDTH, _cateCount*_window_width/6+10)];
        _showView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf:)];
        [_showView addGestureRecognizer:gester];
    }
    return _showView;
}

//- (void)showAllview{
//    _cateCount = 0;
//    NSArray *classArray = self.userArray;
//    if (classArray.count % 5 == 0) {
//        _cateCount = classArray.count/5;
//    }else{
//        _cateCount = classArray.count / 5 +1;
//    }
//    [self.showView removeAllSubViews];
//
//    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, _cateCount*_window_width/6+20)];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    [self.showView addSubview:whiteView];
//    CGFloat speace = (_window_width/6)/6;
//    for (int i = 0; i < classArray.count; i++) {
//        MBVideoCateModel *model = classArray[i];
//        UIButton *button = [UIButton buttonWithType:0];
//        button.frame = CGRectMake(speace + i%5*(_window_width/6+speace) , 2.5 + (i/5)*_window_width/6, _window_width/6, _window_width/6);
//        button.tag = i ;
//        [button addTarget:self action:@selector(cateSlect:) forControlEvents:UIControlEventTouchUpInside];
//
//        [whiteView addSubview:button];
//        MBImageView *imgView = [[MBImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
//        [imgView setImageUrlString:model.thumb placeholoder:@"quanbu"];
//        imgView.userInteractionEnabled = false;
//        [button addSubview:imgView];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
//        label.textColor = RGB(99, 99, 99);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont systemFontOfSize:10];
//        [label setText:model.cate_name];
//        [button addSubview:label];
//    }
//}

- (void)cateSlect:(UIButton*)sender{
    self.currentPage = 1;
    NSLog(@"sender.tag %ld",(long)sender.tag);
    MBVideoCateModel *model = self.userArray[sender.tag];
    self.selectIndex = sender.tag;
    for (MBImageView *image in self.arrayButton) {
        if (image.tag == sender.tag) {
            [image setImageUrlString:model.checked_thumb];
        }else{
            MBVideoCateModel *modelin = self.userArray[image.tag];
            [image setImageUrlString:modelin.thumb];
        }
    }
    for (MBImageView *image in self.arrayButtonHead) {
        if (image.tag == sender.tag) {
            [image setImageUrlString:model.checked_thumb];
        }else{
            MBVideoCateModel *modelin = self.userArray[image.tag];
            [image setImageUrlString:modelin.thumb];
        }
    }
    if ([model.cate_name_en isEqualToString:@"all"]) {
        [self getVideoList:@"0"];
    }else
    {
        [self getVideoList:model.cateId];
    }
    [self.moreArray removeAllObjects];
    [self.listArray removeAllObjects];
    [self.urlArray  removeAllObjects];
    [self hideSelf:nil];
}

- (void)hideSelf:(id)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, -_cateCount*_window_width/6, _window_width, _cateCount*_window_width/6+20);
    } completion:^(BOOL finished) {
        
    }];
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
