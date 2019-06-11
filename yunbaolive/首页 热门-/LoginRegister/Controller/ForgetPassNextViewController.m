//
//  ForgetPassNextViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/8.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "ForgetPassNextViewController.h"

@interface ForgetPassNextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserAcount;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (assign, nonatomic) NSInteger messageIssssss;
@property (strong, nonatomic) NSTimer *messsageTimer;

@end

@implementation ForgetPassNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButtonWithoutNavBar];
    [self.getCode addTarget:self action:@selector(clickYanzhengma:) forControlEvents:UIControlEventTouchUpInside];

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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)clickYanzhengma:(id)sender {
    if (_UserAcount.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (_UserAcount.text.length!=11){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    _getCode.userInteractionEnabled = NO;
    _messageIssssss = 60;
    if (_messsageTimer == nil) {
        _messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
    }
    
    NSDictionary *ForgetCode = @{
                                 @"mobile":_UserAcount.text,
                                 @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",_UserAcount.text]]
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
- (IBAction)clickFindBtn:(id)sender {
    
    NSDictionary *FindPass = @{
                               @"user_login":_UserAcount.text,
                               @"user_pass":_code.text,
                               @"user_pass2":_pass.text,
                               @"code":_codeText.text
                               };
    WeakSelf
    [MBProgressHUD showMessage:@""];
    if (_UserAcount.text.length!=11){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    if (_UserAcount.text.length == 0 ) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入手机号"];
    }else if (_codeText.text.length == 0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入验证码"];
    }else if ( _code.text.length ==  0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入新密码"];
    }else if (_pass.text.length == 0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请确认新密码"];
    }else if (![_code.text isEqualToString:_pass.text])
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"密码输入不一致"];
    }else
    {
        [YBToolClass postNetworkWithUrl:@"Login.userFindPass" andParameter:FindPass success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [MBProgressHUD hideHUD];
            if (code == 0) {
                [MBProgressHUD showError:@"密码重置成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:true];
                });
            }else{
                [MBProgressHUD showError:msg];
            }
        } fail:^{
            [MBProgressHUD hideHUD];
        }];
    }
}


@end
