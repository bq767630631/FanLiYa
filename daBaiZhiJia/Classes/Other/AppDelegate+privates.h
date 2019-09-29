//
//  AppDelegate+private.h
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "AppDelegate.h"
#import "JSHAREService.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "JPUSHService.h"
#import "MessageManger.h"
#import "MSLaunchView.h"
#import <JDSDK/KeplerApiManager.h>

// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (privates)<JPUSHRegisterDelegate,MSLaunchViewDeleagte>

//设置极光分享
- (void)setUpJShare;

//设置阿里百川
- (void)setUpAliSdk;

//设置极光推送
- (void)setUpJpushWithOptions:(NSDictionary *)launchOptions;

//设置jd
- (void)setUpJD;
//设置引导页
- (void)setUpGuidView;
@end

NS_ASSUME_NONNULL_END
