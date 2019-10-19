//
//  Home_headMenuFirst.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Home_headMenuFirst : UIView
@property (nonatomic, copy) NSString *tmcs;
@property (nonatomic, copy) NSString *tmgj;

@property (nonatomic, strong) NSMutableArray *firstList;

//限时抢购
- (void)setInfoWith:(NSMutableArray*)timeArr goodArr:(NSMutableArray*)goodArr;
@end

NS_ASSUME_NONNULL_END
