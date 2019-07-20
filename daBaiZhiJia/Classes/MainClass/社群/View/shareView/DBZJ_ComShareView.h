//
//  DBZJ_ComShareView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/4.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBZJ_ComShareView : UIView
@property (nonatomic, strong) UIViewController *cur_vc;

@property (nonatomic, strong) id model;

@property (nonatomic, assign) BOOL  isFrom_sheQu;//是否来自社区

@property (nonatomic, assign) BOOL  isFrom_haiBao;//是否来自海报


- (void)show;


@end

NS_ASSUME_NONNULL_END
