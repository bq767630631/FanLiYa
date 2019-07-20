//
//  UIFont+Runtime.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "UIFont+Runtime.h"

@implementation UIFont (Runtime)

//+ (void)load{
//        // 获取替换后的类方法
//        Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
//        // 获取替换前的类方法
//        Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
//        // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
//        method_exchangeImplementations(newMethod, method);
//}
//
//+ (UIFont *)adjustFont:(CGFloat)fontSize {
//    UIFont *newFont = nil;
//    newFont = [UIFont adjustFont:fontSize *(SCREEN_WIDTH / 375 )];
//    return newFont;
//}


@end
