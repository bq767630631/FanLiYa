//
//  Home_headMenuFirst.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_headMenuSec.h"

#import "PageViewController.h"
#import "Home_SecHasCatContrl.h"
#import "NewPeo_shareContrl.h"
#import "Home_Com_Group_Recom.h"
#import "GoodDetailContrl.h"
#import "NewPeople_EnjoyContrl.h"
#import "DetailWebContrl.h"

@interface Home_headMenuSec ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Lead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Trail;
@end

@implementation Home_headMenuSec
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
    SecHasCatType  type = SecHasCatType_Nine;
    NSString *secTitle = @"";
    if (tag==200) {
        type = SecHasCatType_JHS;
        secTitle = @"聚划算";
    }else if (tag==201){
        type = SecHasCatType_HTG;
        secTitle = @"海淘购";
    }else if (tag==202){
        type = SecHasCatType_BigQuan;
        secTitle = @"大额券";
    }else if (tag==203){
        Home_Com_Group_Recom *recom = [Home_Com_Group_Recom new];
        [page.naviContrl pushViewController:recom animated:YES];
        return;
    }else if (tag==204){
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:self.tmgj title:@"天猫国际" para:nil];
         detailWeb.isFromTaoBao = YES;
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }else if (tag==205){
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:self.tmcs title:@"天猫超市" para:nil];
        detailWeb.isFromTaoBao = YES;
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }else if (tag==206){
        //to do
        NSString *url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:url title:@"新手教程" para:nil];
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }else if (tag==207){
          NSString *url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:url title:@"新手教程" para:nil];
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }
    Home_SecHasCatContrl *secCat = [[Home_SecHasCatContrl alloc] initWithType:type title:secTitle];
    [page.naviContrl pushViewController:secCat animated:YES];
}


@end
