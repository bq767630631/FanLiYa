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


@interface Home_headMenuFirst ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Lead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Trail;
@end
@implementation Home_headMenuFirst
- (void)awakeFromNib{
    [super awakeFromNib];
    CGFloat gap = (SCREEN_WIDTH - 42*5 - 15*2) / 4;
    self.view2Lead.constant = gap;
    self.view4Trail.constant = gap;
}


- (IBAction)clickAction:(UIButton *)sender {
    NSLog(@"%zd",sender.tag);
    NSInteger tag = sender.tag;
    PageViewController *page = (PageViewController*)self.viewController;
    SecHasCatType  type = SecHasCatType_Nine ;
    NSString *secTitle = @"";
    if (tag==200) {
        type = SecHasCatType_Nine;
        secTitle = @"9.9包邮";
    }else if (tag==201){
        page.tabBarContrl.selectedIndex = 1;
        return;
    }else if (tag==202){
        type = SecHasCatType_GaoYong;
        secTitle = @"高佣推荐";
    }else if (tag==203){
        NewPeo_shareContrl *share = [NewPeo_shareContrl new];
        [page.naviContrl pushViewController:share animated:YES];
        return;
    }else if (tag==204){
        [page.naviContrl pushViewController:[NewPeople_EnjoyContrl new] animated:YES];
        return;
    }else if (tag==205){
        type = SecHasCatType_Brand;
        secTitle = @"品牌精选";
    }else if (tag==206){
        type = SecHasCatType_MuYing;
        secTitle = @"母婴专区";
    }else if (tag==207){
        type = SecHasCatType_Tehui;
        secTitle = @"特惠专区";
    }else if (tag==208){
          PingDuoduoHomeContrl *pdd =  [PingDuoduoHomeContrl new];
          pdd.pt = FLYPT_Type_Pdd;
          [page.naviContrl pushViewController:pdd animated:YES];
        return;
    }else if (tag==209){
        PingDuoduoHomeContrl *jd = [PingDuoduoHomeContrl new];
        jd.pt = FLYPT_Type_JD;
        [page.naviContrl pushViewController:jd animated:YES];
        return;
    }
    
    Home_SecHasCatContrl *secCat = [[Home_SecHasCatContrl alloc] initWithType:type title:secTitle];
    [page.naviContrl pushViewController:secCat animated:YES];
}


@end
