//
//  MPZG_NavigationContrl.m
//  MinPingZhangGui
//
//  Created by 包强 on 2018/12/24.
//  Copyright © 2018 包强. All rights reserved.
//

#import "MPZG_NavigationContrl.h"

@interface MPZG_NavigationContrl ()<UINavigationControllerDelegate>

@end

@implementation MPZG_NavigationContrl
#pragma mark - init

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    if (!self) {
        return nil;
    }
    
    [self navigationInitalise];
    return self;
}

- (void)navigationInitalise {
    [self.navigationController.navigationBar navBarBottomLineHidden:YES];
    [self.navigationController.navigationBar navBarBackGroundColor:ThemeColor image:nil isOpaque:YES];
       // self.interactivePopGestureRecognizer.enabled = YES;
    // RGBColor(236, 74, 60);// 设置导航栏颜色
   //self.navigationBar.tintColor = RGBColor(51, 51, 51);  // 设置导航栏字体颜色
    //self.navigationBar.barStyle  = UIBarStyleBlackOpaque;  // 设置状态栏为白色
   /* [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBColor(51, 51, 51),
                                                                      NSFontAttributeName : [UIFont PingFang_SC_MediumWithSize:16]}];*/
    //导航栏的字体颜色

//     [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"regis_nav_bg"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.f]}];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - event response

- (void)leftBarButtonItemClick:(UIBarButtonItem *)barButtonItem {
    
    [self popViewControllerAnimated:YES];
}


#pragma mark - system method

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 0) {
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_white"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
        
        viewController.navigationItem.leftBarButtonItem = barButtonItem;
    }
    
    if (self.viewControllers.count > 0) {
        // push 的时候隐藏 tableBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}




@end
