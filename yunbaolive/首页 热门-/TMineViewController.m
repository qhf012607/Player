//
//  TMineViewController.m
//  yunbaolive
//
//  Created by Jolly on 27/04/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "TMineViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import "ZFDouYinCell.h"
#import "ZFDouYinControlView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MJRefresh/MJRefresh.h>
static NSString *kIdentifier = @"kIdentifier";
@interface TMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) ZFPlayerController * player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation TMineViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    self.fd_prefersNavigationBarHidden = YES;
    [self requestData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @strongify(self)
        if (size.width >= size.height) {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        } else {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        }
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}

- (void)loadNewData {
    [self.dataSource removeAllObjects];
    [self.urls removeAllObjects];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
        [self.player stopCurrentPlayingCell];
        [self requestData];
        [self.tableView reloadData];
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *videoList = [rootDict objectForKey:@"list"];
//    NSMutableArray *videoList = self.videoUrlArr;
    for (NSString  * video_url in self.videoUrlArr) {
//        ZFTableData *data = [[ZFTableData alloc] init];
//        [data setValuesForKeysWithDictionary:dataDic];
//        [self.dataSource addObject:data];
        
        NSString *URLString = [video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];
        [self.urls addObject:url];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.videoUrlArr.count-1) {
        /// 加载下一页数据
        [self requestData];
        self.player.assetURLs = self.urls;
        [self.tableView reloadData];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoUrlArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    cell.data = self.videoUrlArr[indexPath.row];
    [cell.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults * users = [NSUserDefaults standardUserDefaults];
    NSInteger x = [[users objectForKey:@"index"]integerValue];
//    if (x == 5) {
//        [cell.likeBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//    }else
//    {
        [cell.likeBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
//    }

    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method

- (void)backClick:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
//    ZFTableData *data = self.videoUrlArr[indexPath.row];
    UIViewContentMode imageMode;
//    if (data.thumbnail_width >= data.thumbnail_height) {
//        imageMode = UIViewContentModeScaleAspectFit;
//    } else {
        imageMode = UIViewContentModeScaleAspectFill;
//    }
//    [self.controlView showCoverViewWithUrl:data.thumbnail_url withImageMode:imageMode];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@(indexPath.row) forKey:@"index"];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (indexPath.row == self.videoUrlArr.count-1) {
                /// 加载下一页数据
                [self requestData];
                self.player.assetURLs = self.urls;
                [self.tableView reloadData];
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"返回_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


- (void)likeBtnClick{
    NSLog(@"点赞");
    NSUserDefaults * users = [NSUserDefaults standardUserDefaults];
    NSInteger i = [[users objectForKey:@"index"] integerValue];
    
    NSLog(@"当前视频  ==== 》 %ld",(long)i);
    
    
    NSString * userid = [NSString stringWithFormat:@"%@",[Config getOwnID]];
    
    NSLog(@"当前用户id %@",userid);
    
    
}

@end
