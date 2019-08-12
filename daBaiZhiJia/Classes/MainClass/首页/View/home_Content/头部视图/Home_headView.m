//
//  Home_headView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/26.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_headView.h"
#import "DetailWebContrl.h"
#import "HomePage_Model.h"
#import "MP_ZG_Const.h"
#import "PageViewController.h"
#import "Home_SecHasCatContrl.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "NewPeo_shareContrl.h"
#import "Home_Com_Group_Recom.h"
#import "GoodDetailContrl.h"


@interface Home_headView ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *banner;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Lead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Trail;

@property (weak, nonatomic) IBOutlet UIView *line;

@end
@implementation Home_headView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    CGFloat gap = (SCREEN_WIDTH - 42*5 - 15*2) / 4;
    self.view2Lead.constant = gap;
    self.view4Trail.constant = gap;
    [self addSubview:self.myScroview];
}

- (void)setBannerArr:(NSMutableArray *)bannerArr{
    _bannerArr = bannerArr;
    NSMutableArray *banImageArr = [NSMutableArray array];
    for (HomePage_bg_bannernfo*info in bannerArr) {
        [banImageArr addObject:info.img];
    }
    self.myScroview.imageURLStringsGroup = banImageArr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.myScroview.frame = self.banner.frame;
    self.height = self.line.bottom;
        //NSLog(@"myScroview.frame=@",NSStringFromCGRect( self.myScroview.frame));
       // NSLog(@"headHeight =%.f",self.height);
}


- (IBAction)action:(UIButton *)sender {
    NSLog(@"tag =%zd",sender.tag);
    NSInteger tag = sender.tag;
    PageViewController *page = (PageViewController*)self.viewController;
    SecHasCatType  type = SecHasCatType_Nine ;
    NSString *secTitle = @"";
    
    NSLog(@"currentTitle %@",sender.currentTitle);
    if (tag==200) {
        type = SecHasCatType_Nine;
        secTitle = @"9.9包邮";
    }else if (tag==201){
       type = SecHasCatType_Brand;
       secTitle = @"品牌精选";
    }else if (tag==202){
        type = SecHasCatType_JHS;
        secTitle = @"聚划算";
    }else if (tag==203){
        type = SecHasCatType_HTG;
        secTitle = @"海淘购";
    }else if (tag==204){
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:self.tmcs title:@"天猫超市" para:nil];
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }else if (tag==205){
        type = SecHasCatType_BigQuan;
        secTitle = @"大额券";
    }else if (tag==206){
        page.tabBarContrl.selectedIndex = 1;
        return;
    }else if (tag==207){
        NewPeo_shareContrl *share = [NewPeo_shareContrl new];
        [page.naviContrl pushViewController:share animated:YES];
        return;
    }else if (tag==208){
        Home_Com_Group_Recom *recom = [Home_Com_Group_Recom new];
           [page.naviContrl pushViewController:recom animated:YES];
        return;
    }else if (tag==209){
        DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:self.tmgj title:@"天猫国际" para:nil];
        [page.naviContrl pushViewController:detailWeb animated:YES];
        return;
    }
    
   // DetailWebContrl *detailWeb = [[DetailWebContrl alloc] initWithUrl:url title:sender.currentTitle para:nil];
    Home_SecHasCatContrl *secCat = [[Home_SecHasCatContrl alloc] initWithType:type title:secTitle];
    [page.naviContrl pushViewController:secCat animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    HomePage_bg_bannernfo*info = self.bannerArr[index];
    if ([NSString stringIsNullOrEmptry:info.url].length>0) {
        [self handleBannerDetailWithType:info.url_type info:info];
    }
}

- (void)handleBannerDetailWithType:(NSInteger)type info:(HomePage_bg_bannernfo*)info{
      PageViewController *page = (PageViewController*)self.viewController;
    if (type ==1) {
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.url];
        [page.naviContrl pushViewController:detail animated:YES];
    }else if (type ==2||type ==3){
        DetailWebContrl *detailweb = [[DetailWebContrl alloc] initWithUrl:[NSString stringWithFormat:@"%@&token=%@",info.url,ToKen] title:@"" para:nil];
        [page.naviContrl pushViewController:detailweb animated:YES];
    }else if (type==4){
         [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:info.url navi:page.naviContrl];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    //NSLog(@"");
    NSDictionary *info = @{@"index":@(index)};
    [[NSNotificationCenter defaultCenter] postNotificationName:Home_pageScro_ChangeBgNoti object:nil userInfo:info];
}

#pragma mark - getter
- (SDCycleScrollView *)myScroview{
    if (!_myScroview) {
        _myScroview = [SDCycleScrollView cycleScrollViewWithFrame:self.banner.frame delegate:self placeholderImage:nil];
        _myScroview.currentPageDotColor = [UIColor whiteColor];
        _myScroview.pageDotColor = RGBColor(51, 51, 51);
        _myScroview.autoScrollTimeInterval = 3;
        _myScroview.backgroundColor = UIColor.clearColor;
        ViewBorderRadius(_myScroview, 10, UIColor.clearColor);
          // NSLog(@"_myScroview1.frame = %@",NSStringFromCGRect( _myScroview.frame));
    }
    return _myScroview;
}

@end
