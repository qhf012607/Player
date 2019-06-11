//
//  ForgetPassViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/7.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "ForgetPassNextViewController.h"
@interface ForgetPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userAcount;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *sureButtn;
@property (strong, nonatomic) NSTimer *messsageTimer;
@property (assign, nonatomic) NSInteger messageIssssss;
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackButtonWithoutNavBar];
    [self.getCode addTarget:self action:@selector(clickYanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureButtn addTarget:self action:@selector(gotoResetPass:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)daojishi{
    [_getCode setTitle:[NSString stringWithFormat:@"%lds",(long)_messageIssssss] forState:UIControlStateNormal];
    _getCode.userInteractionEnabled = NO;
    if (_messageIssssss<=0) {
        [_getCode setTitle:@"发送验证" forState:UIControlStateNormal];
        _getCode.userInteractionEnabled = YES;
        [_messsageTimer invalidate];
        _messsageTimer = nil;
        _messageIssssss = 60;
    }
    _messageIssssss-=1;
}
- (IBAction)clickYanzhengma:(id)sender {
    if (_userAcount.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (_userAcount.text.length!=11){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    _getCode.userInteractionEnabled = NO;
    _messageIssssss = 60;
    if (_messsageTimer == nil) {
        _messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
    }
    
    NSDictionary *ForgetCode = @{
                                 @"mobile":_userAcount.text,
                                 @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",_userAcount.text]]
                                 };
    
    [YBToolClass postNetworkWithUrl:@"Login.getForgetCode" andParameter:ForgetCode success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        NSLog(@"info  ====  %@",info);
        if (code == 0) {
            [MBProgressHUD showError:@"发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            
        }else{
            _getCode.userInteractionEnabled = YES;
            [MBProgressHUD showError:msg];
            
        }
    } fail:^{
        _getCode.userInteractionEnabled = YES;
        
    }];
    
}

- (IBAction)gotoResetPass:(id)sender{
    if (_userAcount.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (_userAcount.text.length!=11){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    
    if (_codeText.text.length == 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    
    ForgetPassNextViewController *cont = [[ForgetPassNextViewController alloc]init];
    cont.fd_prefersNavigationBarHidden = true;
    cont.telephone = _userAcount.text;
    cont.codeNum = _codeText.text;
    [self.navigationController pushViewController:cont animated:true];
}

@end
