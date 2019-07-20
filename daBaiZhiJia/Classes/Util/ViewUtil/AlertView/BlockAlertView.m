//
//  BlockAlertView.m
//  zdbios
//
//  Created by skylink on 15/8/27.
//  Copyright (c) 2015年 skylink. All rights reserved.
//

#import "BlockAlertView.h"

@implementation BlockAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        
        // content
    }
    
    return self;
}

+ (void)showAlertDialgWithAlertString:(NSString *)alertString {
    
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@""
                                                              message:alertString
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    alertView.clicked = ^(NSInteger buttonIndex) {};
    [alertView show];
}

+ (void)showAlertDialgWithAlertString:(NSString *)alertString complete:(void (^)(NSInteger buttonIndex))complete {
    
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@""
                                                              message:alertString
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定", nil];
    alertView.clicked = ^(NSInteger buttonIndex) {
    
        if (complete) {
            
            complete(buttonIndex);
        }
    };
    
    [alertView show];
}

+ (void)showAlertDialogWithAlertString:(NSString *)alertString complete:(void (^)(void))complete {
    
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@""
                                                              message:alertString
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
    alertView.clicked = ^(NSInteger buttonIndex) {
        
        if (complete) {
            
            complete();
        }
    };
    [alertView show];
}

+ (void)showAlertWithAString:(NSString *)alertString  cancleTitle:(NSString *)cancleTitle  sureTitle:(NSString*)sureTitle  complete:(void (^)(NSInteger))complete{

    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@""
                                                              message:alertString
                                                    cancelButtonTitle:cancleTitle
                                                    otherButtonTitles:sureTitle, nil];
    alertView.clicked = ^(NSInteger buttonIndex) {
        
        if (complete) {
            
            complete(buttonIndex);
        }
    };
    
    [alertView show];

}


#pragma mark --UIAlertViewDelegate delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_clicked) {
        
        _clicked(buttonIndex);
    }
}

@end
