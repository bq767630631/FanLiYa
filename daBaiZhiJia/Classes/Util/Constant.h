//
//  Constant.h
//  zdbios
//
//  Created by skylink on 16/7/9.
//  Copyright © 2016年 skylink. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#pragma mark - log
///////////////////

#ifdef DEBUG
#define ZDBLog(...) NSLog(@"%s[%d] %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define BASE_URL      @"http://app.dabaihong.com"
//#define Image_BaseUrl @"http://www.plyx168.com"
#define WXAPPID       @"wx1735813440622637"
#define WXAPPSECRET   @"0ce7444dad8fab89e6b90bd44b59be2c"
#define BASE_WEB_URL  @"http://app.dabaihong.com/app2019/"
#else
#define ZDBLog(...)
#define BASE_URL      @"http://app.dabaihong.com"
//#define Image_BaseUrl @"https://m.mpzg168.com"
#define WXAPPID       @"wx1735813440622637"
#define WXAPPSECRET   @"0ce7444dad8fab89e6b90bd44b59be2c"
#define BASE_WEB_URL  @"http://app.dabaihong.com/app2019/"
#endif

#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
//#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif

//表示请求成功
#define SucCode 2000
//表示没有更多数据
#define NoDataCode 2001
#define Token_isInvalidCode  1003
#define UnauthCode 1005
#define PageSize 10

#define ToKen        ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) ? ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) : @""

#define DeviceToken  ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) ? ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) : @""

#define  User_ID       [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] integerValue]

#define  Level       [[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] integerValue]

#define  Mobile_Phone   [[[NSUserDefaults standardUserDefaults] objectForKey:@"person_mobile"] integerValue]

#define   Is_Show_Info    [[[NSUserDefaults standardUserDefaults] objectForKey:IsShow_InfoKey] boolValue]

//#define PageSize  10

#pragma mark - screen
////////////////////

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE  ([UIScreen mainScreen].scale)

#define SCREEN_ONE_PIX (1 / SCREEN_SCALE)

//适配小屏幕
#define SCALE   MIN(1,(SCREEN_WIDTH/375))
//适配大屏幕
#define SCALE_MAX MAX(1, (SCREEN_WIDTH/375))

#define SCALE_Normal (SCREEN_WIDTH/375)

#define IS_MAX_SCREEN  SCREEN_WIDTH == 414

#define NavigationBarBottom(navigationBar) \
CGRectGetHeight(navigationBar.frame) + \
CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)


#define kIphone5sWidth   (320)
#define kIphone5sHeight (568)


// 提示图片
#define kNetworkErrorImageName (@"emptyTips_notReachable") // 网络错误
#define kServerWithoutData     (@"emptyTipsIcon")     // 查询(请求)服务器无数据
#define kServerReturnFailed    (@"emptyTips_returnFailedIcon")    // 服务器返回失败
#define kNetworkTimedOut       (@"emptyTips_timeOutIcon") // 网络请求超时

// 提示语
#define kNetworkErrorTips   (@"网络连接失败，请检查网络")
#define kNetworkTimeOutTips (@"网络数据请求超时")
#define kWithoutDataTips    (@"抱歉，没有找到符合条件的商品")
#define kReturnFailedTips   (@"有网络，服务器返回失败")

#pragma mark - color
////////////////////


//选择器颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
// 获取随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//主题色
#define ThemeColor RGBColor(33, 33, 33)



// 十六进制 -> 十进制
#define ColorFromRGB(rgbValue, a)  \
\
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
                green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
                 blue:((float)((rgbValue) & 0x0000FF))/255.0 \
                alpha:y]
// 分割线颜色
#define SplitLineColor [UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1]

#pragma mark - system version
////////////////////

#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7_AND_OLDER  ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 ? YES : NO)
#define iOS7_AND_LATEST ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define iOS8_AND_LATEST ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define iOS11_AND_LATEST ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES : NO)

#define IOS_APP_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark - view
////////////////////

// 设置 view 圆角和边框
#define ViewBorderRadius(view, radius, color) \
\
[view.layer setCornerRadius:(radius)]; \
[view.layer setMasksToBounds:YES]; \
[view.layer setBorderWidth:(SCREEN_ONE_PIX)]; \
[view.layer setBorderColor:[color CGColor]]

#pragma mark - sandbox directory
////////////////////////////////

#define SANDBOX_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define SANDBOX_CACHE_PATH    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define SANDBOX_TEMP_PATH     NSTemporaryDirectory()

#pragma mark - iphone device

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否是ipad
#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPOD   ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define IS_iPhone5SE    (SCREEN_WIDTH == 320.0f && SCREEN_HEIGHT == 568.0f)
#define IS_iPhone6_6s   (SCREEN_WIDTH == 375.0f && SCREEN_HEIGHT == 667.0f)
#define IS_iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

// 6p字体就是1.5倍
#define Font_Scale           ( SCREEN_WIDTH==414.f ? 1.5 : 1)

// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)

// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_IPAD : NO)

#define Height_StatusBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)

#define Height_TabBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)

#define IS_X_Xr_Xs_XsMax ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? YES : NO)

#define Bottom_Safe_AreaH   34.0

#pragma mark - notification

#define ChangeHeadImageSucNotiFi @"ChangeHeadImageSucNotiFi"

#pragma mark - other
////////////////////

#define ZDBNotificationCenter [NSNotificationCenter defaultCenter]
#define ZDBImage(imageName)   [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

/**
 * 检测字符串是否为空 : NO 不为空  YES 为空
 */
#define ZDBStrigIsEmpty(string) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/**
 * 检测字数组是否为空 : NO 不为空  YES 为空
 */
#define ZDBArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 * 检测字典是否为空 : NO 不为空  YES 为空
 */
#define ZDBDictIsEmpty(dict) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/**
 * 检测对象是否为空 : NO 不为空  YES 为空
 */
#define ZDBObjectIsEmpty(object) (object == nil \
\
|| [object isKindOfClass:[NSNull class]] \
|| ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) \
|| ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0))


/** 视图的Y坐标:状态栏高度 + 导航栏高度*/
#define VIEW_Y  self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height

/**状态栏高度 */
#define StatusBar_H   [[UIApplication sharedApplication] statusBarFrame].size.height

/**tabBar高度（前提是有tabBarController） */
#define TabBar_H      self.tabBarController.tabBar.frame.size.height



/** 拼接的url全路径 */
#define URL_Add(a)  [NSString baseUrlWithFields:a]



#define LeftAndRightMargin 15.f




#pragma mark - 微信相关 wx_unionid
#define WX_Accssen_Token   [[NSUserDefaults standardUserDefaults]  objectForKey:@"wx_access_token"]
#define WX_open_ID  [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_openid"]
#define WX_nick_name  [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_nickname"]
#define WX_headimg_url  [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_headimgurl"]
#define WX_sex  [[[NSUserDefaults standardUserDefaults] objectForKey:@"wx_sex"] integerValue]
#define WX_unionid  [[NSUserDefaults standardUserDefaults] objectForKey:@"wx_unionid"]


#endif /* Constant_h */
