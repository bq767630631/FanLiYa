//
//  ShowPopVManager.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/10/21.
//  Copyright © 2019 包强. All rights reserved.
//

#import "ShowPopVManager.h"

#import "AppDelegate.h"
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
#import "SearchResultContrl.h"

@interface ShowPopVManager ()
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MPZG_TabBarContrl *tabVc;
@end
@implementation ShowPopVManager
+ (instancetype)shareInstance{
    static ShowPopVManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ShowPopVManager allocWithZone:nil];
    });
    return manager;
}


- (void)showPopV{
      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string && pasteboard.string.length>0) {
        NSString *token = ToKen;
        UIViewController *cu_vc = [self getCurrentVC];
        if (pasteboard.string.length == 6 &&User_ID ==0 && token.length ==0) { //6位邀请码并且未登录
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            self.window  = delegate.window;
            self.tabVc = delegate.tabVc;
            NSLog(@"window  %@",self.window);
            
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
        
        NSLog(@"genestring: %@",[UIPasteboard generalPasteboard].string);
        NSLog(@"pasBoardStr %@",self.pasBoardStr);
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

#pragma mark - private
//yes:可以弹出搜索视图
- (BOOL)isJumpToSearchV{
    UIViewController *curVc = [self getCurrentVC];
    if ([curVc isKindOfClass:[LoginContrl class]] ||[curVc isKindOfClass:[RegisterContrl class]] || [curVc isKindOfClass:[Goto_LoginContrl class]]||[curVc isKindOfClass:[Bind_PhoneContrl class]]||[curVc isKindOfClass:[DetailWebContrl class]] ||[curVc isKindOfClass:[ForeGetPwdcontrl class]] || [curVc isKindOfClass:[NewPeo_shareContrl class]]) { //
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
@end
