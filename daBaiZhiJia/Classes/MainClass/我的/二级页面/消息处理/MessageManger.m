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

@implementation MessageManger

/*{
    scene = 2;         仅APP原生场景有效 1、默认APP（首页） 2、商品详情 3、个人中心 4、新人专享
    txt = 587347332670;    具体值入商品详情sku、或者网址URL
    type = 1;        1、默认APP原生场景 2、webview打开H5网址
}*/

+ (void)handleMessageWithInfo:(NSDictionary *)dict{
    NSInteger type = [dict[@"type"] integerValue];
    NSInteger scene = [dict[@"scene"] integerValue];
    NSString * txt = dict[@"txt"] ;
     NSLog(@"type =%zd scene=%zd  txt =%@",type,scene,txt);
     UIViewController *rootVc  =  [UIApplication sharedApplication].keyWindow.rootViewController;
      UIViewController *cur_vc =  [self getCurrentVC];
    NSLog(@"rootVc =%@  cur_vc =%@",rootVc,cur_vc);
    NSLog(@"cur_vc.navi =%@",cur_vc.navigationController);
    if (type ==1) {
        if ([rootVc isKindOfClass:[MPZG_TabBarContrl class]]) {
            UINavigationController *navi = cur_vc.navigationController;
            if (scene ==1) {
                NSLog(@"首页");
                cur_vc.tabBarController.hidesBottomBarWhenPushed = NO;
                cur_vc.tabBarController.selectedIndex = 0;
                [cur_vc.navigationController popToRootViewControllerAnimated:YES];
            }else if (scene ==2){
                GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:txt];
                [navi pushViewController:detail animated:YES];
                NSLog(@"商品详情");
            }else if (scene ==3){
//                tab.selectedIndex = 4;
                cur_vc.tabBarController.hidesBottomBarWhenPushed = NO;
                cur_vc.tabBarController.selectedIndex = 4;
                [cur_vc.navigationController popToRootViewControllerAnimated:YES];
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
        DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:txt title:@"" para:nil];
        [cur_vc.navigationController pushViewController:web animated:YES];
    }
}
@end
