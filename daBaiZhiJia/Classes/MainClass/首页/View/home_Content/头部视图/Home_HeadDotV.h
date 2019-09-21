//
//  Home_HeadDotV.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Home_HeadDotV : UIView
@property (weak, nonatomic) IBOutlet UIView *leftDot;
@property (weak, nonatomic) IBOutlet UIView *rightDot;

- (void)setDotColorWithLeft:(UIColor*)leftcolor right:(UIColor*)rightColor;
@end

NS_ASSUME_NONNULL_END
