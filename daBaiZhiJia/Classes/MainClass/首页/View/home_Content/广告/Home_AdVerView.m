//
//  Home_AdVerView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/12.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_AdVerView.h"
#import "SDCycleScrollView.h"
#import "SPMarqueeView.h"
#import "HomePage_Model.h"
#import "NewPeo_shareContrl.h"
#import "PageViewController.h"
#import "DetailWebContrl.h"
#import "Home_horseRacelpCell.h"
#import "ZKCycleScrollView.h"
#import "GoodDetailContrl.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>


@interface Home_AdVerView ()<SDCycleScrollViewDelegate,ZKCycleScrollViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *boBao;

@property (weak, nonatomic) IBOutlet UILabel *boBaoContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peoAspect;//新人专享
@property (weak, nonatomic) IBOutlet UIView *nePeoShareV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PeoTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peoBottom;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIImageView *pingPView1;
@property (weak, nonatomic) IBOutlet UIImageView *pingPView2;
@property (weak, nonatomic) IBOutlet UIImageView *pingPView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adv1top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adv1Aspect;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adv3Aspect;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adv3Top;

@property (weak, nonatomic) IBOutlet UIView *ppView;//品牌V

@property (nonatomic, strong) SDCycleScrollView*myScroview; //代码创建的banber

@property (nonatomic, strong) ZKCycleScrollView*horse_raceV; //代码创建的跑马灯
@property (nonatomic, strong) NSMutableArray *horseArr;
@property (nonatomic, strong) SPMarqueeView*paoMaDeng;

@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) HomePage_bg_bannernfo*info_left;
@property (nonatomic, strong) HomePage_bg_bannernfo*info_right;
@property (nonatomic, strong) HomePage_bg_bannernfo*info_bottom;
@end

static NSString *kTextCellId = @"kTextCellId";

@implementation Home_AdVerView

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.boBao, 3.f, UIColor.clearColor);
    [self addSubview:self.myScroview];
    [self addSubview:self.horse_raceV];
    
}

- (void)setBroadCastInfoWith:(BOOL)isShowNew strArr:(NSMutableArray *)strAtt{
    self.horseArr = strAtt;
    [self.horse_raceV reloadData];

    if (!isShowNew) {
        self.peoAspect.constant =  172/0.1;
        self.PeoTop.constant = 0.1f;
        self.peoBottom.constant = 0.1f;
    }
    [self layoutIfNeeded];
}

- (void)setAdvInfoWithArr:(NSMutableArray *)arr{
    NSMutableArray *swipbannerArr = @[].mutableCopy;
    BOOL isHaveSec = NO;//是否有第二种广告
    BOOL isHaveThir = NO;
    BOOL isHaveForth = NO;
    for (HomePage_bg_bannernfo*info in arr) {
        if ([info.type isEqualToString:@"1"]) {
            [swipbannerArr addObject:info.img];
            [self.bannerArr addObject:info];
        }
        
        if ([info.type isEqualToString:@"2"]) {
            isHaveSec = YES;
            [self.pingPView1 setDefultPlaceholderWithFullPath:info.img];
            self.info_left = info;
        }
        if ([info.type isEqualToString:@"3"]) {
            isHaveThir = YES;
            [self.pingPView2 setDefultPlaceholderWithFullPath:info.img];
            self.info_right = info;
        }
        if ([info.type isEqualToString:@"4"]) {
            isHaveForth = YES;
            [self.pingPView3 setDefultPlaceholderWithFullPath:info.img];
            self.info_bottom = info;
        }
    }
    self.myScroview.imageURLStringsGroup = swipbannerArr;
    
    if (!isHaveSec || !isHaveThir) {
        self.adv1top.constant = 0;
        self.adv1Aspect.constant = 172/0.1;
    }
    if (!isHaveForth) {
        self.adv3Top.constant = 0;
        self.adv3Aspect.constant = 355/0.1;
    }
     [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.myScroview.frame = self.bannerView.frame;
    self.ppView.top = self.bannerView.bottom;
 
    if (Is_Show_Info) {
           self.height = self.ppView.bottom;
           self.hidden = NO;
    }else{
           self.height = 0.f;
           self.hidden = YES;
    }
}

#pragma mark - action
- (IBAction)neopleAction:(UITapGestureRecognizer *)sender {
    PageViewController *page = (PageViewController*)self.viewController;
    [page.naviContrl pushViewController:[NewPeo_shareContrl new] animated:YES];
}


- (IBAction)flyClassAction:(UITapGestureRecognizer *)sender {
    NSString*url =  [NSString stringWithFormat:@"%@%@?token=%@",BASE_WEB_URL,@"businessSchool.html",ToKen];
      DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:url title:@"" para:nil];
      PageViewController *page = (PageViewController*)self.viewController;
      [page.naviContrl pushViewController:web animated:YES];
}

- (IBAction)adv1click:(UITapGestureRecognizer *)sender {
    if ([NSString stringIsNullOrEmptry:self.info_left.url].length >0) {
        [self handleBannerDetailWithType:self.info_left.url_type info:self.info_left];
    }
}

- (IBAction)adv2Click:(UITapGestureRecognizer *)sender {
    if ([NSString stringIsNullOrEmptry:self.info_right.url].length >0) {
        [self handleBannerDetailWithType:self.info_right.url_type info:self.info_right];
    }
}

- (IBAction)adv3click:(UITapGestureRecognizer *)sender {
    if ([NSString stringIsNullOrEmptry:self.info_bottom.url].length >0){
        [self handleBannerDetailWithType:self.info_bottom.url_type info:self.info_bottom];
    }
}

#pragma mark - 跑马灯的代理 ZKCycleScrollViewDataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView{
    return self.horseArr.count;
}
- (UICollectionViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index{
    Home_horseRacelpCell *cusCell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kTextCellId forIndex:index];
    HomePage_BroadCastInfo *info = self.horseArr[index];
        [cusCell setModel:info];
    return cusCell;
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
        HomePage_bg_bannernfo*info = self.bannerArr[index];
    if ([NSString stringIsNullOrEmptry:info.url].length >0) {
        [self handleBannerDetailWithType:info.url_type info:info];
    }
}

#pragma mark - private
- (void)handleBannerDetailWithType:(NSInteger)type info:(HomePage_bg_bannernfo*)info{
    PageViewController *page = (PageViewController*)self.viewController;
    if (type ==1) {
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.url];
        detail.pt = info.pt;
        [page.naviContrl pushViewController:detail animated:YES];
    }else if (type ==2||type ==3){
        DetailWebContrl *detailweb = [[DetailWebContrl alloc] initWithUrl:[NSString stringWithFormat:@"%@&token=%@",info.url,ToKen] title:@"" para:nil];
        [page.naviContrl pushViewController:detailweb animated:YES];
    }else if (type==4){
        if (info.pt==FLYPT_Type_TM ||info.pt==FLYPT_Type_TB) {
            [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:info.url navi:page.naviContrl];
        }else if (info.pt==FLYPT_Type_Pdd){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info.url]];
        }else if (info.pt==FLYPT_Type_JD){
            //todo
        }
    }
}

#pragma mark - getter
- (SDCycleScrollView *)myScroview{
    if (!_myScroview) {
        _myScroview = [SDCycleScrollView cycleScrollViewWithFrame:self.bannerView.frame delegate:self placeholderImage:nil];
        _myScroview.currentPageDotColor = [UIColor whiteColor];
        _myScroview.pageDotColor = RGBColor(51, 51, 51);
        _myScroview.autoScrollTimeInterval = 3.f;
        ViewBorderRadius(_myScroview, 10,  UIColor.clearColor);
        //_myScroview.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
       // NSLog(@"_myScroview1.frame = %@",NSStringFromCGRect( _myScroview.frame));
    }
    return _myScroview;
}

- (ZKCycleScrollView *)horse_raceV{
    if (!_horse_raceV) {
        _horse_raceV = [[ZKCycleScrollView alloc]initWithFrame:self.boBaoContent.frame];
       _horse_raceV.dataSource = self;
        _horse_raceV.hidesPageControl = YES;
        _horse_raceV.scrollDirection = ZKScrollDirectionVertical;
        [_horse_raceV registerCellNib:[UINib nibWithNibName:@"Home_horseRacelpCell" bundle:nil] forCellWithReuseIdentifier:kTextCellId];
    }
    return _horse_raceV;
}




- (NSMutableArray*)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

@end
