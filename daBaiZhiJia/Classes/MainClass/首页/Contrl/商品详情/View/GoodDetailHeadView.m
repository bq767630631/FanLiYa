//
//  GoodDetailHeadView.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/17.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailHeadView.h"
#import <WebKit/WebKit.h>
#import "GoodDetailModel.h"
#import "SearchResultCell.h"
#import "GoodDetailContrl.h"
#import "SVProgressHUD.h"
#import "LoginContrl.h"
#import "CreateShareContrl.h"
//#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "GoodDetailCustomCell.h"
#import <AVKit/AVKit.h>
#import "GKPhotoBrowser.h"

#import "GoodDetailTuiJianCell.h"
#import "ZKCycleScrollView.h"
#import "GoToAuth_View.h"
#import "GoodDetailPDDDetailCell.h"
#import "DetailWebContrl.h"
#import <JDSDK/KeplerApiManager.h>

static NSString *collecTioncellId = @"collecTioncellId";
static NSString *tablecellId = @"tablecellId";
static NSString *KbannerId = @"KbannerId";
@interface GoodDetailHeadView ()<ZKCycleScrollViewDelegate,ZKCycleScrollViewDataSource,WKNavigationDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIView *shopView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanHeightCons;//优惠券的高度

@property (weak, nonatomic) IBOutlet UIView *quanView;

@property (nonatomic, strong) ZKCycleScrollView *bannerV;

@property (weak, nonatomic) IBOutlet UILabel *discountLb;

@property (weak, nonatomic) IBOutlet UILabel *yuGuLb;
@property (weak, nonatomic) IBOutlet UILabel *buTieLb;
@property (weak, nonatomic) IBOutlet UILabel *youXiaoQixian;


@property (weak, nonatomic) IBOutlet UIButton *limiteBuyBtn;//立即购买

@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *tuiJianContent;

@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@property (weak, nonatomic) IBOutlet UILabel *shengJiZhuan;

@property (weak, nonatomic) IBOutlet UIButton *shengJizhuanBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shengJiV_H;
@property (weak, nonatomic) IBOutlet UIView *shengJiV;

@property (weak, nonatomic) IBOutlet UILabel *tuiJianLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuiJianLb_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuiJianContent_Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuiJianContent_Top;

@property (weak, nonatomic) IBOutlet UILabel *shoptitle;
@property (weak, nonatomic) IBOutlet UIImageView *shopPt;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeV_H;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collecTion_H;

@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图

@property (weak, nonatomic) IBOutlet UITableView *detailTableV;//拼多多和京东的商品详情

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTableV_H;

@property (nonatomic, strong) NSArray *goodArr;//推荐商品

@property (nonatomic, strong) NSMutableArray *bannerArr;//

@property (nonatomic, strong) NSString *sku;

@property (nonatomic, strong)  GoodDetailInfo *detailInfo;
@property (nonatomic, assign) CGFloat  web_H;
@end
@implementation GoodDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];

    ViewBorderRadius(self.shengJizhuanBtn, self.shengJizhuanBtn.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.tuiJianLb, 2, UIColor.clearColor);
    [self addSubview:self.bannerV];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.scrollEnabled = NO;
    [self.collection registerNib:[UINib nibWithNibName:@"GoodDetailTuiJianCell" bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
    self.collection.collectionViewLayout = self.doubleLayout;
    self.collection.showsHorizontalScrollIndicator = NO;
    
    self.detailTableV.dataSource = self;
    self.detailTableV.delegate = self;
    self.detailTableV.scrollEnabled = NO;
    [self.detailTableV registerNib:[UINib nibWithNibName:@"GoodDetailPDDDetailCell" bundle:nil] forCellReuseIdentifier:tablecellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadAction) name:@"GoodDetailDownLoadNotification" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_webView) {
         [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (void)downLoadAction{
    [GoodDetailModel handleDownloadActionWith:self.bannerArr[self.bannerV.pageIndex]];
}

#pragma mark ------ < KVO > ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
//        NSLog(@"change %@",change);
        self.webView.height = self.webView.scrollView.contentSize.height;
        [self layoutIfNeeded];
        self.height = self.webView.bottom;
        self.heightBlock(self.webView.bottom,NO);
    }
}


- (void)setInfo:(GoodDetailInfo*)detailinfo tuijianArr:(NSMutableArray *)goodArray{
    GoodDetailInfo *info = detailinfo;
    self.detailInfo = detailinfo;
    self.sku = info.sku;
    
    self.title.text = [NSString stringWithFormat:@"      %@",info.title];
    if (info.pt ==FLYPT_Type_TB ||info.pt ==FLYPT_Type_TM) {
        [self addSubview:self.webView];
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.goodArr = goodArray;
        [self.collection reloadData];
        self.detailTableV.hidden = YES;
    }else{
         self.detailTableV.hidden = NO;
        [self.detailTableV reloadData];
        self.detailTableV_H.constant = info.content.count*SCREEN_WIDTH;
        self.collecTion_H.constant = 0;
    }
   
    NSString *imageStr = @"";
    NSString *shopPtImage = @"";
    if (info.pt==1) {
        imageStr = @"icon_zbytianmao";
        shopPtImage = @"img_tianm_detail";
    }else if (info.pt==3){
        imageStr = @"icon_pinduoduo";
        shopPtImage = @"icon_pinduoduo_detail";
    }else if (info.pt==4){
        imageStr = @"img_zbytaobao";
        shopPtImage = @"img_taobao_detail";
    }else if (info.pt==2){
        imageStr = @"icon_jd";
        shopPtImage = @"icon_jd_detail";
    }
    self.pt.image  = ZDBImage(imageStr);
    self.price.attributedText = [self priceWithStr1:@"券后 " str2:@"¥" str3:[NSString stringWithFormat:@"%@  ",info.price] str4:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.shoptitle.text = info.shop_title;
    self.shopPt.image = ZDBImage(shopPtImage);
    
    self.soldNum.text = [NSString stringWithFormat:@"%@件已售",info.sold_num];
    self.yuGuLb.text = info.one_profit;
    self.buTieLb.text = info.two_profit;
    if (info.coupon_start_time) {
         self.youXiaoQixian.text = [NSString stringWithFormat:@"有效期限%@-%@",info.coupon_start_time,info.coupon_end_time];
    }else{
        self.youXiaoQixian.text = @"";
    }
   
   
    if (Level != 3) {//团长的时候不用显示
        self.shengJiV_H.constant = 36;
        self.shengJiZhuan.text = [NSString stringWithFormat:@"升级赚%@元",info.profit_up];
    }else{
        self.shengJiV_H.constant = 0;
        self.shengJiV.hidden = YES;
    }
    
    for (int i = 0; i < info.pics.count; i ++) {
        GoodDetailBannerInfo *banner = [GoodDetailBannerInfo new];
        banner.pic = info.pics[i];
        if (i ==0) {
            banner.videoUrl = info.video;
        }
        [self.bannerArr addObject:banner];
    }
    [self.bannerV reloadData];
    
    if (info.coupon_amount.doubleValue == 0) {//优惠券=0隐藏
        self.quanHeightCons.constant = 0;
        self.limiteBuyBtn.hidden = YES;
        self.quanView.hidden = YES;
    }
    
    self.discountLb.text = [NSString stringWithFormat:@"￥%@",info.coupon_amount];
    self.tuiJianContent.text = info.desc;
    if (info.desc.length == 0) {//没推荐 隐藏
        self.tuiJianLb.hidden = YES;
        self.tuiJianLb_H.constant = 0;
        self.tuiJianContent_Bottom.constant = 0;
        self.tuiJianContent_Top.constant = 0;
    }
  
    if (goodArray.count==0) {
        self.likeView.hidden = YES;
        self.likeV_H.constant = 0;
    }
    
    [self layoutIfNeeded];
    
    if (info.detail) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:info.detail]];
        [self.webView loadRequest:req];
    }
    
    
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.detailInfo.pt == FLYPT_Type_TM ||self.detailInfo.pt == FLYPT_Type_TB) {
        self.webView.top = self.detailV.bottom;
        CGFloat itemH = self.doubleLayout.itemSize.height + 10;
        CGFloat contentH =  0.f;
        if (self.goodArr.count %2 ==0) { //偶数
            contentH += itemH * self.goodArr.count/2;
        }else{//奇数
            contentH += itemH * (self.goodArr.count/2 + 1);
        }
        self.collecTion_H.constant = contentH;
        CGRect frame  = self.collection.frame;
        frame.size.height = contentH;
        self.collection.frame = frame;
        
        self.likeVTop = self.likeView.top - 100;
        self.webTop  = self.detailV.top - 100;
    }else{
        
        self.height = self.detailTableV.bottom;
        self.heightBlock(self.height,NO);
        self.webTop   =  self.detailV.top -100;
    }
    
}

#pragma mark - ZKCycleScrollViewDataSource &ZKCycleScrollViewDelegate
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView{
    return self.bannerArr.count;
}

- (UICollectionViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index{
    GoodDetailCustomCell *cusCell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:KbannerId forIndex:index];
       GoodDetailBannerInfo *banner = self.bannerArr[index];
    [cusCell setInfo:banner];
    return cusCell;
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"pageIndex %zd", cycleScrollView.pageIndex);
     GoodDetailBannerInfo *banner = self.bannerArr[index];
    if (banner.videoUrl.length) { //视频
        NSString *webVideoPath = banner.videoUrl;
        NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
        AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc] init];
        avPlayerVC.player = avPlayer;
        [self.viewController presentViewController:avPlayerVC animated:YES completion:^{
            [avPlayer play];
        }];
    }else{  //图片
        NSMutableArray *photos = [NSMutableArray new];
        
        for ( GoodDetailBannerInfo *info  in self.bannerArr) {
            GKPhoto *photo = [GKPhoto new];
            photo.url = [NSURL URLWithString:info.pic];
            [photos addObject:photo];
        }
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
        browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
        [browser showFromVC:self.viewController];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailTuiJianCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecTioncellId forIndexPath:indexPath];
    info.indexPath = indexPath;
    [cell setInfo:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    detail.pt = info.pt;
    [self.viewController.navigationController pushViewController:detail animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detailInfo.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodDetailPDDDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:tablecellId];
    NSString *url = self.detailInfo.content[indexPath.row];
    [cell.imageV setDefultPlaceholderWithFullPath:url];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIImageView *temp = [UIImageView new];
//     NSString *url = self.detailInfo.content[indexPath.row];
//    [temp sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
    return SCREEN_WIDTH;
}

#pragma mark - action
- (IBAction)zhanKaiAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.iszhankai = sender.selected;
    if (sender.selected) {
       
        NSLog(@"isLoading2 =%d",self.webView.isLoading);
        self.webView.height = self.web_H;
        //self.zhanKaiImage.image = ZDBImage(@"icon_next_downdt");

    }else{
        self.webView.height = 0;
        //self.zhanKaiImage.image =ZDBImage(@"icon_next_detail");
    }
     self.heightBlock(self.webView.bottom, self.iszhankai);
}


- (IBAction)getQuan:(UIButton *)sender {
     NSLog(@"领取优惠券");
    //清空剪贴板
    [UIPasteboard generalPasteboard].string = @"";
    if ([self judgeisLogin]) {
        if (self.detailInfo.pt == FLYPT_Type_Pdd) {//pdd
            
            [GoodDetailModel pddGetYouhuiQuanWithsku:self.detailInfo.sku CallBack:^(NSDictionary *dict) {
                if (dict) {
                    NSString *app = dict[@"app"];//如果没下app,safari自动跳转
                    NSString *iosurl = dict[@"iosurl"];
                   BOOL can =   [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"pinduoduo://"]];
                    if (can) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iosurl]];
                    }else{
                        DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:app title:nil para:nil];
                        [self.viewController.navigationController pushViewController:web animated:YES];
                    }
                }
            }];
            return;
        }else if (self.detailInfo.pt == FLYPT_Type_JD){// jd
            [GoodDetailModel jdGetYouhuiQuanWithsku:self.detailInfo.sku couponUrl:self.detailInfo.couponUrl CallBack:^(NSDictionary *dict) {
                if (dict) {
                     NSString *app = dict[@"app"];
                    [[KeplerApiManager sharedKPService] openKeplerPageWithURL:app userInfo:nil failedCallback:^(NSInteger code, NSString *url) {
                        //422:没有安装jd
                        NSLog(@"%zd",code);
                        NSLog(@"%@",url);
                        if (code==422) {
                            DetailWebContrl *web = [[DetailWebContrl alloc] initWithUrl:app title:nil para:nil];
                            [self.viewController.navigationController pushViewController:web animated:YES];
                        }
                    }];
                }
            }];
            
            return;
        }
        
        
        NSDictionary *dict = @{@"sku":self.sku,@"token":ToKen,@"v":APP_Version};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCoupon") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                if ([url containsString:@"http"]) {
                     [self openTbWithUrl:url];
                }else{
                    [UIPasteboard generalPasteboard].string = url;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"taobao://m.taobao.com/"]];
                }
            }
            
            if (code == UnauthCode) {
                GoToAuth_View *auth = [GoToAuth_View viewFromXib];
                [auth setAuthInfo];
                auth.cur_vc = self.viewController;
                auth.navi_vc = self.viewController.navigationController;
                [auth showInWindowWithBackgoundTapDismissEnable:NO];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showAlertTipsWithError:error];
        }];
    }
}

- (void)openTbWithUrl:(NSString *)url{
     [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
}

- (IBAction)shengJiAction:(UIButton *)sender {
    self.viewController.navigationController.tabBarController.hidesBottomBarWhenPushed = NO;
    self.viewController.navigationController.tabBarController.selectedIndex = 2;
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - private
- (NSMutableAttributedString *)priceWithStr1:(NSString *)str1 str2:(NSString *)str2  str3:(NSString *)str3  str4:(NSString *)str4{
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4]];
    
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str1.length)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(str1.length, str2.length)];
    
    [mutStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
    [mutStr addAttribute:NSForegroundColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
    [mutStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
    [mutStr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
    [mutStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length + str2.length + str3.length, str4.length)];
    return mutStr;
}


- (BOOL)judgeisLogin{
    if (User_ID >0) {
        return YES;
    }else{
        [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

#pragma mark - getter
- (ZKCycleScrollView *)bannerV{
    if (!_bannerV) {
           CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        _bannerV = [[ZKCycleScrollView alloc] initWithFrame:frame];
        _bannerV.delegate = self;
        _bannerV.dataSource = self;
        _bannerV.autoScroll = NO;
         [_bannerV registerCellNib:[UINib nibWithNibName:@"GoodDetailCustomCell" bundle:nil] forCellWithReuseIdentifier:KbannerId];
    }
    return _bannerV;
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //实例化对象
        configuration.userContentController = [WKUserContentController new];
        
        CGRect frame = CGRectMake(0, self.line3.bottom , SCREEN_WIDTH,1000);
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.userInteractionEnabled = NO;
        _webView.navigationDelegate = self;
    }
    return _webView;
}


- (UICollectionViewFlowLayout *)doubleLayout{
    if (!_doubleLayout) {
        _doubleLayout = [[UICollectionViewFlowLayout alloc] init];
        _doubleLayout.minimumLineSpacing = 10;
        _doubleLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        CGFloat itemW = (SCREEN_WIDTH - 30)/2;
        CGFloat itemH = (230.f/173) *itemW;
        _doubleLayout.itemSize = CGSizeMake(itemW, itemH);
    }
    return _doubleLayout;
}

- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
@end
