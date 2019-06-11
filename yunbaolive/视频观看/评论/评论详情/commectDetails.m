//
//  commectDetails.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "commectDetails.h"
#import "detailcell.h"
#import "detailmodel.h"
#import "detailHead.h"
#import "SelPeopleV.h"
#import <HPGrowingTextView/HPGrowingTextView.h>
#import "twEmojiView.h"

@interface commectDetails ()<UITableViewDelegate,UITableViewDataSource,pushCommetnDetails,HPGrowingTextViewDelegate,twEmojiViewDelegate>
{
    UIView *_toolBar;
    HPGrowingTextView *_textField;
    int count;//下拉次数;
    bool isself;
    int ispush;
    bool isselected;
    MJRefreshAutoNormalFooter *footer;
    NSString *commectid;
    NSString *parentid;
    NSString *touid;
    NSString *getlistParentid;
    NSMutableDictionary *topdic;
    detailHead *header;//tableview表头
    CGFloat tableviewHeaderHeight;
    UIButton *finish;
    
    SelPeopleV * _selV;
    NSMutableArray *_atArray;                                        //@用户的uid和uname数组
    twEmojiView *_emojiV;

}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *itemsarray;//回复列表
@property(nonatomic,strong)NSMutableArray *modelarray;//回复模型
@end
@implementation commectDetails
-(void)pushDetails:(NSDictionary *)commentdic{
    
    
}
-(NSMutableArray *)modelarray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _itemsarray) {
        detailmodel *model = [detailmodel modelWithDic:dic];
        [model setmyframe:[_modelarray lastObject]];
        [array addObject:model];
    }
    _modelarray = array;
    return _modelarray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _atArray = [NSMutableArray array];

    [self setHostCommetn];
    tableviewHeaderHeight = 0;
    ispush = 0;//判断发消息的时候 数组滚动最上面
    count = 0;//上拉加载次数
    _itemsarray = [NSMutableArray array];
    _modelarray = [NSMutableArray array];
    
    
    //用于回复
    commectid = [_hostDic valueForKey:@"commentid"];
    parentid  = [_hostDic valueForKey:@"parentid"];
    touid     = [_hostDic valueForKey:@"ID"];
    self.navigationController.navigationBarHidden = YES;
    [self creatNavi];
    
    //    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.navigationItem.title = @"查看回复";
    //    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    //    UIButton *canclebtn = [UIButton buttonWithType:0];
    //    canclebtn.frame = CGRectMake(0,0,20,20);
    //    [canclebtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    //    [canclebtn setImageEdgeInsets:UIEdgeInsetsMake(1,1,1,1)];
    //    [canclebtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:canclebtn];
    
    //设置列表
    [self setTableView];
    //设置发消息框
    [self setToolBar];
    //请求数据
    [self getcommentlist];
    
    header = [[detailHead alloc]init];
    WeakSelf;
    [header justdoit:topdic comment:^(id type, NSString *isLikeValue) {
        //获取点赞总数
        NSDictionary *subdic = @{
                                 @"commentid":[weakSelf.hostDic valueForKey:@"parentid"],
                                 @"likes":type,
                                 @"islike":isLikeValue
                                 };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"likesnums" object:nil userInfo:subdic];
    }];
    tableviewHeaderHeight = header.contentRect.size.height + 110;
    header.frame = CGRectMake(0, 0, _window_width, tableviewHeaderHeight);
    [self.tableview beginUpdates];
    [self.tableview setTableHeaderView:header];
    [self.tableview setSectionHeaderHeight:tableviewHeaderHeight];
    [self.tableview endUpdates];
    //显示回复总数
    header.allComments.text = [NSString stringWithFormat:@"%@全部回复(%@)",@"   ",[_hostDic valueForKey:@"allcommecnts"]];
    _emojiV = [[twEmojiView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff)];
    _emojiV.delegate = self;
    [self.view addSubview:_emojiV];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    self.navigationController.navigationBarHidden = YES;
}
-(void)setHostCommetn{
    //设置顶部显示评论内容
    NSDictionary *userinfo = @{
                               @"avatar":[_hostDic valueForKey:@"avatar"],
                               @"user_nicename":[_hostDic valueForKey:@"user_nicename"],
                               };
    topdic = [NSMutableDictionary dictionaryWithDictionary:userinfo];
    [topdic setObject:userinfo forKey:@"userinfo"];
    [topdic setObject:[_hostDic valueForKey:@"likes"] forKey:@"likes"];
    [topdic setObject:[_hostDic valueForKey:@"islike"] forKey:@"islike"];
    [topdic setObject:[_hostDic valueForKey:@"content"] forKey:@"content"];
    [topdic setObject:[_hostDic valueForKey:@"datetime"] forKey:@"datetime"];
    [topdic setObject:[_hostDic valueForKey:@"parentid"] forKey:@"parentid"];
    [topdic setObject:[_hostDic valueForKey:@"at_info"] forKey:@"at_info"];
    [topdic setObject:@"0" forKey:@"touid"];
}
-(void)getcommentlist{
    
    count+=1;
    isselected = NO;
    _textField.text = @"";
    _textField.placeholder = [NSString stringWithFormat:@"回复%@:",[_hostDic valueForKey:@"user_nicename"]];
    
    NSString *url = [purl stringByAppendingFormat:@"/?service=Video.getReplys&commentid=%@&p=%d&uid=%@",[_hostDic valueForKey:@"parentid"],count,[Config getOwnID]];
    WeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
         [self.tableview.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *info = [data valueForKey:@"info"];
            [weakSelf.itemsarray addObjectsFromArray:info];
            [weakSelf.tableview reloadData];
            if (ispush == 1) {
                [weakSelf.tableview setContentOffset:CGPointMake(0,128) animated:YES];
                ispush = 0;
            }
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        [self.tableview.mj_footer endRefreshing];
    }];
    
}
-(void)cancle{
    if (self.event) {
        self.event();
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadcomments" object:nil];
}
-(void)setTableView{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 64-statusbarHeight)];
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor whiteColor];//RGB(248, 248, 248);
    [self.view addSubview:_tableview];
    
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getcommentlist)];
    self.tableview.mj_footer = footer;
    [footer setTitle:@"评论加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了哦~" forState:MJRefreshStateIdle];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
}
-(void)setToolBar{
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height -50, _window_width,50)];
    _toolBar.backgroundColor = [UIColor whiteColor];//RGB(248, 248, 248);
    [self.view addSubview:_toolBar];
    
    //设置输入框
    UIView *vc  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    vc.backgroundColor = [UIColor clearColor];
    _textField = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(10,8, _window_width - 68, 34)];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 17;
    _textField.font = SYS_Font(16);
    _textField.placeholder = [NSString stringWithFormat:@"回复%@:",[_hostDic valueForKey:@"user_nicename"]];
    _textField.textColor = GrayText;
    _textField.placeholderColor = GrayText;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.enablesReturnKeyAutomatically = YES;
    
    _textField.internalTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingHead;
    _textField.internalTextView.textContainer.maximumNumberOfLines = 1;
    
    /**
     * 由于 _textField 设置了contentInset 后有色差，在_textField后添
     * 加一个背景view并把_textField设置clearColor
     */
    _textField.contentInset = UIEdgeInsetsMake(2, 10, 2, 10);
    _textField.backgroundColor = [UIColor clearColor];
    UIView *tv_bg = [[UIView alloc]initWithFrame:_textField.frame];
    tv_bg.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    tv_bg.layer.masksToBounds = YES;
    tv_bg.layer.cornerRadius = _textField.layer.cornerRadius;
    [_toolBar addSubview:tv_bg];
    [_toolBar addSubview:_textField];
    
    finish = [UIButton buttonWithType:0];
    finish.frame = CGRectMake(_window_width - 44,8,34,34);
    [finish setImage:[UIImage imageNamed:@"chat_face.png"] forState:0];
    
    [finish addTarget:self action:@selector(atFrends) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:finish];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark - 召唤好友
-(void)atFrends {
    [_textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _emojiV.frame = CGRectMake(0, _window_height - (EmojiHeight+ShowDiff), _window_width, EmojiHeight+ShowDiff);
        _toolBar.frame = CGRectMake(0, _emojiV.y - 50, _window_width, 50);
        
    }];

//    WeakSelf;
//    if (!_selV) {
//        _selV = [[SelPeopleV alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height) showType:@"2" selUser:^(NSString *state, MessageListModel *userModel) {
//            [weakSelf selCallBack:state uModel:userModel];
//        }];
//        [self.view addSubview:_selV];
//
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        _selV.frame = CGRectMake(0, 0, _window_width, _window_height);
//
//    }];
}
-(void)selCallBack:(NSString *)state uModel:(MessageListModel *)model{
    if ([state isEqual:@"关闭"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _selV.frame = CGRectMake(0, _window_height, _window_width, _window_height);
        } completion:^(BOOL finished) {
            
            [_selV removeFromSuperview];
            _selV = nil;
        }];
    }else {
       //@
        [UIView animateWithDuration:0.3 animations:^{
            _selV.frame = CGRectMake(0,_window_height, _window_width, _window_height);
        } completion:^(BOOL finished) {
            
            [_selV removeFromSuperview];
            _selV = nil;
            //输入框显示用户
            _textField.text = [NSString stringWithFormat:@"%@@%@ ",_textField.text,model.unameStr];
            NSDictionary *dic = @{@"name":model.unameStr,@"uid":model.uidStr};
            [_atArray addObject:dic];
            NSLog(@"===输入框显示用户===%@==%@===con:%@",model.uidStr,model.unameStr,_textField.text);
        }];
        
    }
}




#pragma mark - 输入框代理事件
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    _textField.height = height;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    [_textField resignFirstResponder];
    [self pushmessage];
    return YES;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0) {
            //用户长按选择文本时不处理
            return YES;
        }
        
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self findAllAt];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches) {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange)) {
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt) {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
    }
    
    //判断是回车键就发送出去
    if ([text isEqualToString:@"\n"]) {
        [self pushmessage];
        return NO;
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];
    
    if (newText.length < 1) {
        // 高亮输入框中的@
        UITextView *textView = _textField.internalTextView;
        NSRange range = textView.selectedRange;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text              attributes:@{NSForegroundColorAttributeName:GrayText,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        
        NSArray *matches = [self findAllAt];
        
        for (NSTextCheckingResult *match in matches) {
            [string addAttribute:NSForegroundColorAttributeName value:AtCol range:NSMakeRange(match.range.location, match.range.length - 1)];
        }
        
        textView.attributedText = string;
        textView.selectedRange = range;
    }
    
    if (growingTextView.text.length >0) {
        NSString *theLast = [growingTextView.text substringFromIndex:[growingTextView.text length]-1];
        if ([theLast isEqual:@"@"]) {
            //去掉手动输入的  @
            NSString *end_str = [growingTextView.text substringToIndex:growingTextView.text.length-1];
            _textField.text = end_str;
            [self atFrends];
        }
    }
    
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView {
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0) {
        // 选择文本时可以
        return;
    }
    
    NSArray *matches = [self findAllAt];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange)) {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
}

#pragma mark - Private
- (NSArray<NSTextCheckingResult *> *)findAllAt {
    // 找到文本中所有的@
    NSString *string = _textField.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    detailcell *cell = [detailcell cellWithtableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = _modelarray[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailmodel *model = _modelarray[indexPath.row];
    return model.rowH;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelarray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *subdic = _itemsarray[indexPath.row];
    
    touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"uid"]];
    
    _textField.placeholder = [NSString stringWithFormat:@"回复%@:",[[subdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
    
    if ([touid isEqual:[Config getOwnID]]) {
        
        
        return;
    }
    [_textField becomeFirstResponder];
    parentid = [subdic valueForKey:@"id"];
    commectid = [subdic valueForKey:@"commentid"];
    
}

-(void)pushmessage{
    if ([[Config getOwnID] intValue] < 0) {
        [_textField resignFirstResponder];
        [PublicObj warnLogin];
        return;
    }
    if (_textField.text.length == 0 || _textField.text == NULL || _textField.text == nil || [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [MBProgressHUD showError:@"请添加内容后再尝试"];
        return;
    }
    if ([touid isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:@"不用给自己回复"];
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@",_textField.text];
    NSString *sendtouid = [NSString stringWithFormat:@"%@",touid];
    NSString *sendcommectid = [NSString stringWithFormat:@"%@",commectid];
    NSString *sendparentid = [NSString stringWithFormat:@"%@",parentid];
    
    [self cancle];
    
    [self.view endEditing:YES];
    
    NSString *at_json = @"";
    //转json、去除空格、回车
    if (_atArray.count>0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_atArray options:NSJSONWritingPrettyPrinted error:nil];
        at_json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        at_json = [at_json stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        at_json = [at_json stringByReplacingOccurrencesOfString:@" " withString:@""];
        at_json = [at_json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    NSString *url = [purl stringByAppendingFormat:@"/?service=Video.setComment&videoid=%@&content=%@&uid=%@&token=%@&touid=%@&commentid=%@&parentid=%@&at_info=%@",[_hostDic valueForKey:@"videoid"],path,[Config getOwnID],[Config getOwnToken],sendtouid,sendcommectid,sendparentid,at_json];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            
            commectid = [_hostDic valueForKey:@"commentid"];
            parentid  = [_hostDic valueForKey:@"parentid"];
            touid     = [_hostDic valueForKey:@"ID"];
            _textField.text = @"";
            _textField.placeholder = [NSString stringWithFormat:@"回复%@:",[_hostDic valueForKey:@"user_nicename"]];
            
            
            [_atArray removeAllObjects];
            //更新评论数量
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            NSString *replys   = [NSString stringWithFormat:@"%@",[info valueForKey:@"replys"]];
            //显示回复总数
            header.allComments.text = [NSString stringWithFormat:@"%@全部回复(%@)",@"   ",replys];
            
            //获取总评论数
            NSString *newComments = [NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]];
            NSDictionary *dic = @{
                                  @"allComments":newComments,
                                  @"replys":replys
                                  };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allComments" object:nil userInfo:dic];
//            NSString *isattent = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattent"]];//对方是否
//            NSString *t2u = [NSString stringWithFormat:@"%@",[info valueForKey:@"t2u"]];//对方是否拉黑我
//            if ([t2u isEqual:@"0"]) {
//
//                [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
//
//                count = 0;
//                _itemsarray = nil;
//                _itemsarray = [NSMutableArray array];
//                ispush = 1;
//                if (![sendtouid isEqual:[Config getOwnID]]) {
//                    NSString *sixincontent = [NSString stringWithFormat:@"回复:%@",path];
//                    NSDictionary *iconDic = [NSDictionary dictionaryWithObject:isattent forKey:@"isfollow"];
//                    //                    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:sixincontent];
//                    //                    EMMessage *message = [[EMMessage alloc] initWithConversationID:sendtouid from:[Config getOwnID] to:sendtouid body:body ext:iconDic];
//                    //                    message.chatType = EMChatTypeChat;// 设置为单聊消息
//                    //                    message.direction = EMMessageDirectionSend;//方向
//                    //                    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//                    //                        NSLog(@"----+++发送成功---%@",error.errorDescription);
//                    //
//                    //                    }];
//                }
//                //增加回复数量
//                NSDictionary *subdic = @{
//                                         @"commentid":[_hostDic valueForKey:@"parentid"],
//                                         @"commentnums":replys
//                                         };
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"commentnums" object:nil userInfo:subdic];
//            }
//            else{
//                [MBProgressHUD showError:minstr(@"对方暂时拒绝接收您的消息")];
//            }
            
            //增加回复数量
            NSDictionary *subdic = @{
                                     @"commentid":[_hostDic valueForKey:@"parentid"],
                                     @"commentnums":replys
                                     };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentnums" object:nil userInfo:subdic];
            
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
        }
    } Fail:nil];
    
    
}
//这个地方找到点赞的字典，在数组中删除再重新插入 处理点赞
-(void)makeLikeRloadList:(NSString *)commectids andLikes:(NSString *)likes islike:(NSString *)islike{
    
    BOOL isLike = NO;
    int numbers = 0;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<_itemsarray.count; i++) {
        NSDictionary *subdic = _itemsarray[i];
        NSString *myparentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([myparentid isEqual:commectids]) {
            
            dic = [NSMutableDictionary dictionaryWithDictionary:subdic];
            numbers = i;
            isLike = YES;
            break;
        }
    }
    if (isLike == YES) {
        [_itemsarray removeObject:dic];
        [dic setObject:likes forKey:@"likes"];
        [dic setObject:islike forKey:@"islike"];
        [_itemsarray insertObject:dic atIndex:(NSUInteger)numbers];
        [self.tableview reloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [self hidEmoji];
}
- (void)hidEmoji{
    [UIView animateWithDuration:0.1 animations:^{
        _toolBar.frame = CGRectMake(0, _window_height  - 50, _window_width, 50);
        _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);
        
    }];
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    _toolBar.frame = CGRectMake(0, height - 50, _window_width, 50);
    _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);

}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        _toolBar.frame = CGRectMake(0, _window_height  - 50, _window_width, 50);
        _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);

    }];
    
}
-(void)creatNavi {
    YBNavi *navi = [[YBNavi alloc]init];
    navi.leftHidden = NO;
    navi.rightHidden = YES;
    //    navi.imgTitleSameR = YES;
    [navi ybNaviLeft:^(id btnBack) {
        [self cancle];
        
    } andRightName:nil andRight:^(id btnBack) {
        
    } andMidTitle:@"查看回复"];
    [self.view addSubview:navi];
}
#pragma mark - Emoji 代理
-(void)sendimage:(NSString *)str {
    if ([str isEqual:@"msg_del"]) {
        [_textField.internalTextView deleteBackward];
    }else {
        [_textField.internalTextView insertText:str];
        
    }
}

-(void)clickSendEmojiBtn {
    
    //    [self prepareTextMessage:_toolBarContainer.toolbar.textView.text];
    [self pushmessage];
}

@end
