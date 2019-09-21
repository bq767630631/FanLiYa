//
//  Home_Com_Group_Cell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/24.
//  Copyright © 2019 包强. All rights reserved.
//

#import "Home_Com_Group_Cell.h"
#import "LoginContrl.h"
#import "GoodDetailContrl.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "HomePage_Model.h"
#import "DBZJ_ComCollectionCell.h"
#import "GKPhotoBrowser.h"
#import <AVKit/AVKit.h>
#import "GoToAuth_View.h"

@interface Home_Com_Group_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) UICollectionViewFlowLayout *threeLayout;//一排两个视图

@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIImageView *pt;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *shareLb;
@property (weak, nonatomic) IBOutlet UILabel *shengJiLb;
@property (weak, nonatomic) IBOutlet UIButton *diccount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowImage;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *gotoBuy;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodContent;

@property (nonatomic, strong)    SearchResulGoodInfo *info;

@end
static NSString *cellid=  @"cellid";

@implementation Home_Com_Group_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    self.yellowImage.constant =  self.yellowImage.constant*SCALE_Normal;
    ViewBorderRadius(self.shareLb, self.shareLb.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengJiLb, self.shengJiLb.height/2, UIColor.clearColor);
    
    self.collection.dataSource = self;
    self.collection.delegate  = self;
    self.collection.collectionViewLayout = self.threeLayout;
    self.collection.scrollEnabled = NO;
    [self.collection registerNib:[UINib nibWithNibName:@"DBZJ_ComCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellid];
    if (IS_iPhone5SE) {
        self.goodContent.constant = 5;
    }
}

- (void)setModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = info;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6.0;
    self.content.attributedText = [[NSMutableAttributedString alloc] initWithString: info.content attributes:@{NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(2)}];
    
    self.minute.text  =[NSString stringWithFormat:@"%@同步",info.time];
    self.soldNum.text = info.sold_num;
    [self.smallImage setDefultPlaceholderWithFullPath:info.pic];
    NSString *imageStr = @"";
    if (info.pt==1) {
        imageStr = @"icon_zbytianmao";
    }else if (info.pt==3){
        imageStr = @"icon_pinduoduo";
    }else if (info.pt==4){
        imageStr = @"img_zbytaobao";
    }else if (info.pt==2){
        imageStr = @"icon_jd";
    }
    self.pt.image  = ZDBImage(imageStr);
    self.title.text = info.title;
    self.soldNum.text = [NSString stringWithFormat:@"%@人购买",info.sold_num];
   
    self.price.attributedText = [self priceStrWithStr1:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:info.market_price];
    [self.diccount setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.shareLb.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    self.shengJiLb.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
    self.gotoBuy.text = @"去\n购\n买";
    
    self.collectionW.constant = info.collection_width;
    self.collectionH.constant = info.collection_height;
    [self.collection reloadData];
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.info.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBZJ_ComCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    if (self.info.video.length>0 && indexPath.row==0) {
        cell.isVideo = YES;
    }else{
        cell.isVideo = NO;
    }
    [cell setModelWithModel:self.info.pics[indexPath.row]];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.info.video.length>0 && indexPath.row==0) {//这就是视频
        NSLog(@"视频");
        NSString *webVideoPath = self.info.video;
        NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
        //步骤2：创建AVPlayer
        AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
        //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
        AVPlayerViewController *avPlayerVC = [[AVPlayerViewController alloc] init];
        avPlayerVC.player = avPlayer;
     
        [self.viewController presentViewController:avPlayerVC animated:YES completion:^{
            [avPlayer play];
        }];
        
    }else{
        NSMutableArray *photos = [NSMutableArray new];
        [self.info.pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GKPhoto *photo = [GKPhoto new];
            photo.url = [NSURL URLWithString:obj];
            [photos addObject:photo];
        }];
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:indexPath.row];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
        browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
        [browser showFromVC:self.viewController];
    }
}

#pragma mark  - action
- (IBAction)gotoGoodDetail:(UIButton *)sender {
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:self.info.sku];
    detail.pt = self.info.pt;
    [self.viewController.navigationController pushViewController:detail animated:YES];
}

- (IBAction)goTobuy:(UIButton *)sender {
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.info.sku,@"token":ToKen,@"v":APP_Version};
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
            }else  if (code == UnauthCode) {
                GoToAuth_View *auth = [GoToAuth_View viewFromXib];
                [auth setAuthInfo];
                auth.cur_vc = self.viewController;
                auth.navi_vc = self.viewController.navigationController;
                [auth showInWindowWithBackgoundTapDismissEnable:NO];
            }else{
                [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            [YJProgressHUD showAlertTipsWithError:error];
        }];
    }
}


#pragma mark  - private
- (UICollectionViewFlowLayout *)threeLayout{
    if (!_threeLayout) {
        _threeLayout = [[UICollectionViewFlowLayout alloc] init];
        _threeLayout.minimumLineSpacing = 5 ;
        _threeLayout.minimumInteritemSpacing = 5;
        _threeLayout.itemSize = CGSizeMake(90, 90);
    }
    return _threeLayout;
}

- (NSMutableAttributedString *)priceStrWithStr1:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3{
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    [mustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:RGBColor(51, 51, 51)} range:NSMakeRange(0, str1.length)];
    
    [mustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSForegroundColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSStrikethroughColorAttributeName value:RGBColor(153, 153, 153) range:NSMakeRange(str1.length + str2.length, str3.length)];
    [mustr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(str1.length + str2.length, str3.length)];
    return mustr;
}

- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (void)openTbWithUrl:(NSString *)url{
[HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
}

@end
