//
//  NSString+Extention.m
//  zdbios
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import "NSString+Extention.h"
#import<CommonCrypto/CommonDigest.h>

@implementation NSString (Extention)

+ (NSString *)stringRoundingMaxFourDigitWithNumber:(double)number {

    return [self stringRoundingWithNumber:number digit:4];
}

+ (NSString *)stringRoundingMaxTwoDigitWithNumber:(double)number {

    return [self stringRoundingWithNumber:number digit:2];
}

+ (NSString *)stringRoundingTwoDigitWithNumber:(double)number {
    
    NSString *string = [self stringRoundingMaxTwoDigitWithNumber:number];
    double price = [string doubleValue];
    string = [NSString stringWithFormat:@"%.2f", price];
    return string;
}

+ (NSString *)stringRoundingWithNumber:(double)number digit:(NSInteger)digit {
    
    NSString *numberString = [NSString stringWithFormat:@"%lf", number];
    NSDecimalNumber *ouncesDecimal = [NSDecimalNumber decimalNumberWithString:numberString];
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:digit raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (NSString *)stringIsNullOrEmptry:(id)obj {
    
    if ([obj isEqual:@"NULL"] || [obj isKindOfClass:[NSNull class]] || [obj isEqual:[NSNull null]] || [obj isEqual:NULL] || [[obj class] isSubclassOfClass:[NSNull class]] || obj == nil || obj == NULL || [obj isKindOfClass:[NSNull class]] || [[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [obj isEqualToString:@"<null>"] || [obj isEqualToString:@"(null)"]) {
        
        return @"";
    }
    return obj;
}

- (BOOL)strIsEmptyOrNot{
    if ([self isEqual:@"NULL"] || [self isKindOfClass:[NSNull class]] || [self isEqual:[NSNull null]] || [self isEqual:NULL] || [[self class] isSubclassOfClass:[NSNull class]] || self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [self isEqualToString:@"<null>"] || [self isEqualToString:@"(null)"]) {
        
        return YES;
    }
    return NO;
}


- (BOOL)isSuccess
{
    if ([self isEqualToString:@"SUCCESS"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 正则表达式

//正则验证邮箱
- (BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)validateTelephone
{
    //("^(\\d{3,4}-)\\d{7,8}$")
    //电话以3个或4个数字开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//手机号码验证
- (BOOL)validateMobile
{
    NSString * phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)contactQQ
{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        
        NSString * string = [NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web&web_src=oicqzone.com",self];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        return YES;
    }else{
        return NO;
    }
}

+ (instancetype)baseUrlWithFields:(NSString *)field{
    return [NSString stringWithFormat:@"%@%@",BASE_URL,field];
}

+ (NSString *)md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)getRandomStr{
    char data[6];
    for (int x=0;x < 6;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:6 encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    NSLog(@"randomStr:%@",string);
    return string;
    
}


@end
