//
//  MBSearchViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/10.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBSearchViewController.h"
#import "MBHomeBannerModel.h"
#import "MBHomeSigleModel.h"
#import "MBHomeCollectionViewCell.h"
#import "LookVideo.h"
#import "MBSuperPlayerViewController.h"
#import "MBSearchMoreViewController.h"
@interface MBSearchViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *searchBarView;
@property(nonatomic,strong)MBHomeBannerModel *banner;
@property(nonatomic,strong)UICollectionView *collectview;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic,copy)NSString *searchText;
@property(nonatomic,assign)NSInteger loadindex;
@end

@implementation MBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.searchBarView];
}

- (void)search:(NSString*)keyword{
    
    WeakSelf
    [[PRNetWork searchKeyWork:@{@"key":keyword,@"iUid":[Config getOwnID]?[Config getOwnID]:@""}]subscribeNext:^(id x) {
        weakSelf.banner = [MBHomeBannerModel mj_objectWithKeyValues:x[@"data"]];
        weakSelf.dataArray = x[@"data"][@"aVideo"];
        for (aSuggestVideo *vedio in weakSelf.banner.aVideo) {
            [weakSelf.urlArray addObject:vedio.href];
        }
        [weakSelf initUI];
    } error:^(NSError *error) {
        [weakSelf nothingview:^{
            [weakSelf search:weakSelf.searchText];
        }];
    }];
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
            make.top.mas_equalTo(TopHeight);
        }];
        self.collectview.backgroundColor = [UIColor whiteColor];
        [self.collectview registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal"];
        [self.collectview registerNib:  [UINib nibWithNibName:@"MBHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollect"];
        self.collectview.delegate = self;
        self.collectview.dataSource = self;
        [self.collectview reloadData];
        [self.view bringSubviewToFront:self.navigateViewWithSeach];
    }
    [self.collectview reloadData];
    if (self.banner.aLive.count == 0 && self.banner.aVideo.count == 0) {
        [self showNodata:@"暂无相关数据"];
    } else {
        [self hiddenNodataView];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchText = searchBar.text;
    [searchBar endEditing:true];
    [self search:searchBar.text];
}

- (UIView*)searchBarView{
    if (!_searchBarView) {
        _searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopHeight)];
        _searchBarView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
        [button setImage:[UIImage imageNamed:@"icon-backnewBlack"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(11, 16, 11, 16);
        [_searchBarView addSubview:button];
        [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(44);
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
        }];
       
        UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectZero];
        search.delegate = self;
        [_searchBarView addSubview:search];
        UIImage *imagestre = [UIImage imageNamed:@"searchBar"];
        
        [search setBackgroundImage:    [imagestre stretchableImageWithLeftCapWidth:110 topCapHeight:30]];
        UITextField *searchField = [search valueForKey:@"searchField"];
        
        if (searchField) {
            [searchField setBackgroundColor:[UIColor clearColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        [search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(button.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(button);
        }];
    }
    return _searchBarView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0){
        return self.banner.aLive.count;
    }else {
        return self.banner.aVideo.count;
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MBHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollect" forIndexPath:indexPath];
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if (indexPath.section == 0) {
        modelsigle = self.banner.aLive[indexPath.row];
        [cell config:modelsigle];
    }else {
        video = self.banner.aVideo[indexPath.row];
        [cell configVideo:video];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *viewHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal" forIndexPath:indexPath];
        viewHead.backgroundColor = [UIColor clearColor];
        [viewHead removeAllSubViews];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 20)];
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = [UIColor blackColor];
        if (indexPath.section == 0){
            lab.text = @"相关直播";
        }else if (indexPath.section == 1){
            lab.text = @"相关视频";
            
        }
        [viewHead addSubview:lab];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-38, 16, 38, 18)];
        button.tag = indexPath.section;
        [button addTarget:self action:@selector(gotomoreControll:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"moreBg"] forState:UIControlStateNormal];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [viewHead addSubview:button];
        viewHead.clipsToBounds = true;
        return viewHead;
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.banner.aLive.count == 0){
            return CGSizeMake(SCREEN_WIDTH, 0.1);
        }
    }else if (section == 1){
        if (self.banner.aVideo.count == 0){
            return CGSizeMake(SCREEN_WIDTH, 0.1);
        }
    }
    
      return CGSizeMake(SCREEN_WIDTH, 40);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBHomeSigleModel *modelsigle;
    aSuggestVideo *video;
    if (indexPath.section == 0) {
        modelsigle = self.banner.aLive[indexPath.row];
        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:modelsigle];
    }else {
        video = self.banner.aVideo[indexPath.row];
        //        [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:model];
        LookVideo *video = [[LookVideo alloc]init];
         video.fromWhere = @"MBSearchViewController";
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
    MBSearchMoreViewController *cont = [[MBSearchMoreViewController alloc]init];
    if (!sender.tag) {
        cont.type = @"live";
    }else{
        cont.type = @"video";
    }
    cont.keyword = self.searchText;
    cont.fd_prefersNavigationBarHidden = false;
    [self.navigationController pushViewController:cont animated:true];
}
@end
