//
//  HandelTaoBaoTradeManager.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/5.
//  Copyright © 2019 包强. All rights reserved.
//

#import "HandelTaoBaoTradeManager.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
@implementation HandelTaoBaoTradeManager


+ (void)openTaoBaoAndTraWithUrl:(NSString*)url navi:(UINavigationController*)navi{
  
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    //showParam.backUrl = @"tbopen27546131://";
    showParam.isNeedPush = YES;
//    [[AlibcTradeSDK sharedInstance].tradeService show:navi page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//        NSLog(@"result %@",result);
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//        NSLog(@"error %@", error);
//    }];
    
    [[AlibcTradeSDK sharedInstance].tradeService openByUrl:url identity:@"trade" webView:nil parentController:navi showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
        NSLog(@"result %@",result);
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}

@end
