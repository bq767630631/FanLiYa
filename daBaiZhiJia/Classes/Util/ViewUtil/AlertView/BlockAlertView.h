//
//  BlockAlertView.h
//  zdbios
//
//  Created by skylink on 15/8/27.
//  Copyright (c) 2015年 skylink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AlertDialogBlock) (NSInteger buttonIndex);

@interface BlockAlertView : UIAlertView <UIAlertViewDelegate>

@property (strong) AlertDialogBlock clicked;  // 点击事件

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (void)showAlertDialgWithAlertString:(NSString *)alertString;

+ (void)showAlertDialgWithAlertString:(NSString *)alertString complete:(void (^)(NSInteger buttonIndex))complete;


+ (void)showAlertDialogWithAlertString:(NSString *)alertString complete:(void (^)(void))complete ;

+ (void)showAlertWithAString:(NSString *)alertString  cancleTitle:(NSString *)cancleTitle  sureTitle:(NSString*)sureTitle  complete:(void (^)(NSInteger  buttonIndex))complete; //自定义按钮的名字
@end
