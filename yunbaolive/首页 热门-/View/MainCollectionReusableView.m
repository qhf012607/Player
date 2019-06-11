//
//  MainCollectionReusableView.m
//  Mbb
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 WHSS. All rights reserved.
//

#import "MainCollectionReusableView.h"
#import "SDCycleScrollView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface MainCollectionReusableView()<SDCycleScrollViewDelegate,UIGestureRecognizerDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) NSMutableArray * imageUrlArray;
@property (nonatomic, strong) NSMutableArray *cycleModelArr;
@end

@implementation MainCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.imageUrlArray = [[NSMutableArray alloc] init];
        self.cycleModelArr = [[NSMutableArray alloc]init];
//        self.delegate = self;
        [self layouUI];
//        [self downLoadData];
        //getLocationString
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocationStr:) name:@"getLocationString" object:nil];
    }
    return self;
}

- (void)layouUI{
    __weak __typeof (self)weakSelf = self;
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 210) delegate:self placeholderImage: [UIImage imageNamed:@"placeholder"]];
    self.scrollView.backgroundColor = [UIColor cyanColor];
//    self.scrollView.pageControlBottomOffset = 0;
    NSArray * scrollViewImage = @[@"0.jpg",@"1.jpg",@"2.jpg"];
    //    weakSelf.scrollView.imageURLStringsGroup = weakSelf.imageUrlArray;
    self.scrollView.imageURLStringsGroup = scrollViewImage;
    
    self.scrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    self.scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.titlesGroup = nil;
    self.scrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
//    self.scrollView.imageURLStringsGroup = imgArr;
//    [[APIClient sharedClient] get:@"centerbanner/list" params:@{@"type":@"G1"} success:^(NSDictionary *responseObject) {
//        NSLog(@"轮播图responseObject %@",responseObject);
//
//        NSArray * itemArr = responseObject[@"data"];
//        for (NSDictionary * dic in itemArr) {
//            CycleScrollModel *cycleModel = [CycleScrollModel setScrollModel:dic];
//            [weakSelf.cycleModelArr addObject:cycleModel];
//
//            NSString * imagePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"path"]];
//            [weakSelf.imageUrlArray addObject:imagePath];
//
//        }
//        weakSelf.scrollView.imageURLStringsGroup = weakSelf.imageUrlArray;
//    } failure:^(NSError *error) {
//        NSLog(@"error %@",error);
//
//    }];
//

    self.scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        
        NSLog(@"点击了第%ld张图片",(long)currentIndex);
//        CycleScrollModel *cycleModel = weakSelf.cycleModelArr[currentIndex];
//        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pushGoodsDetailsView:withKind:)]) {
//            [weakSelf.delegate pushGoodsDetailsView:cycleModel.markId withKind:cycleModel.markType];
//        }
//
    };
    [self addSubview: self.scrollView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH, 50)];
    [self addSubview:bottomView];
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 130, 44)];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    leftLabel.font = [UIFont systemFontOfSize:17];
    leftLabel.text = @"热门推荐";
//    leftLabel.attributedText = stringWithImageAndStrWithWidthAndHeight(@"热销", @"  采购推荐", 17, 17);
    [bottomView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 35, 44)];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = [UIFont systemFontOfSize:14.f];
    rightLabel.text = @"更多";
    rightLabel.textColor =  [UIColor redColor];;
    rightLabel.tag = 300;
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *forMore = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForNextVC:)];
    [rightLabel addGestureRecognizer:forMore];
    [bottomView addSubview:rightLabel];
    
    UIImageView *rightV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightLabel.frame),15, 5, 10)];
    rightV.image = [UIImage imageNamed:@"更多箭头"];
    [bottomView addSubview:rightV];
    
    
}

- (void)getLocationStr:(NSNotification *)noti {
    NSString *locationStr = noti.userInfo[@"locationStr"];
//    self.locationLabel.attributedText = stringWithImageAndStrWithWidthAndHeight(@"定位", locationStr, 13, 13);
}

- (void)WithImgs:(NSArray *)imgArr WithAddress:(NSString *)Address {
    
//    self.locationLabel.attributedText = stringWithImageAndStrWithWidthAndHeight(@"定位", Address, 13, 13);
//    self.scrollView.imageURLStringsGroup = imgArr;

}

#pragma mark -- 点击事件处理

//200-顶部搜索框。100-中间四个分类。300-更多按钮
- (void)tapForNextVC:(UITapGestureRecognizer *)tap {
    
    NSInteger kind = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushNextView:)]) {
        [self.delegate pushNextView:kind];
    }
}



@end
