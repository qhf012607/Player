//
//  MBVideoPlayerViewController.m
//  yunbaolive
//
//  Created by rhonin on 2019/5/27.
//  Copyright © 2019年 cat. All rights reserved.
//

#import "MBVideoPlayerViewController.h"

@interface MBVideoPlayerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UILabel *titileLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *collect;
@property (weak, nonatomic) IBOutlet UIButton *pinglun;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputviewConstaraint;

@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation MBVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = true;
    [self registerForKeyboardNotifications];
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
        _inputviewConstaraint.constant = keyboardSize.height;
        [self.view layoutIfNeeded];
    }];
  
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGSize keyboardSize = [value CGRectValue].size;
    [UIView animateWithDuration:duration animations:^{
        _inputviewConstaraint.constant = 0;
     
         [self.view layoutIfNeeded];
    }];
   
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:true];
    return true;
}

@end
