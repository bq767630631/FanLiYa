//
//  MineActiveAndTool.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/5/10.
//  Copyright © 2019 包强. All rights reserved.
//

#import "MineActiveAndTool.h"
#import "MyCollecTionContrl.h"
#import "DetailWebContrl.h"
#import "UIImageView+WebCache.h"
#import "ShareCoffeeContrl.h"
#import "NewPeople_EnjoyContrl.h"
#import "MyCombatContrl.h"
#import "PrersonInfoModel.h"
#import "WXApi.h"
#import "ContactKefuContrl.h"

@interface MineActiveAndTool ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lb1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *lb3;

@property (weak, nonatomic) IBOutlet UIImageView *imag4;
@property (weak, nonatomic) IBOutlet UILabel *lb4;


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2Lead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2Train;

@end
@implementation MineActiveAndTool

- (void)awakeFromNib{
    [super awakeFromNib];
  
     ViewBorderRadius(self, 5, UIColor.whiteColor);
}


//- (void)setIsTool:(BOOL)isTool{
//
//     self.btn3.tag =  !isTool ? 13:17;
//     self.btn4.tag =  !isTool ? 14:18;
//}

//- (IBAction)action15:(UIButton *)sender {
//      UIViewController *vc = nil;
//    if (sender.tag ==11) {
//        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_WEB_URL,@"myProfit.html"];
//        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"我的收益" para:@{@"token":ToKen}];
//    }else{
//        NSLog(@"体现");
//    }
//     [self.viewController.navigationController pushViewController:vc animated:YES];
//}






- (IBAction)action4And8:(UIButton *)sender {
    if (sender.tag ==14) {
        ShareCoffeeContrl *share = [ShareCoffeeContrl new];
        [self.viewController.navigationController pushViewController:share animated:YES];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_WEB_URL,@"helpCenter.html"];
        [self goToDetailView:url title:@"帮助中心" para:nil];
    }
}

#pragma mark - private
- (void)goToDetailView:(NSString *)url title:(NSString *)title para:(NSDictionary*)para{
    UIViewController *vc = [[DetailWebContrl alloc] initWithUrl:url title:title para:para];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action

- (IBAction)TooAction:(UIButton *)sender {
    NSInteger tag  = sender.tag;
    UIViewController *vc = nil;
    NSLog(@"tag =%zd",sender.tag);
    if (tag == 1) {
         vc = [[NewPeople_EnjoyContrl alloc] init];
    }else if (tag == 6) {
       vc = [[MyCollecTionContrl alloc] init];
    } else if (tag == 8) {
        vc = [[MyCombatContrl alloc] init];
    }else if (tag ==5){
//        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_WEB_URL,@"newCourseDetail.html?cid=1"];
           NSString *url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"新手教程" para:nil];
    }else if (tag==2){
        PersonRevenue *info = self.model;
        if (info.openid.length) {
            [YJProgressHUD showMsgWithoutView:@"您已经绑定微信了"];
            return;
        }
        [self bindWeiXin];
    }else if (tag==4){
        if (Level !=3) {
            self.viewController.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.viewController.navigationController.tabBarController.selectedIndex = 2;
            [self.viewController.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@/commander/headCollege.html?token=%@",BASE_WEB_URL,ToKen];
          vc = [[DetailWebContrl alloc] initWithUrl:url title:@"团长系统" para:nil];
    }else if (tag==3){
        NSString *url = [NSString stringWithFormat:@"%@/joinCommunity.html?token=%@",BASE_WEB_URL,ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"加入社群" para:nil];
    }else if (tag ==7){
        vc = [ContactKefuContrl new];
    }
    if (vc){
          [self.viewController.navigationController pushViewController:vc animated:YES];
    }
   
}


#pragma mark - bindWeiXin
- (void)bindWeiXin{
    SendAuthReq *request = [SendAuthReq new];
    request.state  =  [NSString getRandomStr];
    request.scope  = @"snsapi_userinfo";
    BOOL res  = [WXApi sendReq:request];
    NSLog(@"res %d",res);
}
@end
