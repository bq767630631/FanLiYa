//
//  MineActiveAndTool.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrersonInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineActiveAndTool : UIView

@property (nonatomic, assign) BOOL isTool;


@property (nonatomic, strong) PersonRevenue * model;

@end

NS_ASSUME_NONNULL_END
