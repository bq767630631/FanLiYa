//
//  GoodDetailInvalidV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailInvalidV.h"

@implementation GoodDetailInvalidV

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.actionBtn, self.actionBtn.height *0.5, UIColor.clearColor);
}


- (IBAction)goToGunag:(UIButton *)sender {
    self.viewController.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
    self.viewController.navigationController.tabBarController.selectedIndex = 0;
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}


@end
