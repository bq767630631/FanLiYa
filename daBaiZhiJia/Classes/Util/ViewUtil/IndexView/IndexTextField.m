//
//  IndexTextField.m
//  zdbios
//
//  Created by skylink on 15/10/21.
//  Copyright © 2015年 skylink. All rights reserved.
//

#import "IndexTextField.h"

@implementation IndexTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 禁止textField 全选、粘贴... 
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    return NO;
}

@end
