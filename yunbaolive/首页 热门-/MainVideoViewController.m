//
//  MainVideoViewController.m
//  yunbaolive
//
//  Created by Jolly on 15/04/2019.
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
#import "MBVideoDetailViewController.h"
@import FSPagerView;
@interface MainVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,tuijian,UIScrollViewDelegate,UITextFieldDelegate>
{
//    UIView *collectionHeaderView;
    allClassView *allClassV;
    int page;


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
@end

@implementation MainVideoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%f",_collectionView.contentOffset.y);
   
    WeakSelf
    
    [[PRNetWork GetVideoCateWith:nil]subscribeNext:^(id x) {        
    
    weakSelf.userArray = [MBVideoCateModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [self createCollectionHeaderView];

        if (weakSelf.userArray.count > 0) {
            MBVideoCateModel * model = weakSelf.userArray[0];
            [weakSelf getVideoList:model.cateId];
        }
    
    } error:^(NSError *error) {
        
    }];
    
}
- (void)getVideoList:(NSString *)cate {
    WeakSelf
 NSDictionary * dic = @{@"timeStamp":@"1553738873",@"secretKey":@"9d7c51501a1aa06b2ddfb359ae73afdc",@"pageNum":@"1",@"cate_id":cate};
    [[PRNetWork GetVideoListWith:dic]subscribeNext:^(id x) {
        weakSelf.model = [MBVideoModel mj_objectWithKeyValues:x[@"data"]];
        NSString * str = x[@"msg"];
        NSLog(@"===== str  %@",str);
        [self createCollection];

    } error:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _ismyvideo = 0;
    _modelrray = [NSArray array];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    page = 1;

    
    [self addLogoView];
    

}


// 顶部导航栏
- (void)addLogoView
{
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80 * Rate)];
    self.logoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logoView];
    
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 110, 40)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
//    logoImageView.backgroundColor = [UIColor cyanColor];
    [self.logoView addSubview:logoImageView];
    
    // 搜索框
    UIView *searchBackView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 50, 40, 180, 30)];
    //    searchBackView.layer.masksToBounds = YES;
    //    searchBackView.layer.cornerRadius = 15;
    searchBackView.layer.borderWidth = 1;
    searchBackView.layer.borderColor = [[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f] CGColor];
    //    searchBackView.backgroundColor = [UIColor blueColor];
    //  searchBackView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    searchBackView.userInteractionEnabled = YES;
    searchBackView.tag = 200;
    //    UITapGestureRecognizer *tapForSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForSearchVC:)];
    //    [searchBackView addGestureRecognizer:tapForSearch];
    [self.logoView addSubview:searchBackView];
    
    /// 搜索图片
    /// 左边图片
    UIImageView *searchImgV = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,20,20)];
    searchImgV.image = [UIImage imageNamed:@"home_search"];
    [searchBackView addSubview:searchImgV];
    
    /// 右边图片
    UIImageView *rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(searchBackView.frame) - 25, 5, 20, 20)];
    rightImgV.image = [UIImage imageNamed:@"home_search"];
    [searchBackView addSubview:rightImgV];
    
    /// 搜索提示文字
    self.searchText = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, 180, 30)];
    self.searchText.font = [UIFont systemFontOfSize:14.0f];
    self.searchText.textColor = [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f];
    self.searchText.placeholder = @"搜索";
    self.searchText.delegate = self;
    self.searchText.returnKeyType = UIReturnKeySearch;
    [searchBackView addSubview:self.searchText];
    
    ///
    //私信
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    messageBtn.frame = CGRectMake(_window_width-40,24 +statusbarHeight,40,60);
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtn setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.logoView addSubview:messageBtn];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, CGRectGetWidth(self.view.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [self.logoView addSubview:lineView];
}

//创建collection
- (void)createCollection {
    if (!self.instanceIndex) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.headerReferenceSize = CGSizeMake(_window_width, _window_width/6);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.logoView.frame)) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.collectionView];
        [self.collectionView registerNib:  [UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"videoCell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];
        
        self.instanceIndex = 1;
    }
    
    [self.collectionView reloadData];
    [self showAllview];
    [self.view addSubview:self.showView];
    
    /// 顶部选项卡
//    [self.view bringSubviewToFront:self.navigateViewWithSeach];
   
    
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
        [button addSubview:imgView];
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
    
    return self.model.aVideo.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    VideoCollectionViewCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    MBVideoModelList * modelVideo;
    
    modelVideo = self.model.aVideo[indexPath.row];
    [cell config:modelVideo];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBVideoDetailViewController * video = [[MBVideoDetailViewController alloc] init];
//    VideoCollectionViewCell * cell = (VideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    LookVideo * video = [[LookVideo alloc] init];
//    video.fromWhere = @"myVideoV";
//    video.curentIndex = indexPath.row;
//    video.videoList = self.model.aVideo;
//    video.firstPlaceImage = cell.iconImage.image;
//    video.requestUrl = _url;
//    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
//        page = page;
//        self.allArray = array;
//        [self.collectionView reloadData];
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//    };
    video.hidesBottomBarWhenPushed = YES;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
    

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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:model.cate_name];
        [button addSubview:label];
    }
}

- (void)cateSlect:(UIButton*)sender{
    MBVideoCateModel *model = self.userArray[sender.tag];
    [self getVideoList:model.cateId];
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
