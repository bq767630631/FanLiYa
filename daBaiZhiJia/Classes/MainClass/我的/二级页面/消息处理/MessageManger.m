//
//  MessageManger.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/7/2.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MessageManger.h"
#import "MPZG_TabBarContrl.h"
#import "GoodDetailContrl.h"
#import "DBZJ_MineContrl.h"
#import "NewPeo_shareContrl.h"
#import "DetailWebContrl.h"
#import "PageViewController.h"


@implementation MessageManger

+ (instancetype)shareMessage{
    static  MessageManger *msg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msg = [MessageManger new];
    });
    return msg;
}

/*{
    scene = 2;         仅APP原生场景有效 1、默认APP（首页） 2、商品详情 3、个人中心 4、新人专享
    txt = 587347332670;    具体值入商品详情sku、或者网址URL
    type = 1;        1、默认APP原生场景 2、webview打开H5网址
}*/

+ (void)handleMessageWithInfo:(NSDictionary *)dict{
    NSInteger type = [dict[@"type"] integerValue];
    NSInteger scene = [dict[@"scene"] integerValue];
    NSInteger pt = 0;
    if (![dict[@"pt"] isKindOfClass:[NSNull class]]) {
        pt = [dict[@"pt"] integerValue];
    }
    NSString * txt = dict[@"txt"] ;
     NSLog(@"type =%zd scene=%zd  txt =%@",type,scene,txt);
     UIViewController *rootVc  =  [UIApplication sharedApplication].keyWindow.rootViewController;
      UIViewController *cur_vc =  [self getCurrentVC];
    NSLog(@"rootVc =%@  cur_vc =%@",rootVc,cur_vc);
    NSLog(@"cur_vc.navi =%@",cur_vc.navigationController);
    
    if (type ==1) {
        if ([rootVc isKindOfClass:[MPZG_TabBarContrl class]]) {
            UINavigationController *navi = cur_vc.navigationController;
            
            if ([cur_vc isKindOfClass:[PageViewController class]]) {
                PageViewController *page = (PageViewController*)cur_vc;
                navi = page.naviContrl;
            }
            if (scene ==1) {
                NSLog(@"首页");
                cur_vc.tabBarController.hidesBottomBarWhenPushed = NO;
                cur_vc.tabBarController.selectedIndex = 0;
                [navi popToRootViewControllerAnimated:YES];
            }else if (scene ==2){
                GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:txt];
                detail.pt = pt;
                [navi pushViewController:detail animated:YES];
                NSLog(@"商品详情");
            }else if (scene ==3){
                cur_vc.tabBarController.hidesBottomBarWhenPushed = NO;
                cur_vc.tabBarController.selectedIndex = 4;
                [navi popToRootViewControllerAnimated:YES];
                NSLog(@"个人中心");
            }else if (scene ==4){
                NSLog(@"新人专享");
                NewPeo_shareContrl *detail = [[NewPeo_shareContrl alloc] init];
                [navi pushViewController:detail animated:YES];
            }
        }
    }else{
     
        txt = [NSString stringWithFormat:@"%@&token=%@",txt,ToKen];
           NSLog(@"H5页面 =%@",txt);
          UINavigationController *navi = cur_vc.navigationController;
        if ([cur_vc isKindOfClass:[PageViewController class]]) {
            PageViewController *page = (PageViewController*)cur_vc;
            navi = page.naviContrl;
        }
        DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:txt title:@"" para:nil];
        [navi pushViewController:web animated:YES];
    }
}



@end
