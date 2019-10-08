//
//  PageViewController.h
//  NavTabScrollView
//
//  Created by tashaxing on 9/15/16.
//  Copyright © 2016 tashaxing. All rights reserved.
//

// ---- 具体的内容页面类 ---- //

#import "MPZG_BaseContrl.h"
#import "JXCategoryListContainerView.h"

@interface PageViewController : MPZG_BaseContrl<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, strong) UINavigationController*naviContrl;

@property (nonatomic, strong) UITabBarController*tabBarContrl;

@property (nonatomic, assign) CGFloat  viewH;

@end
