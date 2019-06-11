//
//  HistoryCollectionViewCell.m
//  yunbaolive
//
//  Created by Jolly on 06/05/2019.
//  Copyright © 2019 cat. All rights reserved.
//

#import "HistoryCollectionViewCell.h"

@implementation HistoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 


}
- (void)config:(MBHistoryListModel *)model
{
    self.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImage.clipsToBounds  = YES;
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.thumb_app] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLab.text = model.title;
    self.viewsLab.text = model.views;
    
}
//- (IBAction)deleteList:(id)sender {
//
//    NSLog(@"点击删除按钮sender%@",sender.tag);
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
//
//
//
//}
@end
