//
//  MPZG_TempVc.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/30.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MPZG_TempVc.h"
#import "HomePage_Model.h"
#import "AppDelegate.h"
#import "MPZG_TabBarContrl.h"
#import "MSLaunchView.h"

@interface MPZG_TempVc ()<MSLaunchViewDeleagte>

@end

@implementation MPZG_TempVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

#pragma mark -  MSLaunchViewDeleagte
-(void)launchViewLoadFinish:(MSLaunchView *)launchView{
    NSLog(@"代理方法进入======广告加载完成了");
}

- (void)setUp{
    UIImageView *tempImageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    tempImageV.image = ZDBImage(@"750&13342");
    [self.view addSubview:tempImageV];
    
    [HomePage_Model queryVerson:^{
        [tempImageV removeFromSuperview];
    MPZG_TabBarContrl *tabVc = [[MPZG_TabBarContrl alloc] init];
    AppDelegate*delegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = tabVc;
        delegate.tabVc = tabVc;
        [self setUpGuidView];
    }];
}


- (void)setUpGuidView{
    
    if ([MSLaunchView isFirstLaunch]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        NSArray *imageNameArray = @[@"welcom1",@"welcom2",@"welcom3",@"welcom4"];
        MSLaunchView *launchView = [MSLaunchView launchWithImages:imageNameArray isScrollOut:YES];
        launchView.showPageControl = YES;
        launchView.isHiddenSkipBtn = YES;
        launchView.pageDotColor = RGBColor(204, 204, 204);
        launchView.currentPageDotColor = RGBColor(255, 202, 9);
        
        launchView.skipTitle = @"跳过";
        launchView.skipTitleColor = RGBColor(51, 51, 51);
        launchView.skipTitleFont = [UIFont systemFontOfSize:14];
        launchView.skipBackgroundColor = RGBColor(255, 202, 9);
        launchView.isHiddenSkipBtn = NO;
        launchView.delegate = self;
        launchView.loadFinishBlock = ^(MSLaunchView * _Nonnull launchView) {
            NSLog(@"广告加载完成了loadFinishBlock ");
            [[NSNotificationCenter defaultCenter] postNotificationName:GuideViewLoadFinishNotification object:nil];
        };
    }
}
@end
