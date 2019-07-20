//
//  UIView+Tools.h
//  zdbios
//
//  Created by skylink on 16/7/5.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

/**
 *  快速根据xib创建View
 */
+ (instancetype)viewFromXib;

//添加边框
- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;

@end
