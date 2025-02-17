//
//  AppDelegate+private.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/13.
//  Copyright © 2019 包强. All rights reserved.
//

#import "AppDelegate+privates.h"
#import "IntelligenceSearchView.h"
#import "RegisterContrl.h"
#import "MyInvitation_CodeContrl.h"
#import "SearchSaveManager.h"
#import "CreateShareContrl.h"
#import "LoginContrl.h"
#import "RegisterContrl.h"
#import "Goto_LoginContrl.h"
#import "Bind_PhoneContrl.h"
#import "DetailWebContrl.h"
#import "ForeGetPwdcontrl.h"
#import "NewPeo_shareContrl.h"
#import "AppGuideV.h"

#import "SearchResultContrl.h"
#import "SearchSaveManager.h"
//#import <objc/runtime.h>
#import "ShowPopVManager.h"

#define QQShare_AppID @"1109202625"
#define QQShare_AppSecret @"3YCNoE9R8HIihBGY"
#define JD_KEY   @"b93c8303e7a76e0b718fffb410bbb0d2"
#define JD_Secret @"f0e73ec02d024eda93750e8497808b9b"

@implementation AppDelegate (privates)

- (void)setUpGuideVSec{
    if ([MSLaunchView isFirstLaunch]) {
        UIWindow *win = [UIApplication sharedApplication].windows.lastObject;
        AppGuideV *guide  = [AppGuideV viewFromXib];
        guide.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [win addSubview:guide];
        
    }
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


- (void)setUpJShare{
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = appKey;
//    config.SinaWeiboAppKey = @"374535501";
//    config.SinaWeiboAppSecret = @"baccd12c166f1df96736b51ffbf600a2";
//    config.SinaRedirectUri = @"https://www.jiguang.cn";
    config.QQAppId =  QQShare_AppID;//@"1105864531";
    config.QQAppKey =  QQShare_AppSecret; //@"glFYjkHQGSOCJHMC";
    config.WeChatAppId = WXAPPID;//WeChatShare_AppID;
    config.WeChatAppSecret = WXAPPSECRET;//WeChatShare_AppSecret;

//    config.TwitterConsumerKey = @"4hCeIip1cpTk9oPYeCbYKhVWi";
//    config.TwitterConsumerSecret = @"DuIontT8KPSmO2Y1oAvby7tpbWHJimuakpbiAUHEKncbffekmC";
    config.JChatProAuth = @"a7e2ce002d1a071a6ca9f37d";
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:YES];
}

- (void)setUpAliSdk{
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];//开发阶段打开日志开关，方便排查错误信息
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
          NSLog(@"百川SDK初始化成功");
    } failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];
    
 
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
    [[AlibcTradeSDK sharedInstance] setISVCode:@"nieyun_isv_code"];
    
    //    [[AlibcTradeSDK sharedInstance] setEnv:AlibcEnvironmentRelease];
    // 设置全局配置，是否强制使用h5
    //[[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
}

- (void)setUpJpushWithOptions:(NSDictionary *)launchOptions {
    //jpush相关
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode =%d  registrationID =%@",resCode, registrationID);
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    // apn 内容获取：
//    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSLog(@"remoteNotification %@",remoteNotification);

}


- (void)setUpJD{
    [[KeplerApiManager sharedKPService] asyncInitSdk:JD_KEY secretKey:JD_Secret sucessCallback:^{
        NSLog(@"setUpJD  sucessCallback");
    } failedCallback:^(NSError *error) {
        NSLog(@"setUpJD failedCallback  %@",error);
    }];
}

#pragma mark - 消息处理
/**
 iOS 8 - 10
 @param application
 @param userInfo
 @param completionHandler
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (self.isLaunchedByNotification) {
       
     
    }else{
        if (state ==UIApplicationStateActive) {
            NSLog(@"前台 收到通知");
          //  [MessageManger handleMessageWithInfo:userInfo];
        }else{
            NSLog(@"后台 处理通知");
            [MessageManger handleMessageWithInfo:userInfo];
        }
    }
   
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate 基于 iOS 10 及以上的系统版本
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (self.isLaunchedByNotification) {  //程序关闭状态点击推送消息打开
      
    }else{
        if (state ==UIApplicationStateActive) {
            NSLog(@"前台 收到通知");
            // [MessageManger handleMessageWithInfo:userInfo];
        }else{
            NSLog(@"后台 处理通知");
            [MessageManger handleMessageWithInfo:userInfo];
        }
    }
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        // [MessageManger handleMessageWithInfo:userInfo];
        //  [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"********** iOS10.0之后  **********");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    [UIApplication sharedApplication].applicationState;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"applicationState %zd",[UIApplication sharedApplication].applicationState);
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (self.isLaunchedByNotification) {//程序关闭状态点击推送消息打开
        }else{
            if (state ==UIApplicationStateActive) {
                NSLog(@"前台 收到通知");
               // [MessageManger handleMessageWithInfo:userInfo];
                
            }else{
                NSLog(@"后台 处理通知");
                [MessageManger handleMessageWithInfo:userInfo];
            }
        }
        
        
        //  [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
                                                   message:@"pushSetting"
                                                  delegate:self
                                         cancelButtonTitle:@"yes"
                                         otherButtonTitles:nil, nil];
    [test show];
    
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



#pragma mark -  UIApplicationDelegate
//该方法启动的时候不执行！！
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [[ShowPopVManager shareInstance] showPopV];
    NSLog(@"");
}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"");
  
    return;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if (pasteboard.string && pasteboard.string.length>0) {
        NSString *token = ToKen;
          UIViewController *cu_vc = [self getCurrentVC];
        if (pasteboard.string.length == 6 &&User_ID ==0 && token.length ==0) { //6位邀请码并且未登录
//              NSLog(@"%@",self.window);
            
            UINavigationController *navi = self.window.rootViewController.childViewControllers[self.tabVc.selectedIndex];
            if ([cu_vc isKindOfClass:[MyInvitation_CodeContrl class]]) {
                MyInvitation_CodeContrl *codeVc  = (MyInvitation_CodeContrl*)cu_vc;
                codeVc.code = pasteboard.string;
                pasteboard.string = @""; //使用完之后清空
                return;
            }
            
            RegisterContrl *vc = [RegisterContrl new];
            vc.codeStr = pasteboard.string;
            [navi pushViewController:vc animated:YES];
            pasteboard.string = @""; //使用完之后清空
            return;
        }
        
        if (![self isJumpToSearchV]) {//特定场景下不弹出
            return;
        }
        
        NSLog(@"string: %@",[UIPasteboard generalPasteboard].string);
        if ([self.pasBoardStr isEqualToString:pasteboard.string]) {//相同的内容不要重复弹出
            NSLog(@"pasBoardStr %@",self.pasBoardStr);
            return;
        }
        self.pasBoardStr = pasteboard.string;
        //item.taobao.com（淘宝）  mobile.yangkeduo.com （pdd）   item.m.jd.com（jd）
        if ([pasteboard.string containsString:@"item.taobao.com"]||[pasteboard.string containsString:@"mobile.yangkeduo.com"]||[pasteboard.string containsString:@"item.m.jd.com"]) { //搜索的是链接
            NSInteger type = 1;
            if ([pasteboard.string containsString:@"item.taobao.com"]) {
                type =1 ;
            }else if ([pasteboard.string containsString:@"mobile.yangkeduo.com"]){
                type = 2;
            }else if ([pasteboard.string containsString:@"item.m.jd.com"]){
                type = 3;
            }
            NSLog(@"type %zd", type);
            [self jumpToSearchVWithType:type];
            return;
        }

            IntelligenceSearchView *insear  = [IntelligenceSearchView viewFromXib];
            insear.contentStr = pasteboard.string;
            insear.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [insear showInWindowWithBackgoundTapDismissEnable:YES];
    }
}

//yes:可以弹出搜索视图
- (BOOL)isJumpToSearchV{
    UIViewController *curVc = [self getCurrentVC];
    if ([curVc isKindOfClass:[LoginContrl class]] ||[curVc isKindOfClass:[RegisterContrl class]] || [curVc isKindOfClass:[Goto_LoginContrl class]]||[curVc isKindOfClass:[Bind_PhoneContrl class]]||[curVc isKindOfClass:[DetailWebContrl class]] ||[curVc isKindOfClass:[ForeGetPwdcontrl class]] || [curVc isKindOfClass:[NewPeo_shareContrl class]]) { //GoodDetailContrl
        //这些场景不用弹出搜索视图
       
        return NO;
    }
    return YES;
}

//直接进入搜索结果界面
- (void)jumpToSearchVWithType:(NSInteger)type{
    //保存在历史搜索里面
    NSMutableArray *temp  = [SearchSaveManager getArray];
    if (![temp containsObject:self.pasBoardStr]) {
        [temp insertObject:self.pasBoardStr atIndex:0];
        [SearchSaveManager saveArrWithArr:temp];
    }
    
    SearchResultContrl *sear = [[SearchResultContrl alloc] initWithSearchStr:self.pasBoardStr];
    sear.searchType = type;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSLog(@"rootVc  %@",rootVc);
    UINavigationController *navi ;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        navi = (UINavigationController*)rootVc;
    }else if ([rootVc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController*)rootVc;
        navi = rootVc.childViewControllers[tab.selectedIndex];
    }else{
        UIViewController *vc = [UIViewController new];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    [navi pushViewController:sear animated:YES];
}

#pragma mark -  MSLaunchViewDeleagte
-(void)launchViewLoadFinish:(MSLaunchView *)launchView{
    NSLog(@"代理方法进入======广告加载完成了");
}


@end
