//
//  PlayVideo_Cell.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "PlayVideo_Cell.h"

#import "IndexButton.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "GoodDetailContrl.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "UIImage+MZImagepProcessing.h"
#import "PlayVideo_ShareView.h"
#import "GoToAuth_View.h"

@interface PlayVideo_Cell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *returnTop;
@property (weak, nonatomic) IBOutlet UILabel *playNum;
@property (weak, nonatomic) IBOutlet IndexButton *wenAnBtn;

@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIImageView *pt;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *soldNum;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *shareLb;
@property (weak, nonatomic) IBOutlet UILabel *shengJiLb;
@property (weak, nonatomic) IBOutlet UIButton *diccount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowImage;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *gotoBuy;

@end
@implementation PlayVideo_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.contentV, 5, UIColor.clearColor);
    self.yellowImage.constant =  self.yellowImage.constant*SCALE_Normal;
    ViewBorderRadius(self.shareLb, self.shareLb.height/2, UIColor.clearColor);
    ViewBorderRadius(self.shengJiLb, self.shengJiLb.height/2, UIColor.clearColor);
    self.returnTop.constant += Height_StatusBar;
}

- (void)setInfoModel:(id)model{
    SearchResulGoodInfo *info = model;
    self.info = info;
    self.soldNum.text = info.sold_num;

    if (info.coverImage) {
          self.goodImage.image = info.coverImage;
    }else{
        [self.goodImage setDefultPlaceholderWithFullPath:info.pic];
    }
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
    self.playNum.text = info.playNum;
    self.price.attributedText = [self priceStrWithStr1:@"¥" str2:[NSString stringWithFormat:@"%@  ",info.price] str3:info.market_price];
     [self.diccount setTitle:[NSString stringWithFormat:@"¥%@",info.discount] forState:UIControlStateNormal];
    self.shareLb.text = [NSString stringWithFormat:@"分享赚%@",info.profit];
    self.shengJiLb.text = [NSString stringWithFormat:@"%@%@",info.shengji_str,info.profit_up];
    self.gotoBuy.text = @"去\n购\n买";
}

#pragma mark -action

- (IBAction)returnAction:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}


- (IBAction)wenAnAction:(IndexButton *)sender {
    if (![self judgeisLogin]) {
        return;
    }
    NSLog(@"");
    NSDictionary *para = @{@"sku":self.info.sku,@"token":ToKen,@"v":APP_Version};
    NSLog(@"para =%@",para);
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getTao") parameters:para success:^(id responseObject) {
        NSLog(@"tkl res=%@", responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            NSDictionary *data = responseObject[@"data"];
            NSString *shorturl = data [@"shorturl"];
            NSString *content = [NSString stringWithFormat:@"%@\n【下单地址】%@",self.info.des,shorturl];
            PlayVideo_ShareView *share = [PlayVideo_ShareView viewFromXib];
            [share setContentStr:content];
            [share showInWindowWithBackgoundTapDismissEnable:YES];
        }else if (code == UnauthCode){
            GoToAuth_View *auth = [GoToAuth_View viewFromXib];
            [auth setAuthInfo];
            auth.cur_vc = self.viewController;
            auth.navi_vc = self.viewController.navigationController;
            [auth showInWindowWithBackgoundTapDismissEnable:NO];
        }else{
             [YJProgressHUD showMsgWithoutView:responseObject[@"msg"]];
        }

       
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

- (IBAction)shareBtn:(IndexButton *)sender {
        NSLog(@"");
    if ([self judgeisLogin]) {
        [CreateShare_Model geneRateTaoKlWithSku:self.info.sku  vc:self.viewController navi_vc:self.viewController.navigationController  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.info.sku ];
                
                [self.viewController.navigationController pushViewController:share animated:YES];
            }
        }];
    }
}

- (IBAction)gotoDetail:(UIButton *)sender {
    GoodDetailContrl *detail = [[GoodDetailContrl alloc] initWithSku:self.info.sku];
    detail.pt = self.info.pt;
    [self.viewController.navigationController pushViewController:detail animated:YES];
}

- (IBAction)gotoBuy:(UIButton *)sender {
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

#pragma mark  - private
- (NSMutableAttributedString *)priceStrWithStr1:(NSString *)str1 str2:(NSString *)str2 str3:(NSString *)str3{
     NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str3]];
    [mustr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:RGBColor(51, 51, 51)} range:NSMakeRange(0, str1.length)];
    
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
