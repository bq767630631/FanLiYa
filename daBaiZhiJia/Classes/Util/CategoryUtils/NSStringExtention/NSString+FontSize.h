//
//  NSString+FontSize.h
//  zdbios
//
//  Created by skylink on 16/7/12.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FontSize)

/**
 *  @brief 根据字数的不同, 求得text文字需要占用多少Size
 *  @param font 文本字体
 *  @param maxSize 约束的尺寸
 *  @return 文本的实际尺寸
 */
- (CGSize)textSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  @brief  根据文本字数/文本宽度约束/文本字体 求得 text 的 height
 *  @param font  文本字体
 *  @param maxWidth 宽度约束
 *  @return 文本的实际高度
 */
- (CGFloat)textHeightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/**
 *  @brief  根据文本字数/文本高度约束/文本字体 求得text的 width
 *  @param font  文本字体
 *  @param maxHeight 高度约束
 *  @return 文本的实际长度
 */
- (CGFloat)textWidthWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight;


@end
