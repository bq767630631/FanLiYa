//
//  GoToAuth_View.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/29.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>

//去授权
@interface GoToAuth_View : UIView
@property (nonatomic, strong) UIViewController *cur_vc;
@property (nonatomic, strong) UINavigationController *navi_vc;
- (void)setAuthInfo;
- (void)setFailInfo;
- (void)setTipsAuthInfo;

@end


