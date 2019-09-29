//
//  TMcxAndTMgj_GoodBottomV.m
//  daBaiZhiJia
//
//  Created by 包强 on 2019/6/19.
//  Copyright © 2019 包强. All rights reserved.
//

#import "TMcxAndTMgj_GoodBottomV.h"
#import "GoodDetailModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "CreateShareContrl.h"
#import "CreateShare_Model.h"
#import "LoginContrl.h"
#import "GoToAuth_View.h"

@interface TMcxAndTMgj_GoodBottomV ()

@property (weak, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *selfBuyBtn;
@end


@implementation TMcxAndTMgj_GoodBottomV

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewBorderRadius(self.checkBtn, self.checkBtn.height*0.5, UIColor.clearColor);
}

#pragma mark - action

- (IBAction)checkAction:(UIButton *)sender {
     NSDictionary *dic = @{@"sku":self.sku,@"token":ToKen,@"v":APP_Version};
    [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getGoodsDetail") parameters:dic success:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == SucCode) {  //
            GoodDetailInfo *info = [GoodDetailInfo mj_objectWithKeyValues:responseObject[@"data"]];
            self.checkBtn.hidden = YES;
            [self.shareBtn setTitle:[NSString stringWithFormat:@"分享赚¥%@",info.share_profit] forState:UIControlStateNormal];
             [self.selfBuyBtn setTitle:[NSString stringWithFormat:@"自购省¥%@",info.profit] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        [YJProgressHUD showAlertTipsWithError:error];
    }];
}

- (IBAction)shareAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        [CreateShare_Model geneRateTaoKlWithSku:self.sku vc:self.viewController navi_vc:self.viewController.navigationController block:^(NSString *tkl, NSString *code, NSString *shorturl) {
            if (tkl) {
                CreateShareContrl *share = [[CreateShareContrl alloc] initWithSku:self.sku];
                share.pt = FLYPT_Type_TM;
                [self.viewController.navigationController pushViewController:share animated:YES];
            }
        }];
    }
}


- (IBAction)buyAction:(UIButton *)sender {
    if ([self judgeisLogin]) {
        NSDictionary *dict = @{@"sku":self.sku,@"token":ToKen,@"v":APP_Version};
        @weakify(self);
        [PPNetworkHelper POST:URL_Add(@"/v.php/goods.goods/getCoupon") parameters:dict success:^(id responseObject) {
            @strongify(self);
            NSLog(@"领取优惠券responseObject  %@",responseObject);
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == SucCode) {
                NSString *url = responseObject[@"data"];
                if ([url containsString:@"http"]) {//url
                      [self openTbWithUrl:url];
                }else{//tkl
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

#pragma mark - private
- (BOOL)judgeisLogin{
    NSString *token = ToKen;
    if (User_ID >0 &&token.length > 0) {
        return YES;
    }else{
        NSLog(@"navigationController %@",self.viewController.navigationController);
        [self.viewController.navigationController pushViewController:[LoginContrl new] animated:YES];
        return NO;
    }
}

- (void)openTbWithUrl:(NSString *)url{
    [HandelTaoBaoTradeManager openTaoBaoAndTraWithUrl:url navi:self.viewController.navigationController];
}

@end
