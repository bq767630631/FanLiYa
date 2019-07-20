//
//  UIView+UIViewAddition.h
//  MeilaV2
//
//  Created by Terran Wu on 4/17/13.
//  Copyright (c) 2013 PinHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewAddition)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

+ (UIWindow *)mainWindow;
- (void)showFrame;

@end
