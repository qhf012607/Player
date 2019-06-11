//
//  MBRootViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/23.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBRootViewController.h"
#import "MBSearchViewController.h"

@interface MBRootViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)YBNoWordView *noNetwork;
@property(nonatomic,strong)UILabel *labNodata;
@end

@implementation MBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.fd_interactivePopDisabled = true;
}

-(void)buildUpdate{
    // 在这里加载后台配置文件
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=Home.getConfig"];
    
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *subdic = [[data valueForKey:@"info"] firstObject];
                if (![subdic isEqual:[NSNull null]]) {
                    liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                    [common saveProfile:commons];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)nothingview:(void(^)())refresh{
    [self. noNetwork removeFromSuperview];
    WeakSelf
    self. noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [weakSelf.noNetwork removeFromSuperview];
         refresh();
    }];
    [self.view addSubview:self.noNetwork];
    
}

- (void)login:(UIGestureRecognizer*)gester{
    if ([Config getOwnID]) {
        self.tabBarController.selectedIndex = 3;
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:LoginNotifacation object:nil];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar endEditing:true];
    [self goSearch];
}

- (void)goSearch{
    MBSearchViewController *cont = [[MBSearchViewController alloc]init];
    cont.fd_prefersNavigationBarHidden = true;
    [self.navigationController pushViewController:cont animated:true];
}

- (UIView*)navigateViewWithSeach{
    if (!_navigateViewWithSeach) {
        _navigateViewWithSeach = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopHeight)];
        _navigateViewWithSeach.backgroundColor = [UIColor whiteColor];
        UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_navigateViewWithSeach addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-7);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        logoImageView.image = [UIImage imageNamed:@"logo"];
        MBImageView *imageRight = [[MBImageView alloc]initWithFrame:CGRectZero];
        [_navigateViewWithSeach addSubview:imageRight];
        [imageRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(logoImageView);
        }];
        imageRight.image = [UIImage imageNamed:@"zhuce"];
//        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login:)];
//        [imageRight addGestureRecognizer:gester];
        UIButton *buton = [[UIButton alloc]initWithFrame:CGRectZero];
         [_navigateViewWithSeach addSubview:buton];
        [buton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageRight);
            make.left.equalTo(imageRight.mas_left).offset(-5);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        [buton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectZero];
        [_navigateViewWithSeach addSubview:search];
        search.delegate = self;
        UIImage *imagestre = [UIImage imageNamed:@"searchBar"];
    
         [search setBackgroundImage:    [imagestre stretchableImageWithLeftCapWidth:110 topCapHeight:30]];
        UITextField *searchField = [search valueForKey:@"searchField"];
        
        if (searchField) {
            [searchField setBackgroundColor:[UIColor clearColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        [search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logoImageView.mas_right).offset(10);
            make.right.mas_equalTo(imageRight.mas_left).offset(-10);
            make.height.mas_equalTo(logoImageView);
            make.centerY.mas_equalTo(logoImageView);
        }];
    }
    return _navigateViewWithSeach;
}

- (void)addNavigatView:(void(^)(NSString *text))search{
    [self.view addSubview:self.navigateViewWithSeach];
}

- (UIButton*)addBackButtonWithoutNavBar{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 25, 44, 44)];
    [button setImage:[UIImage imageNamed:@"icon-backnew"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(1, 10, 1, 10);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:true];
}


- (void)setNewOrientation:(BOOL)fullscreen

{
    
    if (fullscreen) {
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }else{
        
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
        
        
        
        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
        
    }
    
}

- (void)showNodata:(NSString*)noDatamsg{
    [self.view addSubview:self.labNodata];
    [self.labNodata mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.labNodata.text = noDatamsg;
}

- (void)hiddenNodataView{
    [self.labNodata removeFromSuperview];
}


- (UILabel*)labNodata{
    if (!_labNodata) {
        _labNodata = [[UILabel alloc]initWithFrame:CGRectZero];
        _labNodata.textColor = [UIColor lightGrayColor];
        _labNodata.font = [UIFont systemFontOfSize:12];
        _labNodata.textAlignment = NSTextAlignmentCenter;
    }
    return _labNodata;
}
@end
