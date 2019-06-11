//
//  NSString+Calculation.m
//  QCColumbus
//
//  Created by XuQian on 6/21/16.
//  Copyright © 2016 Quancheng-ec. All rights reserved.
//

#import "NSString+Calculation.h"

@implementation NSString (Calculation)

- (CGFloat)calculateLabelHeightWithWidth:(float)width fontsize:(float)fontsize {
    CGRect rect = [self calculateLabelRectWithSize:CGSizeMake(width, MAXFLOAT) font:[UIFont systemFontOfSize:fontsize]];
    return ceil(rect.size.height);
}

- (CGRect)calculateLabelRectWithWidth:(float)width fontsize:(float)fontsize {
    return [self calculateLabelRectWithSize:CGSizeMake(width, MAXFLOAT) font:[UIFont systemFontOfSize:fontsize]];
}

- (CGRect)calculateLabelRectWithSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [self boundingRectWithSize:size options:(NSStringDrawingOptions)options attributes:attributes context:nil];
}

- (CGRect)calculateLabelRectWithHeight:(float)height fontSize:(float)fontsize {
    return [self calculateLabelRectWithSize:CGSizeMake(MAXFLOAT, height) font:[UIFont systemFontOfSize:fontsize]];
}

- (int)charCount
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}


+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 4){
        // 判断长度大于4位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{4,11}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}



@end
