//
//  CouponSearchView.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^couponSearchBlock)(BOOL isOn);
@interface CouponSearchView : UIView

@property (nonatomic, copy) couponSearchBlock block;

@end

NS_ASSUME_NONNULL_END
