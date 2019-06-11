//
//  MBSuperPlayerViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/4/27.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBSuperPlayerViewController.h"
#import <libksygpulive/libksygpulive.h>
#import "socketLivePlay.h"
#import "chatMsgCell.h"
#import "GrounderSuperView.h"
#import "AppDelegate.h"
#import "BarrageHeader.h"
#import "fenXiangView.h"
#import "TimerHander.h"

@interface MBSuperPlayerViewController ()<socketDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BarrageRendererDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputSmallView;
@property (weak, nonatomic) IBOutlet MBImageView *sendbutton;
@property (strong, nonatomic) KSYMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIView *d;
@property (weak, nonatomic) IBOutlet UITextField *inputMassage;
@property (weak, nonatomic) IBOutlet UITableView *tablemessage;
@property (strong, nonatomic) socketMovieplay *socketDelegate;//socket监听
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightMas;
@property (nonatomic, strong) NSDictionary *playDoc;
@property (nonatomic, strong)NSDictionary *guardInfo;
@property (nonatomic, assign) BOOL isSuperAdmin;
@property (nonatomic, copy)NSString *usertype;
@property(nonatomic,strong)NSString *danmuprice;//弹幕价格
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,assign) long long userCount;//用户数量
@property(nonatomic,copy)NSString *votesTatal;
@property (weak, nonatomic) IBOutlet UIButton *sendShuButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButHeng;

@property(nonatomic,strong)NSString *level;
@property(nonatomic,strong)NSMutableArray *msgList;
@property(nonatomic,strong)NSMutableArray *chatModels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputView_bottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerrightmas;
@property (weak, nonatomic) IBOutlet UIView *inputBottonView;
@property (nonatomic,strong) UIButton *buttonBack;
@property (nonatomic,assign)BOOL quanping;
@property (weak, nonatomic) IBOutlet UIButton *quanpingBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *massDheight;
@property (weak, nonatomic) IBOutlet UIButton *danmuButton;
@property (weak, nonatomic) IBOutlet UIView *henpingInputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *henpinInputViewBotton;

@property (weak, nonatomic) IBOutlet MBImageView *imageSendHeng;
@property (weak, nonatomic) IBOutlet UIView *inputBVHengp;
@property (nonatomic,strong) BarrageRenderer* renderer;
@property (weak, nonatomic) IBOutlet UITextField *inputHenping;
@property (nonatomic,strong) UIView* danmuBackView;
@property (nonatomic,strong) fenXiangView *fenxiangV;
@property (nonatomic,strong)  TimerHander *timer;
@property (nonatomic,strong) UIAlertController *alert;
@end

@implementation MBSuperPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUpdate];
    
    _tablemessage.separatorColor = UIColor.clearColor;
    self.fd_interactivePopDisabled = YES;
    _inputSmallView.layer.cornerRadius = 15;
    _inputBVHengp.layer.cornerRadius = 15;
    _player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.model.href_rtmp]];

    _player.controlStyle = MPMovieControlStyleNone;
    [_player.view setFrame: _d.bounds];
    
    [_d addSubview: _player.view];
    _d.autoresizesSubviews = TRUE;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.shouldAutoplay = TRUE;
    _player.scalingMode = MPMovieScalingModeAspectFit;
    [_player prepareToPlay];
    if (_model.uid&&_model.stream) {
        self.playDoc = @{@"stream":_model.stream,@"uid":_model.uid,@"user_nicename":_model.title};
    }
    // Do any additional setup after loading the view from its nib.
    
    [self initArray];
    self.henpingInputView.backgroundColor = [UIColor clearColor];
    [self registerForKeyboardNotifications];
    self.labTitle.text = [NSString stringWithFormat:@"欢迎来到%@ VS %@直播间",self.model.home,self.model.away];
    self.sendbutton.contentMode = UIViewContentModeScaleToFill;
    self.imageSendHeng.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMessage:)];
    [self.sendbutton addGestureRecognizer:gester];
    self.danmuBackView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.d addSubview:self.danmuBackView];//添加弹幕
    [self.danmuBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    [self initBarrageRenderer];
     self.buttonBack = [self addBackButtonWithoutNavBar];
    [self hidenVIew:false];
    self.timer = [[TimerHander alloc]init];
    [self alertInit];
    [self count];
}

- (void)count{
    [[PRNetWork countLivePlayWith:@{@"streamName":self.model.streamname?self.model.streamname:@""}]subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.player play];
    [self getNodeJSInfo];
}

- (void)alertInit{
    self.alert = [UIAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    [self.alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.quanping) {
            [self suofang:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:LoginNotifacation object:nil];
            });
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:LoginNotifacation object:nil];
        }
    }]];
}
- (void)initBarrageRenderer
{
    _renderer = [[BarrageRenderer alloc]init];
    _renderer.smoothness = .2f;
    _renderer.delegate = self;
    [self.danmuBackView addSubview:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    // 若想为弹幕增加点击功能, 请添加此句话, 并在Descriptor中注入行为
//    _renderer.view.userInteractionEnabled = YES;
    
}

- (void)pop{
    if (self.quanping) {
        [self suofang:nil];
    }else{
        [self.player stop];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        _inputView_bottom.constant = -keyboardSize.height;
        _henpinInputViewBotton.constant = keyboardSize.height;
       
     }];
    if (self.quanping) {
         [self.timer stop];
    }
    [self.view layoutIfNeeded];

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:duration animations:^{
        _inputView_bottom.constant = 0;
        _henpinInputViewBotton.constant = 0;
       
    }];
    if (self.quanping) {
        WeakSelf;
        [self.timer startTimer:10 countBlock:^(NSInteger x) {
            if (x == 0) {
                [weakSelf hiddenInput];
            }
        }];
    }
    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated{
     [_player pause];
}
//获取进入直播间所需要的所有信息全都在这个enterroom这个接口返回
-(void)getNodeJSInfo
{
    _livetype = @"0";
    self.socketDelegate = [[socketMovieplay alloc]init];
    self.socketDelegate.socketDelegate = self;
    [self.socketDelegate setnodejszhuboDic:self.playDoc Handler:^(id arrays) {
        
        NSMutableArray *info = [[arrays valueForKey:@"info"] firstObject];
        self.guardInfo = [info valueForKey:@"guard"];
        [common saveagorakitid:minstr([info valueForKey:@"agorakitid"])];//保存声网ID
        if ([minstr([info valueForKey:@"issuper"]) isEqual:@"1"]) {
            self.isSuperAdmin = YES;
        }else{
            self.isSuperAdmin = NO;
        }
        
        self.usertype = minstr([info valueForKey:@"usertype"]);
        //保存靓号和vip信息
        NSDictionary *liang = [info valueForKey:@"liang"];
        NSString *liangnum = minstr([liang valueForKey:@"name"]);
        NSDictionary *vip = [info valueForKey:@"vip"];
        NSString *type = minstr([vip valueForKey:@"type"]);
        
        
        NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
        [Config saveVipandliang:subdic];
        
        
        self.danmuprice = [info valueForKey:@"barrage_fee"];
        _listArray = [info valueForKey:@"userlists"];
        LiveUser *users = [Config myProfile];
        users.coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"coin"]];
        [Config updateProfile:users];
        
        
        self.userCount = [[info valueForKey:@"nums"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
        self.votesTatal = minstr([info valueForKey:@"votestotal"]);

        });
       
//        if (![minstr([info valueForKey:@"linkmic_uid"]) isEqual:@"0"]) {
//            [self playLinkUserUrl:minstr([info valueForKey:@"linkmic_pull"]) andUid:minstr([info valueForKey:@"linkmic_uid"])];
//        }
        
    }andlivetype:_livetype];
}
- (void)dealloc{
    
}

// 以下是 tableview的方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.chatModels.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tablemessage deselectRowAtIndexPath:indexPath animated:YES];
    chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"chatMsgCell" owner:nil options:nil] lastObject];
    }
    cell.model = self.chatModels[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)initArray{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    
    self.msgList = [NSMutableArray array];
    self.level = (NSString *)[Config getLevel];
    
    self.userCount = 0;
     self.chatModels = [NSMutableArray array];
}

- (IBAction)sendMessage:(id)sender{
    [self.view endEditing:true];
    
  
    if ([Config getOwnID]) {
        if (self.quanping) {
            if (self.inputHenping.text.length > 0) {
                 [self.socketDelegate sendmessage:self.inputHenping.text andLevel:@"1" andUsertype:self.usertype andGuardType:minstr([self.guardInfo valueForKey:@"type"])];
            }
        }else{
            if (self.inputMassage.text.length > 0) {
                 [self.socketDelegate sendmessage:self.inputMassage.text andLevel:@"1" andUsertype:self.usertype andGuardType:minstr([self.guardInfo valueForKey:@"type"])];
            }
        }
        self.inputMassage.text = @"";
        self.inputHenping.text = @"";
    }else{
        [self presentViewController:self.alert animated:YES completion:nil];
    }
}

-(void)messageListen:(NSDictionary *)chats{
    if (self.quanping) {
        [self changeMassage:chats];
    }
    [self.msgList addObject:chats];
    if(self.msgList.count>30)
    {
        [self.msgList removeObjectAtIndex:0];
    }
    [self.tablemessage reloadData];
    [self jumpLast ];
  
}

- (void)changeMassage:(NSDictionary*)msg{
    NSString *text = [NSString stringWithFormat:@"%@",[msg valueForKey:@"contentChat"]];
    NSString *name = [msg valueForKey:@"userName"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSString *ID = [msg valueForKey:@"id"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",ID,@"id",nil];
     [_renderer receive: [self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:BarrageWalkSideLeft info:userinfo]];
   ;
}


-(void)SendBarrage:(NSDictionary *)msg{
   
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
   // [_danmuView setModel:userinfo];
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side info:(NSDictionary*)dic
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = dic[@"title"];
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
   
    return descriptor;
}

-(NSMutableArray *)chatModels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.msgList) {
        chatModel *model = [chatModel modelWithDic:dic];
        [model setChatFrame:[_chatModels lastObject]];
        [array addObject:model];
    }
    _chatModels = array;
    return _chatModels;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:true];
    return true;
}

-(void)setSystemNot:(NSDictionary *)msg{
   
}

-(void)UserAccess:(NSDictionary *)msg{
    //用户进入
    _userCount += 1;
     [self userLoginSendMSG:msg];
}



//用户进入直播间发送XXX进入了直播间
-(void)userLoginSendMSG:(NSDictionary *)dic {
//    titleColor = @"userLogin";
    NSString *uname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"]];
    NSString *levell = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"level"]];
    NSString *ID = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"id"]];
    NSString *vip_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"vip_type"]];
    NSString *liangname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"liangname"]];
    NSString *usertype = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]];
    NSString *guard_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"guard_type"]];
    
    NSString *conttt = @" 进入了直播间";
    NSString *isadminn;
    if ([[NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]] isEqual:@"40"]) {
        isadminn = @"1";
    }else{
        isadminn = @"0";
    }
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",conttt,@"contentChat",levell,@"levelI",ID,@"id",@"userLogin",@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",guard_type,@"guard_type",nil];
    [self.msgList addObject:chat];
   
    if(self.msgList.count>30)
    {
        [self.msgList removeObjectAtIndex:0];
    }
    [self.tablemessage reloadData];
    [self jumpLast];
}

//聊天自动上滚
-(void)jumpLast
{
    NSUInteger sectionCount = [self.tablemessage numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self.tablemessage numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {sectionCount-1, 0};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tablemessage scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

-(void)UserDisconnect:(NSDictionary *)msg{
    
}

- (void)hiddenInput{
    [UIView animateWithDuration:1 animations:^{
        self.henpinInputViewBotton.constant = -60;
        self.buttonBack.hidden = true;
         [self.view layoutIfNeeded];
        
    }];
}

- (void)showInput{
    WeakSelf
    if (self.quanping) {
        [self.timer startTimer:10 countBlock:^(NSInteger index) {
            if (index == 0) {
                [weakSelf hiddenInput];
            }
        }];
        [UIView animateWithDuration:1 animations:^{
            self.henpinInputViewBotton.constant = 0;
            self.buttonBack.hidden = false;
            [self.view layoutIfNeeded];
        }];
    }
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.timer stop];
    [self.view endEditing:true];
    if (self.quanping&&!self.inputHenping.isEditing) {
        [self showInput];
    }
   
}

- (IBAction)share:(id)sender {
    [self.fenxiangV removeFromSuperview];
    self.fenxiangV = [[fenXiangView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    [self.fenxiangV GetDIc:self.playDoc];
    [self.view addSubview:self.fenxiangV];
}

- (IBAction)closeClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}



- (IBAction)quanPing:(id)sender {
    [self.view endEditing:true];
      [_renderer start];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = true;
    appDelegate.alivePlayFull = true;
    [self setNewOrientation:true];
    [self hidenVIew:true];
    if (_danmuButton.tag) {
        self.danmuBackView.hidden = true;
    }else{
        self.danmuBackView.hidden = false;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.massDheight.constant = SCREEN_HEIGHT;
       
    }];
    WeakSelf
    [self.timer startTimer:10 countBlock:^(NSInteger index) {
        if (index == 0) {
            [weakSelf hiddenInput];
        }
    }];
   
}

- (void)suofang:(id)sender{
     [self.timer stop];
     [self.view endEditing:true];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
     appDelegate.alivePlayFull = false;
    [self setNewOrientation:NO];
    [self hidenVIew:false];
     self.danmuBackView.hidden = true;
    [UIView animateWithDuration:0.5 animations:^{
        self.massDheight.constant = 255;
    } completion:^(BOOL finished) {
        [self.tablemessage reloadData];
        [self jumpLast];
    }];
    self.buttonBack.hidden = false;
   
 //   [self.tablemessage scrool]
}

- (void)hidenVIew:(BOOL)hidden{
    self.quanping = hidden;
    self.quanpingBt.hidden = hidden;
    self.inputBottonView.hidden = hidden;
    self.tablemessage.hidden = hidden;
    self.labTitle.hidden = hidden;
    self.henpingInputView.hidden = !hidden;
}

- (IBAction)danmuKai:(UIButton*)sender{
    if (sender.tag == 0) {
        sender.tag = 1;
        [sender setBackgroundImage:[UIImage imageNamed:@"tanmu"] forState:UIControlStateNormal];
        self.danmuBackView.hidden = true;
    }else{
          [sender setBackgroundImage:[UIImage imageNamed:@"tanmukai"] forState:UIControlStateNormal];
        sender.tag = 0;
         self.danmuBackView.hidden = false;
    }
}

@end
