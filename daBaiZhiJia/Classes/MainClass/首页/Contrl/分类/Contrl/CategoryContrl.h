//
//  CategoryContrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"
#import "JXCategoryListContainerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CategoryContrl : MPZG_BaseContrl<JXCategoryListContentViewDelegate>

//isSec:是否是二级分类界面 默认否
- (instancetype)initWithCateId:(NSString*)cid isSec:(BOOL)isSec secTitle:(NSString*)secTitle;

@property (nonatomic, strong) UINavigationController*naviContrl;

@property (nonatomic, strong) UITabBarController*tabBarContrl;
@end

NS_ASSUME_NONNULL_END
