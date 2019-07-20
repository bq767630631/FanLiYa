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
static NSString *collecTioncellId = @"collecTioncellId";
static NSString *KbannerId = @"KbannerId";
@interface GoodDetailHeadView ()<ZKCycleScrollViewDelegate,ZKCycleScrollViewDataSource,WKNavigationDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIImageView *pt;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIView *shopView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quanHeightCons;//优惠券的高度

@property (weak, nonatomic) IBOutlet UIView *quanView;

@property (nonatomic, strong) ZKCycleScrollView *bannerV;

@property (weak, nonatomic) IBOutlet UILabel *discountLb;

@property (weak, nonatomic) IBOutlet UIButton *limiteBuyBtn;//立即购买

@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *tuiJianContent;

@property (weak, nonatomic) IBOutlet UILabel *soldNum;

@property (weak, nonatomic) IBOutlet UILabel *tuiJianLb;

@property (weak, nonatomic) IBOutlet UILabel *shoptitle;
@property (weak, nonatomic) IBOutlet UIImageView *shopPt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *soldNum_W;

@property (weak, nonatomic) IBOutlet UIView *likeView;

@property (nonatomic, strong) UICollectionViewFlowLayout *doubleLayout;//一排两个视图

@property (weak, nonatomic) IBOutlet UIImageView *zhanKaiImage;

@property (nonatomic, strong) NSArray *goodArr;//推荐商品

@property (nonatomic, strong) NSMutableArray *bannerArr;//

@property (nonatomic, strong) NSString *sku;

@property (nonatomic, strong)  GoodDetailInfo *detailInfo;
@property (nonatomic, assign) CGFloat  web_H;
@end
@implementation GoodDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];

    ViewBorderRadius(self.limiteBuyBtn, self.limiteBuyBtn.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.tuiJianLb, 2, UIColor.clearColor);
    ViewBorderRadius(self.soldNum, self.soldNum.height*0.5, RGBColor(195, 152, 77));
    [self addSubview:self.bannerV];
    [self addSubview:self.webView];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerNib:[UINib nibWithNibName:@"GoodDetailTuiJianCell" bundle:nil] forCellWithReuseIdentifier:collecTioncellId];
    self.collection.collectionViewLayout = self.doubleLayout;
    self.collection.showsHorizontalScrollIndicator = NO;
}

- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark ------ < KVO > ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"change %@",change);
    
        self.web_H = self.webView.scrollView.contentSize.height;
        [self layoutIfNeeded];
      
        if (self.iszhankai) {
            self.webView.height = self.web_H;
        }
        self.heightBlock(self.webView.bottom,NO);
        NSLog(@"isLoading %d",self.webView.isLoading);
//          NSLog(@"%d",self.webView.com);
    }
}

- (void)willChangeValueForKey:(NSString *)key{
    NSLog(@"key %@",key);
}

- (void)setInfo:(id)detailinfo tuijianArr:(NSMutableArray *)goodArray{
    GoodDetailInfo *info = detailinfo;
    self.detailInfo = detailinfo;
    self.sku = info.sku;
    
    self.title.text = [NSString stringWithFormat:@"      %@",info.title] ;
    self.pt.image = (info.pt == 1)?ZDBImage(@"icon_zbytianmao"):ZDBImage(@"img_zbytaobao");
    self.price.attributedText = [self priceWithStr1:@"券后 " str2:@"¥" str3:[NSString stringWithFormat:@"%@  ",info.price] str4:[NSString stringWithFormat:@"¥%@",info.market_price]];
    self.shoptitle.text = info.shop_title;
    self.shopPt.image = (info.pt == 1)?ZDBImage(@"img_tianm_detail"):ZDBImage(@"img_taobao_detail");
    
    self.soldNum.text = [NSString stringWithFormat:@"%@件已售",info.sold_num];
    CGFloat wd = [self.soldNum.text textWidthWithFont: self.soldNum.font maxHeight: self.soldNum.height];
    self.soldNum_W.constant = wd + 16*2;
    
    for (int i = 0; i < info.pics.count; i ++) {
        GoodDetailBannerInfo *banner = [GoodDetailBannerInfo new];
        banner.pic = info.pics[i];
        if (i ==0) {
            banner.videoUrl = info.video;
        }
        [self.bannerArr addObject:banner];
    }
    [self.bannerV reloadData];
    
    self.discountLb.text = [NSString stringWithFormat:@"%@",info.coupon_amount];
    self.tuiJianContent.text = info.desc;
    self.goodArr = goodArray;
    [self.collection reloadData];
    
    [self layoutIfNeeded];
    
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:info.detail]];
      [self.webView loadRequest:req];
     self.webView.height = 0.f; //默认0

    if (info.coupon_amount.doubleValue == 0) {//优惠券=0隐藏
        self.quanHeightCons.constant = 0;
        self.limiteBuyBtn.hidden = YES;
    }

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.webView.top = self.line3.bottom;
    self.likeVTop    = self.likeView.top;
}

#pragma mark - WKNavigationDelegate
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成之后调用");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
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
    NSLog(@" indexPath =%@",indexPath);
    SearchResulGoodInfo *info = self.goodArr[indexPath.row];
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:info.sku];
    [self.viewController.navigationController pushViewController:detail animated:YES];
}

#pragma mark - action
- (IBAction)zhanKaiAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.iszhankai = sender.selected;
    if (sender.selected) {
       
        NSLog(@"isLoading2 =%d",self.webView.isLoading);
        self.webView.height = self.web_H;
        self.zhanKaiImage.image = ZDBImage(@"icon_next_downdt");

    }else{
        self.webView.height = 0;
        self.zhanKaiImage.image =ZDBImage(@"icon_next_detail");
    }
     self.heightBlock(self.webView.bottom, self.iszhankai);
}


- (IBAction)getQuan:(UIButton *)sender {
     NSLog(@"领取优惠券");
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.sku,@"token":ToKen};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCoupon") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                [self openTbWithUrl:url];
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
        _doubleLayout.minimumInteritemSpacing = 10;;
        _doubleLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _doubleLayout.itemSize = CGSizeMake(90, 129);
        _doubleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
