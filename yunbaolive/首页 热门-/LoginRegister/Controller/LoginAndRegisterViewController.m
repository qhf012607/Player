//
//  LoginAndRegisterViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/4.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "ZYTabBarController.h"
#import "AppDelegate.h"
#import "ForgetPassViewController.h"
#import "ForgetPassNextViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "webH5.h"
@interface LoginAndRegisterViewController ()
{
    NSInteger ConfirmBtnCount;
}
@property (weak, nonatomic) IBOutlet UIButton *loginMenue;
@property (weak, nonatomic) IBOutlet UIButton *registMenue;
@property (weak, nonatomic) IBOutlet UIView *loginMenuView;
@property (weak, nonatomic) IBOutlet UIView *registerMenuView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *textFildAcount;
@property (weak, nonatomic) IBOutlet UITextField *textFildPass;
@property (weak, nonatomic) IBOutlet UITextField *registAcount;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *registPass;
@property (weak, nonatomic) IBOutlet UITextField *confirmPass;
@property (weak, nonatomic) IBOutlet UIView *registView;
@property(nonatomic,strong)NSString *isreg;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, assign)NSInteger messageIssssss;
@property (strong, nonatomic) IBOutlet UIButton *tiaokuanLab;
//@property (weak, nonatomic) IBOutlet UILabel *tiaokuanLab;
@property (weak, nonatomic) IBOutlet UIButton *tioakuanBtn;
@property (nonatomic, strong) NSTimer *messsageTimer;
@end

@implementation LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registView.hidden = true;
    [self.loginMenue addTarget:self action:@selector(changeMenue:) forControlEvents:UIControlEventTouchUpInside];
    [self.registMenue addTarget:self action:@selector(changeMenue:) forControlEvents:UIControlEventTouchUpInside];
    self.registerMenuView.hidden = true;
    [self.getCodeBtn addTarget:self action:@selector(registerAcountGetCode) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"网站服务条款"];;
    [string addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [self.tiaokuanLab setAttributedTitle:string forState:UIControlStateNormal];
    [self.tiaokuanLab addTarget:self action:@selector(pushTiaokuan) forControlEvents:UIControlEventTouchUpInside];
    
    [self addBackButtonWithoutNavBar];
    
   // 
    [self.tioakuanBtn setImage:[UIImage imageNamed:@"unselectBox"] forState:UIControlStateNormal];
    [self.tioakuanBtn setImage:[UIImage imageNamed:@"gougou"] forState:UIControlStateSelected];
    [self.tioakuanBtn addTarget:self action:@selector(onConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    ConfirmBtnCount = 0;
    

}
/// 同意协议
- (void)onConfirmBtn {
    ConfirmBtnCount +=1;
    if (ConfirmBtnCount % 2 == 0) {
        self.tioakuanBtn.selected = NO;
        
    }else
    {
        self.tioakuanBtn.selected = YES;
        
    }
}
// 跳转服务条款
- (void)pushTiaokuan
{
    webH5 *web = [[webH5 alloc]init];
    web.urls = [NSString stringWithFormat:@"%@index.php?g=portal&m=page&a=index&id=4",curl];
    [self.navigationController pushViewController:web animated:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)pop{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)changeMenue:(UIButton*)sender{
    self.registView.hidden = !sender.tag;
    self.loginView.hidden = sender.tag;
    self.loginMenuView.hidden = sender.tag;
    self.registerMenuView.hidden = !sender.tag;
    if (sender.tag) {
        [self.loginMenue setTitleColor: RGB(148, 148, 148) forState:UIControlStateNormal];
        [self.registMenue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
    }else{
        [self.loginMenue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.registMenue setTitleColor:RGB(148, 148, 148) forState:UIControlStateNormal];
    }
}

- (IBAction)mobileLogin:(id)sender {
    if (self.textFildAcount.text.length!=11){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    if (self.textFildAcount.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    if (self.textFildPass.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    [self.view endEditing:YES];
    NSString *pushid;
    if ([JPUSHService registrationID]) {
        pushid = [JPUSHService registrationID];
    }else{
        pushid = @"";
    }
    
    NSDictionary *Login = @{
                            @"user_login":_textFildAcount.text,
                            @"user_pass":_textFildPass.text,
                            @"source":@"ios",
                            @"pushid":pushid
                            };
    WeakSelf
    [[PRNetWork loginWithDic:Login] subscribeNext:^(id x) {
        [MBProgressHUD hideHUD];
        NSNumber *number = [x valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSDictionary *data = [x valueForKey:@"data"];
            int code = [minstr([data valueForKey:@"code"]) intValue];
            id info = [data valueForKey:@"info"];
            if (code == 0) {
                NSDictionary *infos = [info objectAtIndex:0];
                LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
                [Config saveProfile:userInfo];
               
             
                //判断第一次登陆
                NSString *isreg = minstr([infos valueForKey:@"isreg"]);
                _isreg = isreg;
                [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
                [weakSelf login];
                
            }else{
               [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
            }
        }else{
            
        }
    } error:^(NSError *error) {
          [MBProgressHUD hideHUD];
    }];
}

-(void)login{
  //  ZYTabBarController *root = [[ZYTabBarController alloc]init];
    [cityDefault saveisreg:_isreg];
    [self dismissViewControllerAnimated:true completion:nil];
//    UIApplication *app =[UIApplication sharedApplication];
//    AppDelegate *app2 = (AppDelegate *)app.delegate;
//    app2.tab = root;
//    app2.window.rootViewController = root;
    
}



- (void)registerAcountGetCode{
    if (self.registAcount.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (self.registAcount.text.length!=11){
        [MBProgressHUD showError:@"手机号输入错误"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
  
    
    NSDictionary *getcode = @{
                              @"mobile":self.registAcount.text,
                              @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",self.registAcount.text]]
                              };
   
    [YBToolClass postNetworkWithUrl:@"Login.getCode" andParameter:getcode success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 0) {
            [MBProgressHUD showError:@"发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            _messageIssssss = 60;
            _getCodeBtn.userInteractionEnabled = NO;
            if (self.messsageTimer == nil) {
                self.messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
            }
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}

//获取验证码倒计时
-(void)daojishi{
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"倒计时%lds",(long)_messageIssssss] forState:UIControlStateNormal];
    _getCodeBtn.userInteractionEnabled = NO;
    [_getCodeBtn setTitleColor:RGB_COLOR(@"#c8c8c8", 1) forState:0];
    
    if (_messageIssssss<=0) {
        [_getCodeBtn setTitleColor:normalColors forState:0];
        [_getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _getCodeBtn.userInteractionEnabled = YES;
        [_messsageTimer invalidate];
        _messsageTimer = nil;
        _messageIssssss = 60;
    }
    _messageIssssss-=1;
}

- (IBAction)doRegist:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"正在注册"];
    if (_registAcount.text.length == 0 ) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入手机号"];
    }else if (_code.text.length == 0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入验证码"];
    }else if ( _registPass.text.length ==  0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请输入密码"];
    }else if (_confirmPass.text.length == 0)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请确认密码"];
    }else if (self.tioakuanBtn.selected == NO)
    {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"阅读并同意服务条款,方能注册!"];
    }else
    {
        NSDictionary *Reg = @{
                              @"user_login":_registAcount.text,
                              @"user_pass":_registPass.text,
                              @"user_pass2":_confirmPass.text,
                              @"code":_code.text
                              };
        [YBToolClass postNetworkWithUrl:@"Login.userReg" andParameter:Reg success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [MBProgressHUD hideHUD];
            
            if (code == 0) {
                //            [MBProgressHUD showError:@"注册成功"];
                //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [self.navigationController popViewControllerAnimated:YES];
                //            });
                [self goLogin];
            }else{
                [MBProgressHUD showError:msg];
            }
        } fail:^{
            [MBProgressHUD hideHUD];
        }];
    }
 
}

- (void)goLogin{
    [MBProgressHUD showError:@"正在登录"];
    NSString *pushid;
    if ([JPUSHService registrationID]) {
        pushid = [JPUSHService registrationID];
    }else{
        pushid = @"";
    }
    NSDictionary *Login = @{
                            @"user_login":_registAcount.text,
                            @"user_pass":_registPass.text,
                            @"source":@"ios",
                            @"pushid":pushid
                            };
    [YBToolClass postNetworkWithUrl:@"Login.userLogin" andParameter:Login success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info objectAtIndex:0];
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
            [Config saveProfile:userInfo];
            [self LoginJM];
            //判断第一次登陆
            NSString *isreg = minstr([infos valueForKey:@"isreg"]);
            [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
            [cityDefault saveisreg:isreg];
            [self login];
            
        }else{
            [MBProgressHUD showError:msg];
            [MBProgressHUD hideHUD];
        }
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
    
}

-(void)LoginJM{
    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
//    [JMSGUser registerWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
//        if (!error) {
//            NSLog(@"login-极光IM注册成功");
//        } else {
//            NSLog(@"login-极光IM注册失败，可能是已经注册过了");
//        }
//        NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
//        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
//            if (!error) {
//                NSLog(@"login-极光IM登录成功");
//            } else {
//                NSLog(@"login-极光IM登录失败");
//            }
//        }];
//    }];
}

- (IBAction)forgetPass:(id)sender{
    ForgetPassNextViewController *cont = [[ForgetPassNextViewController alloc]init];
    cont.fd_prefersNavigationBarHidden = true;
    [self.navigationController pushViewController:cont animated:true];
}


//若要添加登陆方式，在此处添加
-(IBAction)thirdlogin:(UIButton *)sender{
    /*
     1 qq
     2 wx
     3 facebook
     4 twitter
     */
    [self.view endEditing:YES];
    int type;
    if (sender.tag == 1) {
        type = 1;
    }else if (sender.tag == 0) {
        type = 2;
    }else if (sender.tag == 2) {
        type = 3;  //微博
    }else  {
        type = 0;
    }
    
    switch (type) {
        case 1:
            [self login:@"qq" platforms:SSDKPlatformTypeQQ];
            break;
        case 2:
            [self login:@"wx" platforms:SSDKPlatformTypeWechat];
            break;
        case 3:
            [self login:@"facebook" platforms:SSDKPlatformTypeFacebook];
            break;
        case 4:
            [self login:@"twitter" platforms:SSDKPlatformTypeTwitter];
            break;
        default:
            break;
    }
}
-(void)login:(NSString *)types platforms:(SSDKPlatformType)platform{
    [MBProgressHUD showMessage:@""];
    //取消授权
    [ShareSDK cancelAuthorize:platform];
    
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self RequestLogin:user LoginType:types];
             
         } else if (state == 2 || state == 3) {
             
             [MBProgressHUD hideHUD];
//             [testActivityIndicator stopAnimating]; // 结束旋转
//             [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         }else{
             [MBProgressHUD hideHUD];
         }
         
     }];
}
-(void)RequestLogin:(SSDKUser *)user LoginType:(NSString *)LoginType
{
    //结束旋转
    NSString *icon = nil;
    if ([LoginType isEqualToString:@"qq"]) {
        icon = [user.rawData valueForKey:@"figureurl_qq_2"];
    }
    else
    {
        icon = user.icon;
    }
    NSString *unionID;//unionid
    if ([LoginType isEqualToString:@"wx"]){
        
        unionID = [user.rawData valueForKey:@"unionid"];
        
    }
    else{
        unionID = user.uid;
    }
    if (!icon || !unionID) {

        [MBProgressHUD showError:@"未获取到授权，请重试"];
        return;
    }
    NSString *pushid;
    if ([JPUSHService registrationID]) {
        pushid = [JPUSHService registrationID];
    }else{
        pushid = @"";
    }
    NSDictionary *pDic = @{
                           @"openid":[NSString stringWithFormat:@"%@",unionID],
                           @"type":[NSString stringWithFormat:@"%@",[self encodeString:LoginType]],
                           @"nicename":[NSString stringWithFormat:@"%@",[self encodeString:user.nickname]],
                           @"avatar":[NSString stringWithFormat:@"%@",[self encodeString:icon]],
                           @"source":@"ios",
                           @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"openid=%@&76576076c1f5f657b634e966c8836a06",unionID]],
                           @"pushid":pushid
                           };
    [YBToolClass postNetworkWithUrl:@"Login.userLoginByThird" andParameter:pDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
            [Config saveProfile:userInfo];
            [self LoginJM];
            //判断第一次登陆
            NSString *isreg = minstr([infos valueForKey:@"isreg"]);
            _isreg = isreg;
            [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
            [self login];
        }
      // 结束旋转
      //当旋转结束时隐藏
         [MBProgressHUD hideHUD];
    } fail:^{
         [MBProgressHUD hideHUD];
      // 结束旋转
      //当旋转结束时隐藏
    }];
}
-(NSString *)getQQunionID:(NSString *)IDID{
    
    //************为了和PC互通，获取QQ的unionID,需要注意的是只有腾讯开放平台的数据打通之后这个接口才有权限访问，不然会报错********
    NSString *url1 = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",IDID];
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:nil];
    NSRange rang1 = [str rangeOfString:@"{"];
    NSString *str2 = [str substringFromIndex:rang1.location];
    NSRange rang2 = [str2 rangeOfString:@")"];
    NSString *str3 = [str2 substringToIndex:rang2.location];
    NSString *str4 = [str3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSData *data = [str4 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [data JSONValue];
    NSString *unionID = [dic valueForKey:@"unionid"];
    //************为了和PC互通，获取QQ的unionID********
    
    return unionID;
}
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
@end
