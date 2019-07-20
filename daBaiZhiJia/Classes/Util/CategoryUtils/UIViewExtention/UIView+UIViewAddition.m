//
//  UIView+UIViewAddition.m
//  MeilaV2
//
//  Created by Terran Wu on 4/17/13.
//  Copyright (c) 2013 PinHui. All rights reserved.
//

#import "UIView+UIViewAddition.h"

@implementation UIView (UIViewAddition)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)showFrame
{
//    LOGDEBUG(@"%f %f %f %f", self.frame.origin.x, self.frame.origin.y, self.width, self.height);
}

+ (UIWindow *)mainWindow
{
    UIWindow *window = nil;
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        window = [[UIApplication sharedApplication].delegate window];
    }
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if (!window && [UIApplication sharedApplication].windows.count > 0) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

@end
