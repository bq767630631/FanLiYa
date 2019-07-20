//
//  UIFont+familyName.h
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/26.
//  Copyright © 2018 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (familyName)
//PingFang-SC-Medium
+ (instancetype)PingFang_SC_MediumWithSize:(CGFloat)fontSize;

//PingFang-SC-Regular
+ (instancetype)PingFang_SC_RegularWithSize:(CGFloat)fontSize;

//PingFang-SC-Bold
+ (instancetype)PingFang_SC_BoldrWithSize:(CGFloat)fontSize;

+ (instancetype)PingFang_SC_LightWithSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
