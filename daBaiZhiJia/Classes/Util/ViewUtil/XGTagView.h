//
//  XGTagView.h
//  Sort_Pro
//
//  Created by 包强 on 2019/1/8.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^XGTagViewBlock)(NSString *str);
@interface XGTagView : UIView

/**
 *  初始化
 *
 *  @param frame    frame
 *  @param tagArray 标签数组
 *
 * // 
 */
- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSArray*)tagArray;

// 标签数组
@property (nonatomic,retain) NSArray* tagArray;

// 选中标签文字颜色
@property (nonatomic,retain) UIColor* textColorSelected;
// 默认标签文字颜色
@property (nonatomic,retain) UIColor* textColorNormal;

// 选中标签背景颜色
@property (nonatomic,retain) UIColor* backgroundColorSelected;
// 默认标签背景颜色
@property (nonatomic,retain) UIColor* backgroundColorNormal;

@property (nonatomic,copy)XGTagViewBlock block;
@end

NS_ASSUME_NONNULL_END
