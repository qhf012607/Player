//
//  NSString+Calculation.h
//  QCColumbus
//
//  Created by XuQian on 6/21/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Calculation)
- (CGRect)calculateLabelRectWithSize:(CGSize)size font:(UIFont *)font;
- (CGFloat)calculateLabelHeightWithWidth:(float)width fontsize:(float)fontsize;
- (CGRect)calculateLabelRectWithWidth:(float)width fontsize:(float)fontsize;
- (CGRect)calculateLabelRectWithHeight:(float)height fontSize:(float)fontsize;

//计算NSString中英文字符串的字符长度。ios 中一个汉字算2字符数
- (int)charCount;

+(BOOL)judgePassWordLegal:(NSString *)pass;
@end
