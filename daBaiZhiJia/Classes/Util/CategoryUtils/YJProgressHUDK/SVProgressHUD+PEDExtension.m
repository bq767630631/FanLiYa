//
//  SVProgressHUD+PEDExtension.m
//  lfldelinDemo
//
//  Created by lfldelin on 2017/12/24.
//  Copyright © 2017年 lfldelin. All rights reserved.
//

#import "SVProgressHUD+PEDExtension.h"
#import <objc/runtime.h>
static char kSVProgressHUDShowCompletionKey;

@implementation SVProgressHUD (PEDExtension)

#pragma makr - 初始化属性

+ (void)initialize {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    
    /** 不允许用户点击操作 */
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    [SVProgressHUD setMinimumDismissTimeInterval:0.8];
    [SVProgressHUD setMaximumDismissTimeInterval:1.0];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHexString:@"#555555"]];// 弹出框颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]]; // 弹出框内容颜色
    [SVProgressHUD setCornerRadius:8.0];

    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]]; // @"info"
//    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"common_checkMark"]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SVProgressHUDDidDisappearNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        SVProgressHUDShowCompletion completion = objc_getAssociatedObject(self, &kSVProgressHUDShowCompletionKey);
        if (completion) {
            
            completion();
            completion = nil;
            objc_setAssociatedObject(self, &kSVProgressHUDShowCompletionKey, completion, OBJC_ASSOCIATION_COPY);
        }
    }];
}

#pragma mark - public methods 文字提示

+ (void)showMessage:(NSString *)message {
    
    [self showMessage:message completion:nil];
}

+ (void)showMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion {
    
    [self setMinimumSizeForNormalMessage:YES];
    [self addObserverWithCompletion:completion];
    [SVProgressHUD showInfoWithStatus:message];
}

#pragma mark - 成功文字提示

+ (void)showSuccessMessage:(NSString *)message {
    
    [self showSuccessMessage:message completion:nil];
}

+ (void)showSuccessMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion {
    
//    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
    
    [self setMinimumSizeForNormalMessage:NO];
    [self addObserverWithCompletion:completion];
    
    [SVProgressHUD showSuccessWithStatus:message];
}

#pragma mark - 失败文字提示

+ (void)showErrorMessage:(NSString *)message {
    
    [self showErrorMessage:message completion:nil];
}

+ (void)showErrorMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion {
    
//    [SVProgressHUD setErrorImage:[UIImage imageNamed:@""]];
    
    [self setMinimumSizeForNormalMessage:NO];
    [self addObserverWithCompletion:completion];
    
    [SVProgressHUD showErrorWithStatus:message];
}

#pragma mark - private methods

+ (void)setMinimumSizeForNormalMessage:(BOOL)normalMessage {
    
    if (normalMessage) {
        
            [SVProgressHUD setMinimumSize:CGSizeZero];
    } else {
        
        [SVProgressHUD setMinimumSize:CGSizeMake(120, 44)];
    }
}

+ (void)addObserverWithCompletion:(SVProgressHUDShowCompletion)completion {
   
    if (!completion) {
        return;
    }
    
    objc_setAssociatedObject(self, &kSVProgressHUDShowCompletionKey, completion, OBJC_ASSOCIATION_COPY);
}

@end

//    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD setMaximumDismissTimeInterval:0.5];


