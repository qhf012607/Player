//
//  MBHomeViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBHomeViewController.h"
#import "MBHomeModel.h"
#import "MBHomeCollectionViewCell.h"
#import "MBHomeBannerModel.h"
#import "MBSuperPlayerViewController.h"
#import "LookVideo.h"
#import "webH5.h"
#import "MBWebViewController.h"

@import FSPagerView;
@interface MBHomeViewController ()<FSPagerViewDelegate,FSPagerViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)MBHomeModel *model;
@property(nonatomic,strong)FSPagerView *page;
@property(nonatomic,strong)UICollectionView *collectview;
@property(nonatomic,strong)MBHomeBannerModel *banner;
@property(nonatomic,strong)YBNoWordView *noNetwork;
@property(nonatomic, assign)int instanceIndex;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic,strong)FSPageControl *pgControll;
@end

@implementation MBHomeViewController


- (void)setInstanceIndex:(int)instanceIndex{
    _instanceIndex = instanceIndex;
    if (_instanceIndex == 1) {
        [self initUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    [self update];
    [self addNavigatView:^(NSString * _Nonnull text) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [MBCountly countPage:@"首页"];
}
- (void)update{
    WeakSelf
    [self.urlArray removeAllObjects];
    [[PRNetWork GetLunBoWith:@{}]subscribeNext:^(id x) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.banner = [MBHomeBannerModel mj_objectWithKeyValues:x[@"data"]];
        weakSelf.dataArray = x[@"data"][@"aSuggestVideoList"];
        for (aSuggestVideo *vedio in weakSelf.banner.aSuggestVideoList) {
            [weakSelf.urlArray addObject:vedio.href];
        }
        weakSelf.instanceIndex ++;
        [weakSelf reloadUi];
        [weakSelf.collectview.mj_header endRefreshing];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf nothingview:^{
            [weakSelf update];
        }];
    }];
}

- (void)reloadUi{
    [self.page reloadData];
    [self.collectview reloadData];
    self.pgControll.numberOfPages = self.banner.aWapIndexSlide.count;
    if (self.banner.aWapIndexSlide.count<=1) {
        self.pgControll.hidden = true;
        self.page.isInfinite = false;
    }else{
        self.pgControll.hidden = false;
         self.page.isInfinite = true;
    }
    self.pgControll.currentPage = 0 ;
}
- (void)initUI{
    self.page = [[FSPagerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*2/3*4/5)];
    self.page.dataSource = self;
    self.page.delegate = self;
    self.page.automaticSlidingInterval = 4.0;
    self.page.isInfinite = true;
    self.page.transformer = [[FSPagerViewTransformer alloc]initWithType:FSPagerViewTransformerTypeLinear] ;
    self.page.interitemSpacing = 5;
    self.page.itemSize =CGSizeMake(SCREEN_WIDTH-20, SCREEN_WIDTH*2/3*4/5);
    [self.page registerClass:FSPagerViewCell.class forCellWithReuseIdentifier:@"homefaspageview"];
    self.pgControll = [[FSPageControl alloc]initWithFrame:CGRectZero];
    [self.page addSubview:self.pgControll];
    [self.pgControll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    UICollectionViewFlowLayout *lay =   [[UICollectionViewFlowLayout alloc]init];
    lay.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    lay.minimumLineSpacing = 5;
    lay.minimumInteritemSpacing = 5;
    self.collectview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout: lay];
    [self.view addSubview:self.collectview];
    [self.collectview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(TopHeight);
    }];
    self.collectview.backgroundColor = [UIColor whiteColor];
    [self.collectview registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal"];
    [self.collectview registerNib:  [UINib nibWithNibName:@"MBHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollect"];
    self.collectview.delegate = self;
    self.collectview.dataSource = self;
    self.collectview.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
         return self.banner.aLiveInfoList.count;
    }else {
        return self.banner.aSuggestVideoList.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollect" forIndexPath:indexPath];
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if (indexPath.section == 1) {
         modelsigle = self.banner.aLiveInfoList[indexPath.row];
         [cell config:modelsigle];
    }else {
         video = self.banner.aSuggestVideoList[indexPath.row];
         [cell configVideo:video];
    }
   
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *viewHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal" forIndexPath:indexPath];
        viewHead.backgroundColor = [UIColor clearColor];
        viewHead.clipsToBounds = true;
        [viewHead removeAllSubViews];
        if (indexPath.section == 0) {
            [viewHead addSubview:self.page];
            return viewHead;
        }else {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
            lab.font = [UIFont systemFontOfSize:17];
            lab.textColor = [UIColor blackColor];
        if (indexPath.section == 1){
            lab.text = @"热门直播";
        }else if (indexPath.section == 2){
            lab.text = @"热门视频";
        }
        [viewHead addSubview:lab];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-38, 16, 38, 18)];
        button.tag = indexPath.section;
        [button addTarget:self action:@selector(jumpTab:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"moreBg"] forState:UIControlStateNormal];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
        [viewHead addSubview:button];
        return viewHead;
        }
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*2/3*4/5);
    }else{
        if (self.banner.aLiveInfoList.count == 0 && section == 1) {
              return CGSizeMake(SCREEN_WIDTH, 0.1);
        }else if (self.banner.aSuggestVideoList.count == 0 && section == 2){
              return CGSizeMake(SCREEN_WIDTH, 0.1);
        }
        return CGSizeMake(SCREEN_WIDTH, 40);
    }
  
}

- (NSInteger)numberOfItemsInPagerView:(FSPagerView *)pagerView{
    return self.banner.aWapIndexSlide.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if (indexPath.section == 1) {
        modelsigle = self.banner.aLiveInfoList[indexPath.row];
        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:modelsigle];
    }else {
        video = self.banner.aSuggestVideoList[indexPath.row];
//        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:model];
//        MBVideoPlayerViewController *cont = [[MBVideoPlayerViewController alloc]init];
//        cont.fd_prefersNavigationBarHidden = true;
//        [self.navigationController pushViewController:cont animated:true];
        LookVideo *video = [[LookVideo alloc]init];
        video.fromWhere = @"MBHomeViewController";
        video.curentIndex = indexPath.row;
        video.videoList =  [NSMutableArray arrayWithArray:self.dataArray] ;
        video.cate = 0;
        //    video.firstPlaceImage = cell.thumbImageView.image;
        video.requestUrl = self.urlArray[indexPath.row];
        //        video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        //            page = page;
        //            self.urlArray = array;
        //            [self.collectionView reloadData];
        //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        //        };
        video.viewVc = 1;
        video.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:video animated:true];
    }
  
}


- (FSPagerViewCell*)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"homefaspageview" atIndex:index];
    aWapIndex *model = self.banner.aWapIndexSlide[index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.slide_pic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.clipsToBounds = true;
    cell.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}


- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index{
    aWapIndex * model = self.banner.aWapIndexSlide[index];
    self.pgControll.currentPage = index;
    if (model.slide_url.length > 0) {
        MBWebViewController  *h5 = [[MBWebViewController alloc]init];
        h5.url = model.slide_url;
        [self.navigationController pushViewController:h5 animated:true];
    }
}

- (void)pagerViewDidScroll:(FSPagerView *)pagerView{
    self.pgControll.currentPage = pagerView.currentIndex;
}


- (void)pushToPlay:(NSString*)type model:(MBHomeSigleModel*)model{
    MBSuperPlayerViewController *cont = [[MBSuperPlayerViewController alloc]init];
    cont.fd_prefersNavigationBarHidden = true;
    cont.livetype = type;
    cont.model = model;
    [self.navigationController pushViewController:cont animated:true];
}

-(void)checklive:(NSString *)stream andliveuid:(NSString *)liveuid model:(MBHomeSigleModel*)model{
    [self pushToPlay:@"1" model:model];
    return;
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
                
                NSString * livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                
                if ([type isEqual:@"0"]) {
                    [self pushToPlay:livetype model:model];
                }
                
                
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
    }
    
}

- (void)jumpTab:(UIButton*)sender{
    self.tabBarController.selectedIndex = sender.tag;
}
@end
