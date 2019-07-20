//
//  SVProgressHUD+PEDExtension.h
//  lfldelinDemo
//
//  Created by lfldelin on 2017/12/24.
//  Copyright © 2017年 lfldelin. All rights reserved.
//

//#import <SVProgressHUD/SVProgressHUD.h>
#import "SVProgressHUD.h"

typedef void(^SVProgressHUDShowCompletion)(void);

@interface SVProgressHUD (PEDExtension)

#pragma mark - 单纯 文字提示

+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion;

#pragma mark - 成功 图文提示

+ (void)showSuccessMessage:(NSString *)message;

+ (void)showSuccessMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion;

#pragma mark - 失败 图文提示

+ (void)showErrorMessage:(NSString *)message;

+ (void)showErrorMessage:(NSString *)message completion:(SVProgressHUDShowCompletion)completion;

@end
