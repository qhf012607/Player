
//
//  MBWebViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/16.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBWebViewController.h"
#import <WebKit/WebKit.h>
@interface MBWebViewController ()

@property (strong, nonatomic) WKWebView *web;

@end

@implementation MBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.web];
    [self.web mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (WKWebView*)web{
    if (!_web) {
        _web = [[WKWebView alloc]initWithFrame:CGRectZero];
    }
    return _web;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
