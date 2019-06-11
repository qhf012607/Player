//
//  detailHead.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "detailHead.h"

@implementation detailHead

-(instancetype)init{
    self = [super init];
    if (self) {
        
       self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)justdoit:(NSDictionary *)dic comment:(commectdetailblock)comment{
    
    self.commentblock = comment;
    //头像
    _avatar_Button = [UIButton buttonWithType:0];
    _avatar_Button.frame = CGRectMake(10,20,40,40);
    _avatar_Button.layer.masksToBounds = YES;
    _avatar_Button.layer.cornerRadius = 20;
    [self addSubview:_avatar_Button];
    
    
    //名称
    _nameL = [[UILabel alloc]init];
    _nameL.textColor = GrayText;//RGB(123, 123, 123);
    _nameL.font = [UIFont systemFontOfSize:14];
    _nameL.frame = CGRectMake(_avatar_Button.right + 10,20,200,20);
    _nameL.numberOfLines = 0;
    [self addSubview:_nameL];
    
    
    //时间
//    _timeL = [[UILabel alloc]init];
//    _timeL.textColor = GrayText;//RGB(208, 208, 208);
//    _timeL.font = [UIFont systemFontOfSize:12];
//    _timeL.frame = CGRectMake(_avatar_Button.right + 10, _nameL.bottom, 200, 20);
//    [self addSubview:_timeL];
//
    
    //点赞
    _zan_Button = [UIButton buttonWithType:0];
    _zan_Button.frame = CGRectMake(_window_width - 60,0,50,50);
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
     [self addSubview:_bigbtn];
    
    //回复内容
    _contentL = [[mylabels alloc]init];
    _contentL.lineBreakMode = NSLineBreakByCharWrapping;
    _contentL.textAlignment = NSTextAlignmentLeft;
    _contentL.textColor = RGB_COLOR(@"#333333", 1);
    _contentL.font = [UIFont systemFontOfSize:14];
    _contentL.numberOfLines = 0;
    [self addSubview:_contentL];
    
    
    //回复数量
    _allComments = [[UILabel alloc]init];
    _allComments.textColor = GrayText;
    _allComments.backgroundColor = [UIColor clearColor];
    _allComments.font = [UIFont systemFontOfSize:18];
    [self addSubview:_allComments];
    
    
    //分割线
    _lineL = [[UILabel alloc]init];
    _lineL.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    [self addSubview:_lineL];
    
    
    [self setdata:dic];
    self.backgroundColor = [UIColor whiteColor];
    
    
}
-(void)setdata:(NSDictionary *)dic{
    _hostdic = [NSDictionary dictionaryWithDictionary:dic];
    [_avatar_Button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"avatar"]]] forState:0];
    _nameL.text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
//    _timeL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"datetime"]];
//    _contentL.text = [NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"content"],[dic valueForKey:@"datetime"]];
    _contentL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];

    //给被@加颜色
    NSData *mix_data = [[dic valueForKey:@"at_info"] dataUsingEncoding:NSUTF8StringEncoding];
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
    
    [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
    CGSize size = [_contentL.text boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _contentRect = CGRectMake(60,_nameL.bottom+5, size.width + 20, size.height);
    _contentL.frame = _contentRect;
    _allComments.frame = CGRectMake(0, _contentRect.origin.y + _contentRect.size.height+10, _window_width/2,50);
    _lineL.frame =  CGRectMake(10, _allComments.bottom - 1, _window_width-20, 1);
    
    NSString *islike = [NSString stringWithFormat:@"%@",[dic valueForKey:@"islike"]];
    
    if ([islike isEqual:@"1"]) {
        //_bigbtn.userInteractionEnabled = NO;
        [_zan_Button setTitleColor:RGB_COLOR(@"#fa561f", 1) forState:0];
        [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
    }else{
        [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
        [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
    }
    //匹配表情文字
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
    NSAttributedString *dateStr2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[dic valueForKey:@"datetime"]] attributes:@{NSForegroundColorAttributeName:RGB_COLOR(@"#959697", 1),NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    [attStr appendAttributedString:dateStr2];

    //更新到label上
    _contentL.attributedText = attStr;

}
//点赞
-(void)makeLike{
    if ([[Config getOwnID] intValue]<0) {
        [PublicObj warnLogin];
        return;
    }
    if ([[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"ID"]] isEqual:[Config getOwnID]]) {
        
        [MBProgressHUD showError:@"不能给自己的评论点赞"];
        
        return;
    }
    
    //_bigbtn.userInteractionEnabled = NO;
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.addCommentLike&uid=%@&commentid=%@&token=%@",[Config getOwnID],[_hostdic valueForKey:@"parentid"],[Config getOwnToken]];
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
            if ([islike isEqual:@"1"]) {
                //_bigbtn.userInteractionEnabled = NO;
                [weakSelf.zan_Button setTitleColor:RGB_COLOR(@"#fa561f", 1) forState:0];
                [weakSelf.zan_Button setTitle:[NSString stringWithFormat:@"%@",likes] forState:0];
                [weakSelf.zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
                
            }else{
                [weakSelf.zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
                [weakSelf.zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
                [weakSelf.zan_Button setTitle:[NSString stringWithFormat:@"%@",likes] forState:0];
            }
            //self.commentblock(likes);
            self.commentblock(likes, islike);
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:minstr([data valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
    
}

@end
