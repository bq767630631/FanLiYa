//
//  Home_headMenuFirst.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_headMenuFirst.h"

#import "PageViewController.h"
#import "Home_SecHasCatContrl.h"
#import "NewPeo_shareContrl.h"
#import "Home_Com_Group_Recom.h"
#import "GoodDetailContrl.h"
#import "NewPeople_EnjoyContrl.h"
#import "DetailWebContrl.h"
#import "PingDuoduoHomeContrl.h"
#import "Home_Com_Group_Recom.h"
#import "ZbySecContrl.h"
#import "LimitSale_SecContrl.h"
#import "Brand_Showcontrl.h"
#import "ContactKefuContrl.h"
#import "MyCollecTionContrl.h"
#import "LoginContrl.h"
#import "DBZJ_CommunityContrl.h"
#import "MPZG_NavigationContrl.h"

@interface Home_headMenuFirst ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Lead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Trail;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *lable4;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *lable5;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UILabel *lable6;

@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UILabel *lable7;

@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UILabel *lable8;

@property (weak, nonatomic) IBOutlet UIImageView *image9;
@property (weak, nonatomic) IBOutlet UILabel *lable9;

@property (weak, nonatomic) IBOutlet UIImageView *image10;
@property (weak, nonatomic) IBOutlet UILabel *lable10;


@property (nonatomic, strong) MenuSceneceInfo *info1;
@property (nonatomic, strong) MenuSceneceInfo *info2;
@property (nonatomic, strong) MenuSceneceInfo *info3;
@property (nonatomic, strong) MenuSceneceInfo *info4;
@property (nonatomic, strong) MenuSceneceInfo *info5;
@property (nonatomic, strong) MenuSceneceInfo *info6;
@property (nonatomic, strong) MenuSceneceInfo *info7;
@property (nonatomic, strong) MenuSceneceInfo *info8;
@property (nonatomic, strong) MenuSceneceInfo *info9;
@property (nonatomic, strong) MenuSceneceInfo *info10;

@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, copy)  NSString *cur_time_;
@property (nonatomic, assign) NSInteger  cur_index;
@end
@implementation Home_headMenuFirst
- (void)awakeFromNib{
    [super awakeFromNib];
    CGFloat gap = (SCREEN_WIDTH - 42*5 - 15*2) / 4;
    self.view2Lead.constant = gap;
    self.view4Trail.constant = gap;
}

//处理限时抢购
- (void)setInfoWith:(NSMutableArray *)timeArr goodArr:(NSMutableArray *)goodArr{
    self.timeArr = timeArr;
    for (int  i = 0; i < timeArr.count; i ++) {
        HomePage_FlashSaleInfo *info  = timeArr[i];
        if ([info.status isEqualToString:@"疯抢中"]) {
            self.cur_time_ = info.time_;
            self.cur_index = i;
            break;
        }
    }
}

- (void)setFirstList:(NSMutableArray *)firstList{
    _firstList = firstList;
    for (MenuSceneceInfo *info in firstList) {
        if (info.sort ==1||info.sort ==11) {
            self.info1 = info;
            [self handleImageV:self.image1 lable:self.lable1 info:info];
        }else if (info.sort==2||info.sort ==12){
             self.info2 = info;
             [self handleImageV:self.image2 lable:self.lable2 info:info];
        }else if (info.sort==3||info.sort ==13){
            self.info3 = info;
            [self handleImageV:self.image3 lable:self.lable3 info:info];
        }else if (info.sort==4||info.sort ==14){
             self.info4 = info;
            [self handleImageV:self.image4 lable:self.lable4 info:info];
        }else if (info.sort==5||info.sort ==15){
             self.info5 = info;
            [self handleImageV:self.image5 lable:self.lable5 info:info];
        }else if (info.sort==6||info.sort ==16){
             self.info6 = info;
            [self handleImageV:self.image6 lable:self.lable6 info:info];
        }else if (info.sort==7||info.sort ==17){
             self.info7 = info;
            [self handleImageV:self.image7 lable:self.lable7 info:info];
        }else if (info.sort==8||info.sort ==18){
             self.info8 = info;
            [self handleImageV:self.image8 lable:self.lable8 info:info];
        }else if (info.sort==9||info.sort ==19){
             self.info9 = info;
            [self handleImageV:self.image9 lable:self.lable9 info:info];
        }else if (info.sort==10||info.sort ==20){
             self.info10 = info;
            [self handleImageV:self.image10 lable:self.lable10 info:info];
        }
    }
    
}

- (void)handleImageV:(UIImageView*)imageV  lable:(UILabel*)lable info:(MenuSceneceInfo*)info{
    [imageV setDefultPlaceholderWithFullPath:info.imageUrl];
    lable.text = info.title;
}

- (IBAction)clickAction:(UIButton *)sender {
    NSLog(@"%zd",sender.tag);
    NSInteger tag = sender.tag;
    MenuSceneceInfo *info = nil;
    if (tag==1) {
        info = self.info1;
    }else if (tag==2){
        info = self.info2;
    }else if (tag==3){
        info = self.info3;
    }else if (tag==4){
        info = self.info4;
    }else if (tag==5){
        info = self.info5;
    }else if (tag==6){
        info = self.info6;
    }else if (tag==7){
        info = self.info7;
    }else if (tag==8){
        info = self.info8;
    }else if (tag==9){
        info = self.info9;
    }else if (tag==10){
        info = self.info10;
    }
    if (info) {
         [self handleJumpWithInfo:info];
    }
}

- (void)handleJumpWithInfo:(MenuSceneceInfo *)info {
     PageViewController *page = (PageViewController*)self.viewController;
    UIViewController *pushvc = nil;
    
    if ([info.id_ isEqualToString:@"pdd_1"]) { //拼多多
        PingDuoduoHomeContrl *vc = [PingDuoduoHomeContrl new];
        vc.pt = FLYPT_Type_Pdd;
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"jd_1"]){ //京东
        PingDuoduoHomeContrl *vc = [PingDuoduoHomeContrl new];
        vc.pt = FLYPT_Type_JD;
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_2"]){ //今日疯抢
        page.tabBarContrl.selectedIndex = 1;
        return;
    }else if ([info.id_ isEqualToString:@"app_3"]){ //社区
        page.tabBarContrl.selectedIndex = 3;
        return;
    }else if ([info.id_ isEqualToString:@"app_4"]){ //9.9包邮
         Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_Nine title:@"9.9包邮"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_5"]){ //高佣推荐
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_GaoYong title:@"高佣推荐"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_6"]){ //新人专享
        NewPeo_shareContrl *vc = [NewPeo_shareContrl new];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_7"]){ //邀请好友
        NewPeople_EnjoyContrl *vc = [NewPeople_EnjoyContrl new];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_8"]){ //品牌精选
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_Brand title:@"品牌精选"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_9"]){ //母婴专区
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_MuYing title:@"母婴专区"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_10"]){ //特惠专区
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_Tehui title:@"特惠专区"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_11"]){ //聚划算
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_JHS title:@"聚划算"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_12"]){ //海淘抢
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_HTG title:@"海淘抢"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_13"]){ //大额券
        Home_SecHasCatContrl *vc = [[Home_SecHasCatContrl alloc] initWithType:SecHasCatType_BigQuan title:@"大额券"];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_14"]){ //社群推荐
        Home_Com_Group_Recom *vc = [Home_Com_Group_Recom new];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_15"]){ //天猫国际
        DetailWebContrl *vc = [[DetailWebContrl alloc] initWithUrl:self.tmgj title:@"天猫国际" para:nil];
        vc.isFromTaoBao = YES;
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_16"]){ //天猫超市
        DetailWebContrl *vc = [[DetailWebContrl alloc] initWithUrl:self.tmcs title:@"天猫超市" para:nil];
        vc.isFromTaoBao = YES;
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_17"]){ //新手教程
        NSString *url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
        DetailWebContrl *vc = [[DetailWebContrl alloc] initWithUrl:url title:@"新手教程" para:nil];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_18"]){ //素材专区
        page.tabBarContrl.selectedIndex = 3;
       MPZG_NavigationContrl *nav = page.tabBarContrl.viewControllers[3];
        NSLog(@"%@",nav.viewControllers);
        DBZJ_CommunityContrl *vc = nav.viewControllers.firstObject;
        vc.jumpToSucai = YES;
        return;
    }else if ([info.id_ isEqualToString:@"app_19"]){ //赚钱鸭
        page.tabBarContrl.selectedIndex = 2;
        return;
    }else if ([info.id_ isEqualToString:@"app_23"]){ //直播鸭列表
       ZbySecContrl *vc = [ZbySecContrl new];
          pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_25"]){ //限时抢购
        LimitSale_SecContrl *vc = [[LimitSale_SecContrl alloc] initWithTime_:self.cur_time_ timeArr:self.timeArr index:self.cur_index];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_26"]){ //品牌专区列表
        Brand_Showcontrl *vc = [Brand_Showcontrl new];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_28"]){ //联系客服
        ContactKefuContrl *vc = [ContactKefuContrl new];
        pushvc = vc;
    }else if ([info.id_ isEqualToString:@"app_29"]){ //个人中心
        page.tabBarContrl.selectedIndex = 4;
        return;
    }else if ([info.id_ isEqualToString:@"app_30"]){ //我的收藏
        if ([self judgeisLogin]) {
            MyCollecTionContrl *vc = [MyCollecTionContrl new];
              pushvc = vc;
        }
    }
    
    
    if (pushvc) {
         [page.naviContrl pushViewController:pushvc animated:YES];
    }
    
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0&&token.length >0) {
        return YES;
    }else{
         PageViewController *page = (PageViewController*)self.viewController;
        [page.naviContrl pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
    
}
@end
