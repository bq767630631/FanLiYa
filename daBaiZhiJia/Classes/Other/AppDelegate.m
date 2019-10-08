//
//  AppDelegate.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/3/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "AppDelegate.h"
#import "MPZG_TempVc.h"
//#import "iVersion.h"
#import "AppDelegate+privates.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "WXApi.h"

#import "HomePage_Model.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [NSThread sleepForTimeInterval:0.8];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    MPZG_TempVc *tempVc = [[MPZG_TempVc alloc] init];
    self.window.rootViewController = tempVc;
    [self.window makeKeyAndVisible];
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [MessageManger shareMessage].remoteNotification = remoteNotification;

    [self setUpAliSdk];
    [self setUpJShare];
    [self setUpJD];
    [self setUpJpushWithOptions:launchOptions];
    //微信api注册
    [WXApi registerApp:WXAPPID];
    //setUpiVersion
 //   [iVersion sharedInstance].applicationBundleID = [[NSBundle mainBundle] bundleIdentifier];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; //
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"");
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    UIViewController *cuvc = [self getCurrentVC];
    NSLog(@"getCurrentVC  %@", cuvc);
    NSLog(@"url =%@",url);
    [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)cuvc];
    
    [JSHAREService handleOpenUrl:url];

    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    UIViewController *cuvc = [self getCurrentVC];
    NSLog(@"getCurrentVC  %@", cuvc);
    NSLog(@"url =%@",url);
    [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)cuvc];
    
    [JSHAREService handleOpenUrl:url];
   
    if (@available(iOS 9.0, *)) {
        __unused BOOL isHandledByALBBSDK=[[AlibcTradeSDK sharedInstance] application:application openURL:url options:options];
    } else {
        // Fallback on earlier versions
    }//处理其他app跳转到自己的app，如果百川处理过会返回YES
    return YES;
}


//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//   // [rootViewController addNotificationCount];
//}


@end
