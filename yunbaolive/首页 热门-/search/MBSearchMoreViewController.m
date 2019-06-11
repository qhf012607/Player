//
//  MBSearchMoreViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/12.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBSearchMoreViewController.h"
#import "MBHomeBannerModel.h"
#import "MBHomeSigleModel.h"
#import "MBHomeCollectionViewCell.h"
#import "LookVideo.h"
#import "MBSuperPlayerViewController.h"

@interface MBSearchMoreViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)UICollectionView *collectview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic,strong)NSMutableArray *alldataArray;
@property(nonatomic,copy)NSString *searchText;
@property(nonatomic,assign)NSInteger loadindex;
@property(nonatomic,assign)NSInteger indexPath;
@property(nonatomic,assign)NSInteger totolNum;
@end

@implementation MBSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    self.urlArray = [NSMutableArray array];
    self.alldataArray = [NSMutableArray array];
    [MBProgressHUD showMessage:@""];
    if ([self.type isEqualToString:@"live"]) {
         self.title = @"更多直播";
    }else{
         self.title = @"更多视频";
    }
    [self update];
}

- (void)update{
    self.indexPath = 1;
    [self.dataArray removeAllObjects];
    [self.urlArray removeAllObjects];
    [self.alldataArray removeAllObjects];
    [self request];
}

- (void)request{
    WeakSelf
    [[PRNetWork searchMore:@{@"key":_keyword,@"videoLive":_type,@"pageNum":@(_indexPath)}]subscribeNext:^(id x) {
        if ([weakSelf.type isEqualToString:@"video"]) {
            [ weakSelf.dataArray addObjectsFromArray:x[@"data"][@"aVideo"] ];
            NSArray *array = [aSuggestVideo mj_objectArrayWithKeyValuesArray:x[@"data"][@"aVideo"] ];
            [ weakSelf.alldataArray addObjectsFromArray:array ];
            for (aSuggestVideo *vedio in weakSelf.alldataArray) {
                [weakSelf.urlArray addObject:vedio.href];
            }
        } else {
            NSArray *array = [MBHomeSigleModel mj_objectArrayWithKeyValuesArray:x[@"data"][@"aLive"] ];
            [ weakSelf.alldataArray addObjectsFromArray:array ];
        }
        weakSelf.totolNum = [x[@"data"][@"iTotalPageNum"] intValue];
        [weakSelf initUI];
        [MBProgressHUD hideHUD];
    } error:^(NSError *error) {
         [MBProgressHUD hideHUD];
        [weakSelf nothingview:^{
            [weakSelf update];
        }];
    }];
}

- (void)endRefresh{
   
}

- (void)loadMore{
    self.indexPath ++;
    [self request];
}

- (void)initUI{
    if (!self.loadindex) {
        self.loadindex = 1;
        UICollectionViewFlowLayout *lay =   [[UICollectionViewFlowLayout alloc]init];
        lay.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        lay.minimumLineSpacing = 5;
        lay.minimumInteritemSpacing = 5;
        self.collectview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout: lay];
        [self.view addSubview:self.collectview];
        [self.collectview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        self.collectview.backgroundColor = [UIColor whiteColor];
        [self.collectview registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal"];
        [self.collectview registerNib:  [UINib nibWithNibName:@"MBHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollect"];
        self.collectview.delegate = self;
        self.collectview.dataSource = self;
       
        [self.view bringSubviewToFront:self.navigateViewWithSeach];
         self.collectview.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(update)];
        if (self.totolNum > self.indexPath) {
            self.collectview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
             [(MJRefreshAutoNormalFooter*)self.collectview.mj_footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        }
         [self.collectview reloadData];
    }
    [self.collectview.mj_header endRefreshing];
    if (self.totolNum > self.indexPath){
        [self.collectview.mj_footer endRefreshing];
    }else{
        [self.collectview.mj_footer endRefreshingWithNoMoreData];
    }
    [self.collectview reloadData];
   
    if (self.alldataArray.count == 0) {
        [self showNodata:@"暂无相关数据"];
    } else {
        [self hiddenNodataView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     return self.alldataArray.count;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollect" forIndexPath:indexPath];
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if ([_type isEqualToString:@"live"]) {
        modelsigle = self.alldataArray[indexPath.row];
        [cell config:modelsigle];
    }else {
        video = self.alldataArray[indexPath.row];
        [cell configVideo:video];
    }
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if ([_type isEqualToString:@"live"]) {
        modelsigle = self.alldataArray[indexPath.row];
        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:modelsigle];
    }else {
        video = self.alldataArray[indexPath.row];
        //        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:model];
        LookVideo *video = [[LookVideo alloc]init];
         video.fromWhere = @"MBSearchMoreViewController";
        video.curentIndex = indexPath.row;
        video.videoList =   [NSMutableArray arrayWithArray:self.dataArray] ;
        video.pages = 1;
        //    video.firstPlaceImage = cell.thumbImageView.image;
        video.requestUrl = self.urlArray[indexPath.row];
        //        video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        //            page = page;
        //            self.urlArray = array;
        //            [self.collectionView reloadData];
        //            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        //        };
        video.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:video animated:true];
    }
    
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


- (void)pushToPlay:(NSString*)type model:(MBHomeSigleModel*)model{
    MBSuperPlayerViewController *cont = [[MBSuperPlayerViewController alloc]init];
    cont.fd_prefersNavigationBarHidden = true;
    cont.livetype = type;
    cont.model = model;
    [self.navigationController pushViewController:cont animated:true];
}

- (void)gotomoreControll:(UIButton*)sender{
    
}
@end
