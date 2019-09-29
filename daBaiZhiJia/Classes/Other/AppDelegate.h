//
//  AppDelegate.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPZG_TabBarContrl.h"
static NSString *appKey = @"8887346d7e4430bee1ed8fc2"; //极光推送appkey 8887346d7e4430bee1ed8fc2

static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MPZG_TabBarContrl *tabVc;

@property (nonatomic, assign) BOOL  isLaunchedByNotification;
@end

