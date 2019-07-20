//
//  UIFont+familyName.m
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/26.
//  Copyright © 2018 包强. All rights reserved.
//

#import "UIFont+familyName.h"
#import <objc/runtime.h>

/*
 font:'PingFangSC-Medium'
    font:'PingFangSC-Semibold'
    font:'PingFangSC-Light'
    font:'PingFangSC-Ultralight'
  font:'PingFangSC-Regular'
[    font:'PingFangSC-Thin'*/
@implementation UIFont (familyName)

+ (instancetype)PingFang_SC_MediumWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize *SCALE_MAX];
}

+ (instancetype)PingFang_SC_RegularWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize*SCALE_MAX ];
}

+ (instancetype)PingFang_SC_BoldrWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize*SCALE_MAX];
}

+ (instancetype)PingFang_SC_LightWithSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"PingFangSC-Light" size:fontSize*SCALE_MAX];
}





@end
