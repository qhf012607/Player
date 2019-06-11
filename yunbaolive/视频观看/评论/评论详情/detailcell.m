//
//  detailcell.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "detailcell.h"
@implementation detailcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //头像
        _avatar_Button = [UIButton buttonWithType:0];
        _avatar_Button.layer.masksToBounds = YES;
        _avatar_Button.layer.cornerRadius = 15;
        _avatar_Button.frame = CGRectMake(10,25,30,30);
        [self addSubview:_avatar_Button];
        
        
        //名称
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = GrayText;//RGB(123, 123, 123);
        _nameL.font = [UIFont systemFontOfSize:14];
        _nameL.frame = CGRectMake(_avatar_Button.right + 10,20,200,20);
        _nameL.numberOfLines = 0;
        [self addSubview:_nameL];
        
        
        //时间
//        _timeL = [[UILabel alloc]init];
//        _timeL.textColor = GrayText;//RGB(208, 208, 208);
//        _timeL.font = [UIFont systemFontOfSize:12];
//        _timeL.frame = CGRectMake(_avatar_Button.right + 10, _nameL.bottom, 200, 20);
//        [self addSubview:_timeL];
        
        
        //点赞
        _zan_Button = [UIButton buttonWithType:0];
        _zan_Button.frame = CGRectMake(_window_width - 60,10,50,50);
        _zan_Button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
        _zan_Button.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_zan_Button];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
        [_zan_Button setTitle:@"0" forState:0];
        _zan_Button = [PublicObj setUpImgDownText:_zan_Button];
        [_zan_Button addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
        
        _bigbtn = [UIButton buttonWithType:0];
        _bigbtn.frame = CGRectMake(_window_width - 110, 10, 110, 50);
        [_bigbtn addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
        
        //回复内容
        _contentL = [[mylabels alloc]init];
        _contentL.lineBreakMode = NSLineBreakByCharWrapping;
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.textColor = RGB_COLOR(@"#333333", 1);
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self addSubview:_contentL];
        
        
        //回复的回复
        _ReplyContentL = [[mylabels alloc]init];
        _ReplyContentL.lineBreakMode = NSLineBreakByCharWrapping;
        _ReplyContentL.textAlignment = NSTextAlignmentLeft;
        _ReplyContentL.textColor = [UIColor whiteColor];//RGB(72, 72, 72);
        _ReplyContentL.font = [UIFont systemFontOfSize:14];
        _ReplyContentL.numberOfLines = 0;
        _ReplyContentL.hidden = YES;
        [self addSubview:_ReplyContentL];
        
        //cell分割线
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);//RGB(230, 230, 230);
        [self addSubview:_lineL];
        self.backgroundColor = [UIColor whiteColor];//RGB(248, 248, 248);
        
        //回复的回复前面的红线
        _replyLine = [[UILabel alloc]init];
        _replyLine.backgroundColor = RGB_COLOR(@"#ffffff", 0.2);//[UIColor redColor];
        _replyLine.hidden = YES;
        [self addSubview:_replyLine];
        [self addSubview:_bigbtn];
        
    }
    return self;
}
//点赞
-(void)makeLike{
    if ([[Config getOwnID] intValue]<0) {
        [PublicObj warnLogin];
        return;
    }
    if ([_model.ID isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:@"不能给自己的回复点赞"];
        
        return;
    }
    //_bigbtn.userInteractionEnabled = NO;
    WeakSelf;
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.addCommentLike&uid=%@&commentid=%@&token=%@",[Config getOwnID],_model.parentid,[Config getOwnToken]];
    
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            //动画
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.zan_Button.imageView.layer addAnimation:[PublicObj bigToSmallRecovery] forKey:nil];
            });
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            NSString *islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
            NSString *likes = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
            [self.delegate makeLikeRloadList:weakSelf.model.parentid andLikes:likes islike:islike];
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}
-(void)setModel:(detailmodel *)model{
    _model = model;
    [_avatar_Button sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb] forState:0];
    _nameL.text = _model.user_nicename;
    _timeL.text = _model.datetime;
    [_zan_Button setTitle:_model.likes forState:0];
    if ([_model.islike intValue] == 0) {
        _zan_Button.userInteractionEnabled = YES;
        //_bigbtn.userInteractionEnabled = YES;
        [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
        [_zan_Button setTitle:_model.likes forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
    }
    else{
        _zan_Button.userInteractionEnabled = NO;
        //_bigbtn.userInteractionEnabled = NO;
        [_zan_Button setTitleColor:RGB_COLOR(@"#fa561f", 1) forState:0];
        [_zan_Button setTitle:_model.likes forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
    }
    _contentL.text = _model.content;
    _contentL.frame = _model.contentRect;
    _ReplyContentL.frame = _model.ReplyRect;
    //如果touid大于0 则说明 这条回复有回复
    int touid = [_model.touid intValue];
    if (touid>0) {
        NSString *path1 = [NSString stringWithFormat:@"回复%@:%@%@", [_model.touserinfo valueForKey:@"user_nicename"],@" ",_model.content];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:path1];
        NSRange redRange1 = NSMakeRange(0, 2);
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#453f5d", 1) range:redRange1];
        NSRange redRange2 = NSMakeRange(2, [[noteStr string] rangeOfString:@":"].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:GrayText range:redRange2];
        _contentL.attributedText = noteStr;
        
        NSString *path2 = [NSString stringWithFormat:@"%@:%@%@",[_model.touserinfo valueForKey:@"user_nicename"],@" ",[_model.tocommentinfo valueForKey:@"content"]];
        NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:path2];
        NSRange redRange3 = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
        [noteStr2 addAttribute:NSForegroundColorAttributeName value:GrayText range:redRange3];
        _ReplyContentL.attributedText = noteStr2;
        //设置回复的回复红线坐标
        _replyLine.frame = CGRectMake(60, _model.ReplyRect.origin.y, 2, _model.ReplyRect.size.height);
        _ReplyContentL.hidden = NO;
        _replyLine.hidden = NO;
        _lineL.frame = CGRectMake(10,_model.ReplyRect.origin.y + _model.ReplyRect.size.height + 13, _window_width-20,1);
        
    }else{
        _replyLine.hidden = YES;
        _ReplyContentL.hidden = YES;
        _lineL.frame = CGRectMake(10,_model.contentRect.origin.y + _model.contentRect.size.height + 13, _window_width-20 ,1);
    }
    //给被@加颜色
    NSData *mix_data = [_model.at_info dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *atArray = [NSJSONSerialization JSONObjectWithData:mix_data options:NSJSONReadingAllowFragments error:nil];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];

    if (atArray.count>0) {
        //有@
        for (int i=0; i<atArray.count; i++) {
            NSDictionary *u_dic = atArray[i];
            NSString *uname = [NSString stringWithFormat:@"@%@",[u_dic valueForKey:@"name"]];
            if ([_contentL.text containsString:uname]) {
                NSRange uRang = [_contentL.text rangeOfString:uname];
                [attStr addAttribute:NSForegroundColorAttributeName value:AtCol range:uRang];
            }
        }
        _contentL.attributedText = attStr;
    }
    NSArray *resultArr  = [[YBToolClass sharedInstance] machesWithPattern:emojiPattern andStr:_contentL.text];
    if (!resultArr) return;
    NSUInteger lengthDetail = 0;
//    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:_contentL.text];
    //遍历所有的result 取出range
    for (NSTextCheckingResult *result in resultArr) {
        //取出图片名
        NSString *imageName =   [_contentL.text substringWithRange:NSMakeRange(result.range.location, result.range.length)];
        NSLog(@"--------%@",imageName);
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        UIImage *emojiImage = [UIImage imageNamed:imageName];
        NSAttributedString *imageString;
        if (emojiImage) {
            attach.image = emojiImage;
            attach.bounds = CGRectMake(0, -2, 15, 15);
            imageString =   [NSAttributedString attributedStringWithAttachment:attach];
        }else{
            imageString =   [[NSMutableAttributedString alloc]initWithString:imageName];
        }
        //图片附件的文本长度是1
        NSLog(@"emoj===%zd===size-w:%f==size-h:%f",imageString.length,imageString.size.width,imageString.size.height);
        NSUInteger length = attStr.length;
        NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
        [attStr replaceCharactersInRange:newRange withAttributedString:imageString];
        
        lengthDetail += length - attStr.length;
    }
    //更新到label上
    _contentL.attributedText = attStr;

}
+(detailcell *)cellWithtableView:(UITableView *)tableView{
    detailcell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    if (!cell) {
        cell = [[detailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
    }
    return cell;
}

@end
