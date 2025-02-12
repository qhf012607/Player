//
//  webH5.m
//  yunbaolive
//
//  Created by zqm on 16/5/16.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "webH5.h"
#import "LivePlay.h"
//#import "CoinVeiw.h"
@interface webH5 ()<UIWebViewDelegate>
{
    UIWebView *wevView;
    int setvisshenqing;
    UIActivityIndicatorView *testActivityIndicator;//菊花

}
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation webH5
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    setvisshenqing = 1;
    [self navtion];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    wevView = [[UIWebView alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:_urls];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wevView loadRequest:request];
    wevView.backgroundColor = [UIColor whiteColor];
    wevView.frame = CGRectMake(0,TopHeight, _window_width, _window_height - TopHeight);
    wevView.delegate = self;
    [self.view addSubview:wevView];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    if ([url containsString:@"copy://"]) {
        NSString *results = [url substringFromIndex:7];
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = results;
        [MBProgressHUD showError:@"复制成功"];
        return NO;
    }
    if ([url containsString:@"phonelive://pay"]) {
//        CoinVeiw *coins = [[CoinVeiw alloc]init];
//        [self.navigationController pushViewController:coins animated:YES];
        return NO;
    }
    return YES;
}
//设置导航栏标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, TopHeight)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = _titles;
    [self.titleLab setFont:navtionTitleFont];
    
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0,24 + KStatusBarMargin,_window_width,40);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0,KStatusBarMargin, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + KStatusBarMargin,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    [self.view addSubview:navtion];
}
-(void)doReturn{
    
    NSString *nowUrl = wevView.request.URL.absoluteString;
    NSLog(@"当前请求url为%@",nowUrl);
    NSString *aboutUrl = _urls;
    
    if([nowUrl isEqualToString:aboutUrl]  || nowUrl.length == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated: YES completion:nil];
        
        if ([_isjingpai isEqual:@"isjingpai"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isjingpai" object:nil];
        }
        
    }else if([self.titleLab.text isEqualToString:@"提交成功"] || [self.titleLab.text isEqualToString:@"申请进度"]|| [self.titleLab.text isEqualToString:@"我的家族"]){
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated: YES completion:nil];
        
        
    }
    else
    {
        [wevView goBack];
    }

}
@end
