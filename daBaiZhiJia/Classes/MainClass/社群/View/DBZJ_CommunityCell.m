//
//  DBZJ_CommunityCell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/25.
//  Copyright © 2019 包强. All rights reserved.
//

#import "DBZJ_CommunityCell.h"
#import "DBZJ_CommunityModel.h"
#import "IndexButton.h"
#import "GoodDetailContrl.h"
#import "GKPhotoBrowser.h"
#import "DBZJ_ComCollectionCell.h"
#import <AVKit/AVKit.h>
#import "CreateshareBottom.h"
#import "GoodDetailContrl.h"
#import "DBZJ_ComShareView.h"
#import "LoginContrl.h"

@interface DBZJ_CommunityCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bg_V;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;
@property (weak, nonatomic) IBOutlet UIView *shareV;

@property (weak, nonatomic) IBOutlet UILabel *sharePro;
@property (weak, nonatomic) IBOutlet UIView *cpV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareV_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareV_Bot;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpV_H;

@property (nonatomic, strong) UICollectionViewFlowLayout *threeLayout;//一排两个视图



@property (nonatomic, strong) CommunityRecommendInfo *comInfo;
@end
static NSString *cellid=  @"cellid";
@implementation DBZJ_CommunityCell


- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.bg_V, 7, UIColor.clearColor);
    ViewBorderRadius(self.detailBtn, 5, UIColor.clearColor);
    ViewBorderRadius(self.shareV, self.shareV.height*0.5, UIColor.clearColor);
    ViewBorderRadius(self.cpV, self.cpV.height*0.5, UIColor.clearColor);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collection.dataSource = self;
    self.collection.delegate  = self;
    self.collection.collectionViewLayout = self.threeLayout;
    self.collection.scrollEnabled = NO;
    [self.collection registerNib:[UINib nibWithNibName:@"DBZJ_ComCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellid];
    
}

#pragma mark - UICollectionViewDataSource&UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.comInfo.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBZJ_ComCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    if ( self.comInfo.type ==2 && ![self.comInfo.live_url strIsEmptyOrNot]&& indexPath.row == 0) {
        cell.isVideo = YES;
    }else{
         cell.isVideo = NO;
    }
    if (self.comInfo.pics.count==1) {
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
    }
    [cell setModelWithModel:self.comInfo.pics[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake(self.comInfo.item_width, self.comInfo.item_height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"indexPath %@",indexPath);
    if (self.comInfo.type ==2&& ![self.comInfo.live_url strIsEmptyOrNot] && indexPath.row == 0) {//这就是视频
        NSLog(@"视频");
        NSString *webVideoPath = self.comInfo.live_url;
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
        [self.comInfo.pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark - setinfo
- (void)setInfoWithModel:(id)model{
    CommunityRecommendInfo *info = model;
    self.comInfo = model;
    if (info.type ==1) {
        self.name.text = info.itemtitle;
         self.headImage.image = info.pt == 1?ZDBImage(@"sq_tianmaot"):ZDBImage(@"img_sqtaobao");
        [self.detailBtn setTitle:@"查看详情>" forState:UIControlStateNormal];
        self.shareV_H.constant = 28;
        self.shareV_Bot.constant = 15;
        self.cpV.hidden = NO;
    }else{
        self.name.text = info.title;
        self.headImage.image = ZDBImage(@"img_fanliyasq");
        [self.detailBtn setTitle:@"分享" forState:UIControlStateNormal];
        self.shareV_H.constant = 0;
        self.shareV_Bot.constant = 0;
        self.cpV.hidden = YES;
    }
  
    self.time.text = info.time;
     NSString *text =  info.type ==1 ? info.title:info.content;
     NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
      paraStyle.lineSpacing = 6.0;
    self.content.attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@(2)}];
    
    [self.collection reloadData];
    
    self.collectionW.constant = info.collection_width;
    self.collectionH.constant = info.collection_height;
    self.sharePro.text = [NSString stringWithFormat:@"分享可赚: ¥%@",info.profit];

}


#pragma mark - action
- (IBAction)shareAction:(UIButton *)sender {
    [self handleshare];
}


- (IBAction)gotoDetail:(UIButton *)sender {
    if (self.comInfo.type==1) {
        GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:self.comInfo.sku];
        [self.viewController.navigationController pushViewController:detail animated:YES];
    }else{
         [self handleshare];
    }
}

- (IBAction)copComAction:(UIButton *)sender {
    if (![self judgeisLogin]) {
        return;
    }
    NSDictionary *para = @{@"sku":self.comInfo.sku,@"token":ToKen,@"v":APP_Version};
    NSLog(@"para =%@",para);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getTao") parameters:para success:^(id responseObject) {
//          NSLog(@"tkl res=%@", responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
             [YJProgressHUD showMsgWithoutView:@"淘口令复制成功"];
            NSDictionary *data = responseObject[@"data"];
            [UIPasteboard generalPasteboard].string=  [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"长按復至%@➡[掏✔寳]即可抢购",data[@"tkl"]];
        }else{
            if (code == Token_isInvalidCode) {
                  [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
            }
          
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
    
}

#pragma mark - private
- (void)handleshare{
    [self delayDoWork:0.2 WithBlock:^{
        [YJProgressHUD showMsgWithoutView:@"文案内容已复制成功"];
    }];
    [UIPasteboard generalPasteboard].string = self.comInfo.type==1 ?self.comInfo.title:self.comInfo.content;
    
    DBZJ_ComShareView *share = [DBZJ_ComShareView viewFromXib];
    share.isFrom_sheQu = YES;
    share.frame  = self.viewController.view.bounds;
    share.cur_vc = self.viewController;
    share.model = self.comInfo;
    [share show];
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

#pragma mark - getter
- (UICollectionViewFlowLayout *)threeLayout{
    if (!_threeLayout) {
        _threeLayout = [[UICollectionViewFlowLayout alloc] init];
        _threeLayout.minimumLineSpacing = 10;
        _threeLayout.minimumInteritemSpacing = 10;
    }
    return _threeLayout;
}
@end
