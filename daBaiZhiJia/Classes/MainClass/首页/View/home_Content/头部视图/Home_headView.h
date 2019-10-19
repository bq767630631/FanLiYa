//
//  Home_headView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface Home_headView : UIView

@property (nonatomic, strong) SDCycleScrollView*myScroview; //代码创建的banber

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, copy) NSString *tmcs;

@property (nonatomic, copy) NSString *tmgj;

@property (nonatomic, strong) NSMutableArray *menuList;//菜单数组

//限时抢购
- (void)setInfoWith:(NSMutableArray*)timeArr goodArr:(NSMutableArray*)goodArr;
@end

NS_ASSUME_NONNULL_END
