//
//  NSString+FontSize.m
//  zdbios
//
//  Created by skylink on 16/7/12.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import "NSString+FontSize.h"

@implementation NSString (FontSize)

- (CGSize)textSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGFloat)textHeightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    return [self textSizeWithFont:font maxSize:size].height;
}

- (CGFloat)textWidthWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight {
    
    CGSize size = CGSizeMake(MAXFLOAT, maxHeight);
    return [self textSizeWithFont:font maxSize:size].width;
}


@end
