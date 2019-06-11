//
//  MBAlivePlayerViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/25.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBAlivePlayerViewController.h"
#import "MBHomeSigleModel.h"
#import "MBHomeCollectionViewCell.h"
#import "MBAliveCateModel.h"
#import "YBNoWordView.h"
#import "MBSuperPlayerViewController.h"
@interface MBAlivePlayerViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIView *collectionHeaderView;
@property(nonatomic,strong)UICollectionView *collectview;

@property(nonatomic,strong)YBNoWordView *noNetwork;

@property(nonatomic,copy)NSArray *arrayCate;

@property(nonatomic,assign)int instanceIndex;

@property(nonatomic,copy)NSArray *arrayItmes;

@property(nonatomic,strong)UIView *showView;

@property(nonatomic,assign)NSInteger cateCount;

@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,strong)NSMutableArray *arrayButton;
@property(nonatomic,strong)NSMutableArray *arrayButtonHead;
@end

@implementation MBAlivePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayButtonHead = [NSMutableArray array];
    self.arrayButton = [NSMutableArray array];
    [MBProgressHUD showMessage:@"正在加载" toView:self.view];
    [self updateCate];
  
    [self addNavigatView:^(NSString * _Nonnull text) {
        
    }];
}

- (void)updateCate{
    WeakSelf
    [[PRNetWork GetAliveCate:@{@"videoLive":@"live"}]subscribeNext:^(id x) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.arrayCate = [MBAliveCateModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [weakSelf createCollectionHeaderView];
        if (weakSelf.arrayCate.count > 0) {
            MBAliveCateModel *model = weakSelf.arrayCate[0];
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
            [weakSelf getAliveList:model.live_catename_en];
        }
    } error:^(NSError *error) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf nothingview:^{
            [weakSelf updateCate];
        }];
    }];
}

- (void)getAliveList:(NSString*)cate{
    WeakSelf
    NSDictionary *dic = @{@"cate_name_en":cate};
    [[PRNetWork GetAliveList:dic]subscribeNext:^(id x) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
        weakSelf.arrayItmes = [MBHomeSigleModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        [weakSelf initUI];
    } error:^(NSError *error) {
          [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf nothingview:^{
            [weakSelf updateCate];
        }];
    }];
}

- (void)createCollectionHeaderView{
    if (self.collectionHeaderView) {
        [self.collectionHeaderView removeFromSuperview];
        self.collectionHeaderView = nil;
    }
    self.collectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/6+10)];
    self.collectionHeaderView.backgroundColor = [UIColor whiteColor];
    [self.collectionHeaderView addLineLayer:CGRectMake(0, _window_width/6, SCREEN_WIDTH, 0.5) color:[UIColor lightGrayColor]];
    NSArray *liveClass = self.arrayCate;
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
        MBAliveCateModel *model = self.arrayCate[i];
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
        [label setText:model.name];
        [button addSubview:label];
        
    }
    [self showAllview];
}

- (void)initUI{
    if (!self.instanceIndex) {
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
        self.instanceIndex = 1;
        self.collectview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        
    }
    [self.collectview reloadData];
  
    [self.view addSubview:self.showView];
    if (self.arrayItmes.count == 0) {
        [self showNodata:@"暂无相关直播"];
    }else{
        [self hiddenNodataView];
    }
    [self.collectview.mj_header endRefreshing];
    [self.view bringSubviewToFront:self.navigateViewWithSeach];
}

- (void)refresh{
    MBAliveCateModel *model = self.arrayCate[self.selectIndex];
    [self getAliveList:model.live_catename_en];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
      return self.arrayItmes.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *viewHead = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"normal" forIndexPath:indexPath];
        viewHead.backgroundColor = [UIColor clearColor];
        [viewHead removeAllSubViews];
        [viewHead addSubview:self.collectionHeaderView];
        return viewHead;
    }else{
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, _window_width/6+10);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 1);
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeMake( (SCREEN_WIDTH-15)/2, (SCREEN_WIDTH-15)/4);
    
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBHomeSigleModel *model = self.arrayItmes[indexPath.row];
    [self  checklive:@"22001_1556599058" andliveuid:@"22001" model:model];
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
    NSString *param = [NSString stringWithFormat:@"uid=%@&token=%@&liveuid=%@&stream=%@",[Config getOwnID],[Config getOwnToken],model.uid,model.stream];
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
        MBHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollect" forIndexPath:indexPath];
        MBHomeSigleModel *modelsigle;
    
        modelsigle = self.arrayItmes[indexPath.row];
        [cell config:modelsigle];
    
        return cell;
}

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
    NSArray *classArray = self.arrayCate;
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
        MBAliveCateModel *model = classArray[i];
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
        [label setText:model.name];
        [button addSubview:label];
    }
}

- (void)cateSlect:(UIButton*)sender{
    MBAliveCateModel *model = self.arrayCate[sender.tag];
    self.selectIndex = sender.tag;
    for (MBImageView *image in self.arrayButton) {
        if (image.tag == sender.tag) {
            [image setImageUrlString:model.checked_thumb];
        }else{
            MBAliveCateModel *modelin = self.arrayCate[image.tag];
            [image setImageUrlString:modelin.thumb];
        }
    }
    for (MBImageView *image in self.arrayButtonHead) {
        if (image.tag == sender.tag) {
            [image setImageUrlString:model.checked_thumb];
        }else{
            MBAliveCateModel *modelin = self.arrayCate[image.tag];
            [image setImageUrlString:modelin.thumb];
        }
    }
    [self getAliveList:model.live_catename_en];
    [self hideSelf:nil];
}

- (void)hideSelf:(id)sender{
   
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, -_cateCount*_window_width/6, _window_width, _cateCount*_window_width/6+20);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showWhiteView:(UIButton*)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, TopHeight, _window_width,SCREEN_HEIGHT);
      
    } completion:^(BOOL finished) {
    
        
    }];
}

@end
