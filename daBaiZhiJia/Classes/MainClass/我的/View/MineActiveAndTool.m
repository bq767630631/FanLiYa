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
#import "DBZJ_FeedBack.h"
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
    }else if (tag == 9) {
       vc = [[MyCollecTionContrl alloc] init];
    } else if (tag == 10) {
        vc = [[MyCombatContrl alloc] init];
    }else if (tag ==5){
           NSString *url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"新手教程" para:nil];
    }else if (tag==2){
        NSLog(@"地推素材");
  NSString *url = [NSString stringWithFormat:@"%@/commander/groundPush.html?token=%@",BASE_WEB_URL,ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"地推素材" para:nil];
    }else if (tag==4){
        if (Level !=3) {
            self.viewController.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
            self.viewController.navigationController.tabBarController.selectedIndex = 2;
            [self.viewController.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@/commander/headCollege.html?token=%@",BASE_WEB_URL,ToKen];
          vc = [[DetailWebContrl alloc] initWithUrl:url title:@"团长系统" para:nil];
    }else if (tag==6){
        NSString *url = [NSString stringWithFormat:@"%@/joinCommunity.html?token=%@",BASE_WEB_URL,ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"加入社群" para:nil];
    }else if (tag ==7){
        vc = [ContactKefuContrl new];
    }else if (tag==8){
        [YJProgressHUD showMsgWithoutView:@"敬请期待"];
    }else if (tag==3){
        NSLog(@"自定义邀请码");
        NSString *url = [NSString stringWithFormat:@"%@/duck/customInvitationCode.html?token=%@",BASE_WEB_URL,ToKen];
        vc = [[DetailWebContrl alloc] initWithUrl:url title:@"自定义邀请码" para:nil];
    }else if (tag==11){
        if (self.model.openid &&self.model.openid.length>0) {
             [YJProgressHUD showMsgWithoutView:@"您已经绑定过微信了"];
            return;
        }
        [self bindWeiXin];
    }else if (tag==12){
        vc = [DBZJ_FeedBack new];
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
