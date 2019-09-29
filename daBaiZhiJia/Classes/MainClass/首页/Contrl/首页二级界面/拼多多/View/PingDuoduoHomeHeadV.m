//
//  PingDuoduoHomeHeadV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/9/18.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PingDuoduoHomeHeadV.h"
#import "SDCycleScrollView.h"
#import "PingDuoduoHomeModel.h"
#import "PingDuoduoPageHomecontrl.h"
#import "DetailWebContrl.h"
#import "PDDOperationChannelContrl.h"
#import "PDDHotSaleViewContrl.h"
#import "GoodDetailContrl.h"

@interface PingDuoduoHomeHeadV ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannaerAspect;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *lable2;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *lable4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secbtnLeadCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secBtnTrailCon;

@property (nonatomic, strong) SDCycleScrollView*myScroview; //代码创建的banber

@end
@implementation PingDuoduoHomeHeadV

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.myScroview];
    ViewBorderRadius(self.view1, 7, UIColor.clearColor);
    ViewBorderRadius(self.view2, 7, UIColor.clearColor);
    ViewBorderRadius(self.view3, 7, UIColor.clearColor);
    ViewBorderRadius(self.view4, 7, UIColor.clearColor);
    CGFloat gap = 7.f *SCALE_Normal;
    self.secbtnLeadCon.constant = self.secBtnTrailCon.constant = gap;
    
    CGFloat wd = (SCREEN_WIDTH - 20.f - gap * 3)/4;
    self.btnW.constant = wd;
}

- (void)setBannerArr:(NSMutableArray *)bannerArr{
    _bannerArr = bannerArr;
    NSMutableArray *banImageArr = [NSMutableArray array];
    for (HomePage_bg_bannernfo*info in bannerArr) {
        [banImageArr addObject:info.img];
    }
    self.myScroview.imageURLStringsGroup = banImageArr;
   
    if (bannerArr.count==0) {
        self.bannaerAspect.constant = 355/1;
        self.myScroview.height = 0;
    }else{
        self.bannaerAspect.constant = 355/140;
        CGRect frame = self.myScroview.frame;
        frame.size.height = self.bannerV.height;
        frame.size.width = SCREEN_WIDTH - 20;
        self.myScroview.frame = frame;
    }
     [self layoutIfNeeded];
    self.height  = self.view1.bottom + 10;
}

- (void)setPt:(FLYPT_Type)pt{
    _pt  = pt;
    if (pt == FLYPT_Type_JD) {
        _image1.image = ZDBImage(@"icon_9.9jd");
        _lable1.text = @"9.9专区";
        _image2.image = ZDBImage(@"icon_quan_jd");
        _lable2.text = @"好券商品";
        _image3.image = ZDBImage(@"icon_jiaju_jd");
        _lable3.text = @"居家生活";
        _image4.image = ZDBImage(@"icon_jdPeisong");
        _lable4.text = @"京东配送";
    }
}

- (IBAction)clickAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    NSInteger channel_type = 0;
    NSInteger type = 0;
    NSString *title_str = @"";
    PingDuoduoPageHomecontrl *page = (PingDuoduoPageHomecontrl*)self.viewController;
    if (tag==1) {
        if (self.pt==FLYPT_Type_Pdd) {
            channel_type = 0;
            title_str = @"1.9包邮";
        }else{
            type = 10;
            title_str = @"9.9专区";
        }
       
    }else if (tag==2){
        if (self.pt==FLYPT_Type_Pdd) {
            PDDHotSaleViewContrl *vc  = [PDDHotSaleViewContrl new];
            [page.naviContrl pushViewController:vc animated:YES];
            return;
        }else{
            type = 1;
            title_str = @"好券商品";
        }
       
    }else if (tag==3){
        if (self.pt==FLYPT_Type_Pdd) {
            channel_type = 1;
            title_str = @"今日爆款";
        }else{
            type = 7;
            title_str = @"居家生活";
        }
        
    }else if (tag==4){
        if (self.pt==FLYPT_Type_Pdd) {
            channel_type = 2;
            title_str = @"品牌清仓";
        }else{
            type = 15;
            title_str = @"京东配送";
        }
       
    }
   
    PDDOperationChannelContrl *pdd = [PDDOperationChannelContrl new];
    pdd.channel_type = channel_type;
    pdd.title = title_str;
    pdd.type = type;
    pdd.pt = self.pt;
    [page.naviContrl pushViewController:pdd animated:YES];
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
      PingDuoduoPageHomecontrl *page = (PingDuoduoPageHomecontrl*)self.viewController;
    NSLog(@"%zd",type);
    if (type==1) {//拼多多单品详情
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.url];
        detail.pt = info.pt;
        [page.naviContrl pushViewController:detail animated:YES];
    }else if (type==2){//内部H5页面
        DetailWebContrl *detailweb = [[DetailWebContrl alloc] initWithUrl:[NSString stringWithFormat:@"%@&token=%@",info.url,ToKen] title:@"" para:nil];
        [page.naviContrl pushViewController:detailweb animated:YES];
    }else if (type==3){ //跳转打开拼多多APP指定链接
        BOOL can =   [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pinduoduo://"]];
        if (can) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info.iosurl]];
        }else{
            DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:info.url title:nil para:nil];
            [page.naviContrl pushViewController:web animated:YES];
        }
    }
}

#pragma mark - getter
- (SDCycleScrollView *)myScroview{
    if (!_myScroview) {
        _myScroview = [SDCycleScrollView cycleScrollViewWithFrame:self.bannerV.frame delegate:self placeholderImage:nil];
        _myScroview.currentPageDotColor = [UIColor whiteColor];
        _myScroview.pageDotColor = RGBColor(51, 51, 51);
        _myScroview.autoScrollTimeInterval = 3;
        _myScroview.backgroundColor = UIColor.clearColor;
        ViewBorderRadius(_myScroview, 10, UIColor.clearColor);
    }
    return _myScroview;
}



@end
