//
//  PingDuoduoPageHomecontrl.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_BaseContrl.h"
#import "JXCategoryListContainerView.h"


@interface PingDuoduoPageHomecontrl : MPZG_BaseContrl<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) UINavigationController*naviContrl;

@property (nonatomic, strong) UITabBarController*tabBarContrl;

@property (nonatomic, assign) CGFloat  viewH;

@property (nonatomic, copy) NSString *cid;

@property (nonatomic, assign) FLYPT_Type  pt;

- (void)refreshData;
@end


