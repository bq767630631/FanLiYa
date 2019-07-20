//
//  NSString+Extention.h
//  zdbios
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)

/**
 * @brief 保留最多 四位小数 用于 散数、散价 (不作四舍五入)
 */
+ (NSString *)stringRoundingMaxFourDigitWithNumber:(double)number;

/**
 * @brief 保留最多 两位小数 用于件价 (不作四舍五入)
 */
+ (NSString *)stringRoundingMaxTwoDigitWithNumber:(double)number;

/**
 * @brief 自动保留两位小数，不足两位小数，自动补 0  用于金额(强制2位小数)
 */
+ (NSString *)stringRoundingTwoDigitWithNumber:(double)number;

/**
 * @brief   截取指定小数位的值
 * @param   number 需要转化的数据
 * @param   digit  有效小数位
 * @return  截取后数据
 */
+ (NSString *)stringRoundingWithNumber:(double)number digit:(NSInteger)digit;

/**
 * @brief 正则验证邮箱
 */
- (BOOL)validateEmail;

/**
 * @brief 电话号码验证
 */
- (BOOL)validateTelephone;

/**
 * @brief 手机号码验证
 */
- (BOOL)validateMobile;

/**
 调起QQ会话
 @return 失败/成功
 */
- (BOOL)contactQQ;

- (BOOL)isSuccess;


/**
 * 字符串判空处理
 */
+ (NSString *)stringIsNullOrEmptry:(id)obj;

/**
 *YES:未空，NO:不为空
 */
- (BOOL)strIsEmptyOrNot;

/*
 *根据baseurl 拼接请求地址
 */
+ (instancetype)baseUrlWithFields:(NSString*)field;


/**
 *  md5加密的字符串
 *
 *
 *
 * 
 */
+ (NSString *)md5:(NSString *)str;

+ (NSString *)getRandomStr;

@end
