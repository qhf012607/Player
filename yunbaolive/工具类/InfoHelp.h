//
//  InfoHelp.h
//  PinShangStore
//
//  Created by PinShang on 15/8/6.
//  Copyright (c) 2015年 pinshang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoHelp : NSObject

//设置时间（刚刚，今天，昨天。前天。。。。。。）
+ (NSString*)getTimes:(NSString*)creatTime;

+ (NSString*)getAddTime:(NSInteger)addTime currntTime:(NSInteger)currentTime;

//名称
+ (NSString*)getName:(NSString *)name;

//获取当前时间转为字符串
+ (NSString *)getCurrentTimeString;

#pragma mark -得到当前时间date

/**
 获取当前时间对应的NSDate
 @return NSDate
 */
+ (NSDate *)getCurrentTimeDate;

/**
 将时间转换为对应的NSDate型
 @param theTime 传入时间字符串
 @return 对应的NSDate
 */
+ (NSDate *)getEndTime:(NSString *)theTime;

/**
 获取当前年份
 @return 当前年份
 */
+ (NSInteger)getCurrYear;

//正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;

//正则匹配用户身份证号15或18位
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

//正则匹配邮箱
+ (BOOL)validateEmail:(NSString *)email;

//密码
+ (BOOL)validatePassword:(NSString*)password;

/**
 判断是否是邮政编码
 @param zipCode 传入需要验证的邮政编码字符串
 @return 返回YES 则是邮政编码，反之不是
 */
+ (BOOL)validateZipCode:(NSString *)zipCode;

/**
 传入一个图片名称，与imageView的Frame，返回对应大小的imageView
 *Frame:不可为nil
 *imageName：可为nil
 */
+(UIImageView *)createImageViewWithFrame:(CGRect)frame andImageName:(NSString *)imageName;

/**
 @param frame frame
 @param title title
 @param fontSize 字体大小
 @param tColor 字体颜色
 @param alignment 对其方式
 @return 返回对应的lable
 */
+(UILabel *)createLabWithFrame:(CGRect)frame andTitle:(NSString *)title andFont:(CGFloat)fontSize TextColor:(UIColor *)tColor textAlignment:(NSTextAlignment)alignment;

/**
 @param frame frame
 @return 返回对应的纯btn
 */
+(UIButton *)createButWithFrame:(CGRect)frame;


/**
 @param frame frame
 @param title btnTitle
 @param btnTitColor titleColor
 @param fontSize btnTitleFontSize
 @return btn
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame setTitle:(NSString *)title titleColor:(UIColor *)btnTitColor titleFont:(CGFloat)fontSize;

/**
 @param frame frame
 @param normBackImageName 正常背景图名字
 @param selectedBackImageName 选中背景图名字
 @return 返回一个只有选中背景/正常背景的btn
 */
+(UIButton *)createButtonWithFrame:(CGRect)frame andNormBackImageName:(NSString *)normBackImageName andselectBackImageName:(NSString *)selectedBackImageName;

+(UIButton *)createButtonWithFrame:(CGRect)frame andNormBackImageName:(NSString *)normBackImageName;

+(UIButton *)createButtonWithFrame:(CGRect)frame andNormImageName:(NSString *)normImageName Title:(NSString *)btnTitle;
/**
 获取省
 @return 返回省份
 */
+(NSString *)getProvince;

/**
 获取区
@return 返回区
 */
+(NSString *)getCity;

/**
 判断是是否是iPad
 @return YES,是，NO，不是
 */
+ (BOOL)getIsIpad;

/**
 判断是否是X系列
 @return YSE or NO
 */
+ (BOOL)iPhoneXSeries;

//获取字符串宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;


/**
 图片自适应
 */
+ (void)imgViewFill:(UIImageView *)imgV;

@end
