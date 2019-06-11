#import "getpasswangViewController.h"


@interface getpasswangViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
#pragma mark ================ 语言包的时候需要修改的label ===============

@property (weak, nonatomic) IBOutlet UILabel *forgotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *surePwdLabel;

@end
@implementation getpasswangViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = YES;
    [_dochange setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
    _dochange.enabled = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    [_oldPassWord becomeFirstResponder];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

    
}
-(void)ChangeBtnBackground
{
   
    if (_oldPassWord.text.length >0 && _futurePassWord.text.length >0 && _futurePassWord2.text.length > 0 )
    {
        [_dochange setBackgroundColor:normalColors];
        _dochange.enabled = YES;
    }
    else
    {
        [_dochange setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _dochange.enabled = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doChangePassWord:(id)sender {
    NSDictionary *pdic = @{
                           @"oldpass":_oldPassWord.text,
                           @"pass":_futurePassWord.text,
                           @"pass2":_futurePassWord2.text
                           };
    [YBToolClass postNetworkWithUrl:@"User.updatePass" andParameter:pdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [MBProgressHUD showSuccess:@"密码修改成功"];
            
            [self gobackView];
//            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
             [MBProgressHUD showError:msg];
        }
    } fail:^{
        [MBProgressHUD showError:@"网络错误"];
    }];
}
- (void)gobackView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
