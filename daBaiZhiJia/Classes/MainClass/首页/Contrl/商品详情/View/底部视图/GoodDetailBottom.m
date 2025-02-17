//
//  GoodDetailBottom.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/4/20.
//  Copyright © 2019 包强. All rights reserved.
//

#import "GoodDetailBottom.h"
#import "GoToAuth_View.h"
#import "GoodDetailModel.h"
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "DetailWebContrl.h"
#import <JDSDK/KeplerApiManager.h>

@interface GoodDetailBottom ()
@property (weak, nonatomic) IBOutlet UIButton *shouCangBtn;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *collectionLb;
@property (weak, nonatomic) IBOutlet UIView *tipsV;

@property (weak, nonatomic) IBOutlet UILabel *tipsLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLead;

@property (nonatomic, strong) NSString *sku;

@property (nonatomic, strong)  GoodDetailInfo *detailInfo;

@property (nonatomic, assign) BOOL isCollec;
@end
@implementation GoodDetailBottom

- (void)awakeFromNib{
    [super awakeFromNib];
//    if (IS_iPhone5SE) {
//        self.tipsLead.constant = 60;
//    }else if (IS_iPhone6plus){
//        self.tipsLead.constant = 105;
//    }else{
//        self.tipsLead.constant = 74;
//    }
}

- (void)setInfo:(id)info{
   
    GoodDetailInfo *detail = info;
    self.detailInfo = info;
     self.sku = detail.sku;
    [self.vipBtn setTitle:[NSString stringWithFormat:@"分享赚¥%@",detail.share_profit] forState:UIControlStateNormal];
    NSString *pro = [NSString stringWithFormat:@"%.2f",(detail.profit.doubleValue+detail.coupon_amount.doubleValue)];
    [self.buyBtn setTitle:[NSString stringWithFormat:@"自购省¥%@",pro] forState:UIControlStateNormal];
   
}


- (void)handleIsCollection:(BOOL)isCollec{
    self.isCollec = isCollec;
    NSString *title = isCollec ?@"已收藏":@"收藏";
    NSString *imageName = isCollec?@"icon_after_colloection":@"icon_befor_collection";
    self.collectionLb.text = title;
    [self.shouCangBtn setImage:ZDBImage(imageName) forState:UIControlStateNormal];
}


#pragma mark - action;
- (IBAction)gotoHome:(UIButton *)sender {
    [self.viewController.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)shouCangAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        if (!self.isCollec) {
             [self shouCangReuest];
        }else{
            [self cancleCollection];
        }
    }
}

- (IBAction)shengjiAction:(UIButton *)sender {
    
    if ([self judgeisLogin]) {
        if (self.detailInfo.pt == FLYPT_Type_Pdd||self.detailInfo.pt == FLYPT_Type_JD) {
            CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.detailInfo.sku];
            share.pt = self.detailInfo.pt;
            [self.viewController.navigationController pushViewController:share animated:YES];
            return;
        }
        
        //淘宝和天猫
        [CreateShare_Model geneRateTaoKlWithSku:self.detailInfo.sku vc:self.viewController  navi_vc:self.viewController.navigationController  block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.detailInfo.sku];
                share.pt = self.detailInfo.pt;
                [self.viewController.navigationController pushViewController:share animated:YES];
            }
        }];
    }
}


- (IBAction)buyAction:(UIButton *)sender {
    //清空剪贴板
    [UIPasteboard generalPasteboard].string = @"";
    if ([self judgeisLogin]) {
        if (self.detailInfo.pt == FLYPT_Type_Pdd) {
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
        }else if (self.detailInfo.pt == FLYPT_Type_JD){
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

- (IBAction)closeAction:(UIButton *)sender {
    self.tipsV.hidden = YES;
}


#pragma mark - private
- (void)openTbWithUrl:(NSString *)url{
     [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
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

//加入收藏
- (void)shouCangReuest{
    NSDictionary *para = @{@"sku":self.detailInfo.sku, @"token":ToKen, @"pt":@(self.detailInfo.pt), @"title":self.detailInfo.title, @"pic":self.detailInfo.pic, @"market_price":self.detailInfo.market_price, @"price":self.detailInfo.price, @"commission_money":self.detailInfo.commission_money,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/addFavorite") parameters:para success:^(id responseObject) {
        NSLog(@"responseObject %@",responseObject);
          NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
            self.isCollec = YES;
            self.collectionLb.text = @"已收藏";
            [self.shouCangBtn setImage:ZDBImage(@"icon_after_colloection") forState:UIControlStateNormal];
            [YJProgressHUD showMsgWithoutView:@"收藏成功"];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"error  %@",error);
    }];
}

- (void)cancleCollection{
    NSDictionary *para = @{@"skus":self.detailInfo.sku , @"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/updateFavorite") parameters:para success:^(id responseObject) {
        NSLog(@"cancleCollection rs= %@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {
              self.isCollec = NO;
             self.collectionLb.text = @"收藏";
            [self.shouCangBtn setImage:ZDBImage(@"icon_befor_collection") forState:UIControlStateNormal];
            [YJProgressHUD showMsgWithoutView:@"取消收藏成功"];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
        NSLog(@"error  %@",error);
    }];
    
}
@end
