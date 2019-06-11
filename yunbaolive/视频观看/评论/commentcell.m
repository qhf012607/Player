//
//  commentcell.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/5.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "commentcell.h"
@implementation commentcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //头像
        _avatar_Button = [UIButton buttonWithType:0];
        [_avatar_Button addTarget:self action:@selector(NOaction) forControlEvents:UIControlEventTouchUpInside];
        _avatar_Button.userInteractionEnabled = NO;
        _avatar_Button.layer.masksToBounds = YES;
        _avatar_Button.layer.cornerRadius = 15;
        _avatar_Button.frame = CGRectMake(10,25,30,30);
        [self addSubview:_avatar_Button];
        
        
        //名称
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = RGB_COLOR(@"#959697", 1);//RGB(123, 123, 123);
        _nameL.font = [UIFont systemFontOfSize:14];
        _nameL.frame = CGRectMake(_avatar_Button.right + 10,20,200,20);
        _nameL.numberOfLines = 0;
        [self addSubview:_nameL];
        
        
        //时间
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = GrayText;//RGB(208, 208, 208);
        _timeL.font = [UIFont systemFontOfSize:12];
        _timeL.frame = CGRectMake(_avatar_Button.right + 10, _nameL.bottom, 200, 20);
//        [self addSubview:_timeL];
        
        
        //回复名称
        _replayNameL = [[UILabel alloc]init];
        _replayNameL.textColor = RGB_COLOR(@"#959697", 1);//RGB(123, 123, 123);
        _replayNameL.font = [UIFont systemFontOfSize:13];
        [self addSubview:_replayNameL];
        //回复内容
        _replayContentL = [[UILabel alloc]init];
        _replayContentL.textColor = RGB_COLOR(@"#333333", 1);//RGB(123, 123, 123);
        _replayContentL.font = [UIFont systemFontOfSize:13];
        _replayContentL.numberOfLines = 0;
        [self addSubview:_replayContentL];

        //点赞
        _zan_Button = [UIButton buttonWithType:0];
        _zan_Button.frame = CGRectMake(_window_width - 60,10,50,50);
        _zan_Button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
        [self addSubview:_zan_Button];
        _zan_Button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
        [_zan_Button setTitle:@"0" forState:0];
        _zan_Button = [PublicObj setUpImgDownText:_zan_Button];
        [_zan_Button addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
        
        _bigbtn = [UIButton buttonWithType:0];
        _bigbtn.frame = CGRectMake(_window_width - 110, 10, 110, 50);
        [_bigbtn addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
        //回复
        _Reply_Button = [UIButton buttonWithType:0];
        _Reply_Button.backgroundColor = [UIColor clearColor];
        _Reply_Button.titleLabel.textAlignment = NSTextAlignmentLeft;
        _Reply_Button.layer.masksToBounds = YES;
        _Reply_Button.layer.cornerRadius = 5;
        _Reply_Button.hidden = YES;
        [_Reply_Button setTitleEdgeInsets:UIEdgeInsetsMake(0,-120,0,0)];
        if (IS_IPHONE_5) {
            [_Reply_Button setTitleEdgeInsets:UIEdgeInsetsMake(0,-40,0,0)];
        }
        [_Reply_Button setTitleColor:RGB(200, 200, 200) forState:0];//RGB(90, 92, 147)
        _Reply_Button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_Reply_Button addTarget:self action:@selector(makeReply) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:@"展开更多回复"];
        [attstr addAttribute:NSForegroundColorAttributeName value:RGB(200, 200, 200) range:NSMakeRange(0, 6)];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:@"relpay_三角下.png"];
        NSAttributedString *imageString;
        if (image) {
            attach.image = image;
            attach.bounds = CGRectMake(0, -4, 15, 15);
            imageString =   [NSAttributedString attributedStringWithAttachment:attach];
            [attstr appendAttributedString:imageString];
        }
        [_Reply_Button setAttributedTitle:attstr forState:0];
        
        [self addSubview:_Reply_Button];
        
        //内容
        _contentL = [[mylabels alloc]init];
        _contentL.lineBreakMode = NSLineBreakByCharWrapping;
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.textColor = RGB_COLOR(@"#333333", 1);//RGB(72, 72, 72);
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self addSubview:_contentL];
        
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);//RGB(230, 230, 230);
        [self addSubview:_lineL];
        self.backgroundColor = [UIColor whiteColor];//RGB(248, 248, 248);
        [self addSubview:_bigbtn];
        
    }
    return self;
}

-(void)NOaction{
    
    
}
//点赞
-(void)makeLike{
    if ([[Config getOwnID] intValue]<0) {
        [PublicObj warnLogin];
        return;
    }
    if ([_model.ID isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:@"不能给自己的评论点赞"];
        
        return;
    }
    if ([[Config getOwnID] intValue] < 0) {
        //[self.delegate youkedianzan];
        return;
    }
    //_bigbtn.userInteractionEnabled = NO;
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.addCommentLike&uid=%@&commentid=%@&token=%@",[Config getOwnID],_model.parentid,[Config getOwnToken]];
    WeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            //动画
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.zan_Button.imageView.layer addAnimation:[PublicObj bigToSmallRecovery] forKey:nil];
            });
            
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            NSString *islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
            NSString *likes = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
            
            [weakSelf.delegate makeLikeRloadList:weakSelf.model.parentid andLikes:likes islike:islike];
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}
//回复
-(void)makeReply{
    
    [self.delegate pushDetails:@{
                                 @"avatar":_model.avatar_thumb,
                                 @"user_nicename":_model.user_nicename,
                                 @"datetime":_model.datetime,
                                 @"content":_model.content,
                                 @"likes":_model.likes,
                                 @"islike":_model.islike,
                                 @"commentid":_model.commentid,
                                 @"parentid":_model.parentid,
                                 @"allcommecnts":_model.replys,
                                 @"ID":_model.ID,
                                 @"at_info":_model.at_info,
                                 }];
    
}
-(void)setModel:(commentModel *)model{
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
    //匹配表情文字
    NSArray *resultArr  = [[YBToolClass sharedInstance] machesWithPattern:emojiPattern andStr:_contentL.text];
    if (!resultArr) return;
    NSUInteger lengthDetail = 0;
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:_contentL.text];
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
        NSUInteger length = attstr.length;
        NSRange newRange = NSMakeRange(result.range.location - lengthDetail, result.range.length);
        [attstr replaceCharactersInRange:newRange withAttributedString:imageString];
        
        lengthDetail += length - attstr.length;
    }
    NSAttributedString *dateStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",_model.datetime] attributes:@{NSForegroundColorAttributeName:RGB_COLOR(@"#959697", 1),NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [attstr appendAttributedString:dateStr];
    //更新到label上
    _contentL.attributedText = attstr;

    //给被@加颜色
    NSData *mix_data = [_model.at_info dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *atArray = [NSJSONSerialization JSONObjectWithData:mix_data options:NSJSONReadingAllowFragments error:nil];
    if (atArray.count>0) {
        //有@
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];
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
    
    _contentL.frame = _model.contentRect;
    _Reply_Button.frame = _model.ReplyRect;
    
    int replys = [_model.replys intValue];
    if (replys>0) {
        if (replys > 1) {
            _Reply_Button.hidden = NO;
        }else{
            _Reply_Button.hidden = YES;
        }

        _replayNameL.hidden =NO;
        _replayContentL.hidden = NO;
        _replayNameL.frame = CGRectMake(70, _contentL.bottom, _window_width-120, 20);
        _replayContentL.frame = _model.ReplyFirstRect;
        _lineL.frame = CGRectMake(10,_model.ReplyRect.origin.y + _model.ReplyRect.size.height+13, _window_width-20,1);
        _replayContentL.text = _model.replyContent;
        _replayNameL.text = _model.replyName;
        
        NSArray *resultArr2  = [[YBToolClass sharedInstance] machesWithPattern:emojiPattern andStr:_replayContentL.text];
        if (!resultArr2) return;
        NSUInteger lengthDetail2 = 0;
        NSMutableAttributedString *attstr2 = [[NSMutableAttributedString alloc]initWithString:_replayContentL.text];
        //遍历所有的result 取出range
        for (NSTextCheckingResult *result in resultArr2) {
            //取出图片名
            NSString *imageName =   [_replayContentL.text substringWithRange:NSMakeRange(result.range.location, result.range.length)];
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
            NSUInteger length = attstr2.length;
            NSRange newRange = NSMakeRange(result.range.location - lengthDetail2, result.range.length);
            [attstr2 replaceCharactersInRange:newRange withAttributedString:imageString];
            
            lengthDetail2 += length - attstr2.length;
        }
        NSAttributedString *dateStr2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",_model.replyDate] attributes:@{NSForegroundColorAttributeName:RGB_COLOR(@"#959697", 1),NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        [attstr2 appendAttributedString:dateStr2];
        //更新到label上
        _replayContentL.attributedText = attstr2;

        
    }else{
        
        _Reply_Button.hidden = YES;
        _replayNameL.hidden =YES;
        _replayContentL.hidden = YES;
    }
    _lineL.frame = CGRectMake(10,_model.rowH-3, _window_width - 20,1);
}

+(commentcell *)cellWithtableView:(UITableView *)tableView{
    commentcell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
    if (!cell) {
        cell = [[commentcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentcell"];
    }
    return cell;
}

@end
