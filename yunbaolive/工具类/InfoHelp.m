//
//  InfoHelp.m
//  PinShangStore
//
//  Created by PinShang on 15/8/6.
//  Copyright (c) 2015年 pinshang. All rights reserved.
//

#import "InfoHelp.h"

@interface InfoHelp ()

@end

@implementation InfoHelp

//设置时间
+ (NSString*)getTimes:(NSString*)creatTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[self getNowTimeTimestamp]];
    NSDate *creatDate = [dateFormat dateFromString:creatTime];
    
    //对比时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:creatDate];
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((((int)time)%(3600*24))%3600)/60;
    
    NSString *timeStr = @"";
    if (month > 0)
    {
        if (month > 6)
        {
            timeStr = creatTime;
        }
        else
        {
            timeStr =  [NSString stringWithFormat:@"%d月前",month];
        }
    }
    else if (days > 0)
    {
        if (days>=7)
        {
            timeStr = [NSString stringWithFormat:@"%d周前",days/7];
        }else
        {
            timeStr =  [NSString stringWithFormat:@"%d天前",days];
        }
    }
    else if (hours > 0)
    {
        timeStr = [NSString stringWithFormat:@"%d小时前",hours];
        
    }
    else if (minute > 0)
    {
        timeStr = [NSString stringWithFormat:@"%d分钟前",minute];
    }
    else
    {
        timeStr = @"刚刚";
    }
    
    return timeStr;
}


+(NSInteger )getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSInteger inTimeSp = [timeSp intValue];
    return inTimeSp;
    
}

+ (NSString*)getAddTime:(NSInteger)addTime currntTime:(NSInteger)currentTime
{
    if (currentTime == 0)
    {
        return @"";
    }
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDate *addDate = [NSDate dateWithTimeIntervalSince1970:addTime];
    
    //对比时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:addDate];
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((((int)time)%(3600*24))%3600)/60;
    
    NSString *timeStr = @"";
    if (month > 0)
    {
        if (month > 6)
        {
            timeStr = @"long long ago";
        }
        else
        {
            timeStr =  [NSString stringWithFormat:@"%d月前",month];
        }
    }
    else if (days > 0)
    {
        if (days>=7)
        {
            timeStr = [NSString stringWithFormat:@"%d周前",days/7];
        }else
        {
            timeStr =  [NSString stringWithFormat:@"%d天前",days];
        }
    }
    else if (hours > 0)
    {
        timeStr = [NSString stringWithFormat:@"%d小时前",hours];
        
    }
    else if (minute > 0)
    {
        timeStr = [NSString stringWithFormat:@"%d分钟前",minute];
    }
    else
    {
        timeStr = @"刚刚";
    }
    
    return timeStr;
}

#pragma mark - 获取当前时间
+ (NSInteger)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSDate *datenow = [NSDate date];
    NSInteger currentTimeYear = [[formatter stringFromDate:datenow]integerValue];
    
    NSLog(@"currentTimeString =  %ld",currentTimeYear);
    return currentTimeYear;
}

//获取当前的时间(年)
+ (NSInteger)getCurrYear{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSDate *datenow = [NSDate date];
    NSInteger currentTimeYear = [[formatter stringFromDate:datenow]integerValue];
    
    NSLog(@"currentTimeString =  %ld",currentTimeYear);
    return currentTimeYear;
}

//名称
+ (NSString*)getName:(NSString *)name
{
    if (name.length == 0)
    {
        return @"游客";
    }
//    else if (name.length < 3)
//    {
//        return name;
//    }
    else if (name.length < 5)
    {
        return [NSString stringWithFormat:@"%@***%@", [name substringToIndex:1], [name substringFromIndex:name.length - 1]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@***%@", [name substringToIndex:2], [name substringFromIndex:name.length - 2]];
    }
}

+ (NSString *)getCurrentTimeString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark -得到当前时间
+ (NSDate *)getCurrentTimeDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

#pragma mark -将指定时间转为Date
+ (NSDate *)getEndTime:(NSString *)theTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSDate *date = [dateFormatter dateFromString:theTime];
    return date;
}

#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    if ([telNumber length] == 0) {
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    if (!isMatch) {
        return NO;
    }
    return YES;
    
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)validateIdentityCard:(NSString *)identityCard{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma 正则匹配邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 邮编验证
+ (BOOL)validateZipCode:(NSString *)zipCode
{
    NSString *regex = @"[0-9]\\d{5}(?!\\d)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:zipCode];
    
}

#pragma mark - 密码限制（大于6个字符小于等于20个字符）
+ (BOOL)validatePassword:(NSString*)password{
    if (password.length >= 6 && password.length <= 20){
        return YES;
    }
    return NO;
}

#pragma  mark - 返回对应的imageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame andImageName:(NSString *)imageName{
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = frame;
    if (imageName == nil || imageName.length == 0) {
        return imageview;
    }
    imageview.image = [UIImage imageNamed:imageName];
    imageview.userInteractionEnabled = YES;
    return imageview;
}

#pragma mark - 返回对应的Label
+(UILabel *)createLabWithFrame:(CGRect)frame andTitle:(NSString *)title andFont:(CGFloat)fontSize TextColor:(UIColor *)tColor textAlignment:(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.textColor = tColor;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

#pragma mark - 返回对应的btn（纯）
+(UIButton *)createButWithFrame:(CGRect)frame{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    return  button;
}

#pragma mark - 返回对应的一个Button
+(UIButton *)createButtonWithFrame:(CGRect)frame setTitle:(NSString *)title titleColor:(UIColor *)btnTitColor titleFont:(CGFloat)fontSize{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:btnTitColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    return  button;
}

#pragma mark - 返回对应的一个只有背景图的Button/正常、选中
+(UIButton *)createButtonWithFrame:(CGRect)frame andNormBackImageName:(NSString *)normBackImageName andselectBackImageName:(NSString *)selectedBackImageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (normBackImageName == nil || normBackImageName.length == 0 || selectedBackImageName == nil || selectedBackImageName.length == 0) {
        return button;
    }
    [button setBackgroundImage:MBBIMG(normBackImageName) forState:UIControlStateNormal];
    [button setBackgroundImage:MBBIMG(selectedBackImageName) forState:UIControlStateSelected];
    return  button;
}

#pragma mark - 返回对应的一个只有背景图的Button/正常
+(UIButton *)createButtonWithFrame:(CGRect)frame andNormBackImageName:(NSString *)normBackImageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (normBackImageName == nil || normBackImageName.length == 0) {
        return button;
    }
    [button setBackgroundImage:MBBIMG(normBackImageName) forState:UIControlStateNormal];
    return  button;
}

#pragma mark - 返回对应的一个只有图的Button/正常
+(UIButton *)createButtonWithFrame:(CGRect)frame andNormImageName:(NSString *)normImageName Title:(NSString *)btnTitle{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (normImageName == nil || normImageName.length == 0) {
        return button;
    }
    [button setTitle:btnTitle forState:UIControlStateNormal];
    [button setImage:MBBIMG(normImageName) forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    return  button;
}

+ (NSString *)getProvince{
    NSString *proStr = [ProviceAndCityDic objectForKey:@"province"];
    return proStr;
}

+ (NSString *)getCity{
    NSString *city = [ProviceAndCityDic objectForKey:@"city"];
    return city;
}

#pragma mark - 判断是否是iPad
+ (BOOL)getIsIpad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
    
}


/**
 判断是否是X系列
 @return YSE or NO
 */
+ (BOOL)iPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}


+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
    
}

//  图片自适应
+ (void)imgViewFill:(UIImageView *)imgV{
    imgV.contentMode =  UIViewContentModeScaleAspectFill;
    imgV.clipsToBounds  = YES;
}

@end
